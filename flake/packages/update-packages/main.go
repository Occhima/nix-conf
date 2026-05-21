package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"sync"

	"github.com/charmbracelet/huh"
	"github.com/charmbracelet/huh/spinner"
	"github.com/charmbracelet/lipgloss"
)

const fakeHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

var (
	smuted  = lipgloss.NewStyle().Foreground(lipgloss.Color("245"))
	sok     = lipgloss.NewStyle().Foreground(lipgloss.Color("76"))
	swarn   = lipgloss.NewStyle().Foreground(lipgloss.Color("214"))
	sfail   = lipgloss.NewStyle().Foreground(lipgloss.Color("196"))
	saccent = lipgloss.NewStyle().Foreground(lipgloss.Color("212"))
	sbold   = lipgloss.NewStyle().Bold(true)
)

type pkgKind string

const (
	kNpm   pkgKind = "npm"
	kRust  pkgKind = "rust"
	kGo    pkgKind = "go"
	kOther pkgKind = "other"
)

type pkg struct {
	name        string
	file        string
	owner       string
	repo        string
	kind        pkgKind
	curVer      string
	newVer      string
	curRev      string
	newRev      string
	needsUpdate bool
	tagBased    bool
}

var (
	reOwner   = regexp.MustCompile(`owner\s*=\s*"([^"]+)"`)
	reRepo    = regexp.MustCompile(`repo\s*=\s*"([^"]+)"`)
	reVersion = regexp.MustCompile(`version\s*=\s*"([^"]+)"`)
	reRev     = regexp.MustCompile(`rev\s*=\s*"([^"]+)"`)
	reHash    = regexp.MustCompile(`hash\s*=\s*"([^"]+)"`)
	reTagRev  = regexp.MustCompile(`rev\s*=\s*"v?\$\{version\}"`)
	reGotHash = regexp.MustCompile(`got:\s+(sha256-\S+)`)
)

func first(re *regexp.Regexp, s string) string {
	if m := re.FindStringSubmatch(s); len(m) > 1 {
		return m[1]
	}
	return ""
}

func detectKind(content string) pkgKind {
	switch {
	case strings.Contains(content, "buildNpmPackage"):
		return kNpm
	case strings.Contains(content, "buildRustPackage"):
		return kRust
	case strings.Contains(content, "buildGoModule"), strings.Contains(content, "buildGoPackage"):
		return kGo
	default:
		return kOther
	}
}

func secondaryKey(k pkgKind, content string) string {
	switch k {
	case kNpm:
		return "npmDepsHash"
	case kRust:
		if strings.Contains(content, "cargoHash") {
			return "cargoHash"
		}
		return "vendorHash"
	case kGo:
		return "vendorHash"
	default:
		return ""
	}
}

func secondaryVal(key, content string) string {
	if key == "" {
		return ""
	}
	re := regexp.MustCompile(key + `\s*=\s*"([^"]+)"`)
	if m := re.FindStringSubmatch(content); len(m) > 1 {
		return m[1]
	}
	return ""
}

func sh(name string, args ...string) (string, error) {
	out, err := exec.Command(name, args...).Output()
	return strings.TrimSpace(string(out)), err
}

func flakeRoot() string {
	root, err := sh("git", "rev-parse", "--show-toplevel")
	if err != nil {
		fmt.Fprintln(os.Stderr, sfail.Render("✗ not in a git repo"))
		os.Exit(1)
	}
	return root
}

func latestRelease(owner, repo string) string {
	tag, err := sh("gh", "api",
		fmt.Sprintf("repos/%s/%s/releases/latest", owner, repo),
		"--jq", ".tag_name")
	if err != nil || tag == "" || tag == "null" {
		return ""
	}
	return strings.TrimPrefix(tag, "v")
}

func latestCommit(owner, repo string) string {
	sha, _ := sh("gh", "api",
		fmt.Sprintf("repos/%s/%s/commits/HEAD", owner, repo),
		"--jq", ".sha")
	return sha
}

func npmRemoteVersion(owner, repo string) string {
	b64, err := sh("gh", "api",
		fmt.Sprintf("repos/%s/%s/contents/package.json", owner, repo),
		"--jq", ".content")
	if err != nil {
		return ""
	}
	raw, err := base64.StdEncoding.DecodeString(strings.ReplaceAll(b64, "\n", ""))
	if err != nil {
		return ""
	}
	var pkgJSON struct {
		Version string `json:"version"`
	}
	if err := json.Unmarshal(raw, &pkgJSON); err != nil {
		return ""
	}
	return pkgJSON.Version
}

func scan(pkgDir string) []*pkg {
	entries, err := os.ReadDir(pkgDir)
	if err != nil {
		fmt.Fprintln(os.Stderr, sfail.Render("✗ cannot read "+pkgDir))
		os.Exit(1)
	}

	var result []*pkg
	for _, e := range entries {
		if !e.IsDir() {
			continue
		}
		file := filepath.Join(pkgDir, e.Name(), "package.nix")
		data, err := os.ReadFile(file)
		if err != nil {
			continue
		}
		content := string(data)
		if !strings.Contains(content, "fetchFromGitHub") {
			continue
		}
		owner := first(reOwner, content)
		repo := first(reRepo, content)
		if owner == "" || repo == "" {
			continue
		}
		result = append(result, &pkg{
			name:     e.Name(),
			file:     file,
			owner:    owner,
			repo:     repo,
			kind:     detectKind(content),
			curVer:   first(reVersion, content),
			curRev:   first(reRev, content),
			tagBased: reTagRev.MatchString(content),
		})
	}
	return result
}

func fetchUpstream(p *pkg) {
	if p.tagBased {
		v := latestRelease(p.owner, p.repo)
		p.newVer = v
		p.newRev = "v" + v
		p.needsUpdate = v != "" && v != p.curVer
	} else {
		sha := latestCommit(p.owner, p.repo)
		p.newRev = sha
		p.newVer = p.curVer
		if p.kind == kNpm {
			if v := npmRemoteVersion(p.owner, p.repo); v != "" {
				p.newVer = v
			}
		}
		n := min(40, min(len(p.curRev), len(sha)))
		p.needsUpdate = sha != "" && n > 0 && sha[:n] != p.curRev[:n]
	}
}

func short(s string) string {
	if len(s) > 8 {
		return s[:8]
	}
	return s
}

func printTable(pkgs []*pkg) {
	maxName := 7 // len("package")
	for _, p := range pkgs {
		if len(p.name) > maxName {
			maxName = len(p.name)
		}
	}

	fmt.Printf("  %-*s  %-5s  %-12s  %-12s  %s\n",
		maxName, "package", "type", "current", "latest", "status")
	fmt.Println(smuted.Render("  " + strings.Repeat("─", maxName+2+5+2+12+2+12+2+8)))

	for _, p := range pkgs {
		cur := p.curVer
		if cur == "" {
			cur = short(p.curRev)
		}

		var latest, status string
		if p.needsUpdate {
			latest = p.newVer
			if latest == "" {
				latest = short(p.newRev)
			}
			status = saccent.Render("↑ update")
		} else {
			status = sok.Render("✓ ok")
		}

		fmt.Printf("  %-*s  %s  %-12s  %-12s  %s\n",
			maxName, p.name,
			smuted.Render(fmt.Sprintf("%-5s", string(p.kind))),
			cur,
			latest,
			status,
		)
	}
}

func updateOne(p *pkg, root string) error {
	fmt.Println()
	fmt.Println(sbold.Render("  " + p.name))

	data, err := os.ReadFile(p.file)
	if err != nil {
		return err
	}
	content := string(data)

	curHash := first(reHash, content)
	secKey := secondaryKey(p.kind, content)
	curSec := secondaryVal(secKey, content)

	// 1. fetch new source hash
	var newHash string
	if err := spinner.New().
		Title("  fetching source hash...").
		Action(func() {
			out, e := sh("nix-prefetch-github", p.owner, p.repo, "--rev", p.newRev)
			if e != nil {
				return
			}
			var result struct {
				Hash string `json:"hash"`
			}
			if e2 := json.Unmarshal([]byte(out), &result); e2 == nil {
				newHash = result.Hash
			}
		}).
		Run(); err != nil {
		return err
	}

	if newHash == "" {
		fmt.Println(sfail.Render("  ✗ could not fetch source hash"))
		return fmt.Errorf("hash fetch failed for %s", p.name)
	}

	// 2. patch version/rev and source hash
	if p.tagBased {
		content = strings.ReplaceAll(content,
			fmt.Sprintf(`version = "%s"`, p.curVer),
			fmt.Sprintf(`version = "%s"`, p.newVer))
	} else {
		content = strings.ReplaceAll(content,
			fmt.Sprintf(`rev = "%s"`, p.curRev),
			fmt.Sprintf(`rev = "%s"`, p.newRev))
		if p.newVer != p.curVer && p.newVer != "" {
			content = strings.ReplaceAll(content,
				fmt.Sprintf(`version = "%s"`, p.curVer),
				fmt.Sprintf(`version = "%s"`, p.newVer))
		}
	}
	content = strings.ReplaceAll(content, curHash, newHash)
	if err := os.WriteFile(p.file, []byte(content), 0644); err != nil {
		return err
	}
	fmt.Println(sok.Render("  ✓ source hash updated"))

	// 3. secondary hash (npmDepsHash / cargoHash / vendorHash)
	if secKey != "" && curSec != "" {
		content = strings.ReplaceAll(content, curSec, fakeHash)
		if err := os.WriteFile(p.file, []byte(content), 0644); err != nil {
			return err
		}
		exec.Command("git", "-C", root, "add", p.file).Run() //nolint

		var newSec string
		spinner.New(). //nolint
				Title(fmt.Sprintf("  computing %s...", secKey)).
			Action(func() {
				cmd := exec.Command("nix", "build", fmt.Sprintf(".#%s", p.name), "--no-link")
				cmd.Dir = root
				out, _ := cmd.CombinedOutput()
				if m := reGotHash.FindSubmatch(out); len(m) > 1 {
					newSec = string(m[1])
				}
			}).
			Run()

		if newSec == "" {
			fmt.Println(swarn.Render(fmt.Sprintf("  ⚠ %s unresolved — fix manually", secKey)))
		} else {
			data2, _ := os.ReadFile(p.file)
			patched := strings.ReplaceAll(string(data2), fakeHash, newSec)
			if err := os.WriteFile(p.file, []byte(patched), 0644); err != nil {
				return err
			}
			fmt.Println(sok.Render(fmt.Sprintf("  ✓ %s updated", secKey)))
		}
	}

	if _, err := os.Stat(filepath.Join(filepath.Dir(p.file), "package-lock.json")); err == nil {
		fmt.Println(swarn.Render("  ⚠ vendored package-lock.json may need regenerating"))
	}

	exec.Command("git", "-C", root, "add", p.file).Run() //nolint

	// 4. verify build
	var buildOk bool
	spinner.New(). //nolint
			Title("  verifying build...").
		Action(func() {
			cmd := exec.Command("nix", "build", fmt.Sprintf(".#%s", p.name), "--no-link")
			cmd.Dir = root
			buildOk = cmd.Run() == nil
		}).
		Run()

	if buildOk {
		fmt.Println(sok.Render("  ✓ build verified"))
	} else {
		fmt.Println(sfail.Render("  ✗ build failed — inspect manually"))
	}

	return nil
}

func main() {
	root := flakeRoot()
	pkgDir := filepath.Join(root, "flake", "packages")

	fmt.Println(smuted.Render("update-packages · " + pkgDir))
	fmt.Println()

	pkgs := scan(pkgDir)
	if len(pkgs) == 0 {
		fmt.Println(smuted.Render("  no fetchFromGitHub packages found"))
		return
	}

	// parallel upstream fetch
	var wg sync.WaitGroup
	for _, p := range pkgs {
		wg.Add(1)
		go func(p *pkg) {
			defer wg.Done()
			fetchUpstream(p)
		}(p)
	}
	wg.Wait()

	printTable(pkgs)

	var updatable []*pkg
	for _, p := range pkgs {
		if p.needsUpdate {
			updatable = append(updatable, p)
		}
	}

	if len(updatable) == 0 {
		fmt.Println()
		fmt.Println(sok.Render("  all packages up to date"))
		return
	}

	fmt.Println()

	opts := make([]huh.Option[string], len(updatable))
	for i, p := range updatable {
		opts[i] = huh.NewOption(p.name, p.name)
	}

	var selected []string
	if err := huh.NewForm(
		huh.NewGroup(
			huh.NewMultiSelect[string]().
				Title("select packages to update").
				Options(opts...).
				Value(&selected),
		),
	).Run(); err != nil {
		return
	}

	if len(selected) == 0 {
		fmt.Println(smuted.Render("  nothing selected"))
		return
	}

	pkgMap := make(map[string]*pkg, len(updatable))
	for _, p := range updatable {
		pkgMap[p.name] = p
	}

	fmt.Println()
	for _, name := range selected {
		if err := updateOne(pkgMap[name], root); err != nil {
			fmt.Println(sfail.Render(fmt.Sprintf("  ✗ %v", err)))
		}
	}

	fmt.Println()
	fmt.Println(sok.Render("  done — run 'home-manager switch' to apply"))
}
