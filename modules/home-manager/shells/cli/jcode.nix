{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
  pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.jcode;

  tomlFormat = pkgs.formats.toml { };

  settings = {
    keybindings = {
      scroll_up = "ctrl+k";
      scroll_down = "ctrl+j";
      scroll_page_up = "ctrl+u";
      scroll_page_down = "ctrl+d";
      model_switch_next = "ctrl+p";
      model_switch_prev = "ctrl+shift+p";
      effort_increase = "ctrl+t";
      effort_decrease = "ctrl+shift+t";
      centered_toggle = "ctrl+shift+o";
      scroll_prompt_up = "ctrl+[";
      scroll_prompt_down = "ctrl+]";
      scroll_bookmark = "ctrl+g";
      scroll_up_fallback = "cmd+k";
      scroll_down_fallback = "cmd+j";
      workspace_left = "ctrl+shift+h";
      workspace_down = "ctrl+shift+j";
      workspace_up = "ctrl+shift+k";
      workspace_right = "ctrl+shift+l";
      side_panel_toggle = "alt+m";
      copy_selection_toggle = "alt+y";
      diagram_pane_toggle = "alt+t";
      typing_scroll_lock_toggle = "alt+s";
      diff_mode_cycle = "alt+g";
      info_widget_toggle = "alt+i";
      session_picker_enter = "current-terminal";
    };

    display = {
      diff_mode = "pinned";
      diagram_mode = "pinned";
      centered = false;
      queue_mode = true;
      auto_server_reload = true;
      mouse_capture = true;
      debug_socket = false;
      show_thinking = true;
      reasoning_display = "current";
      markdown_spacing = "document";
      pin_images = true;
      diff_line_wrap = true;
      prompt_preview = true;
      idle_animation = true;
      prompt_entry_animation = true;
      compact_notifications = true;
      show_agentgrep_output = false;
      performance = "full";
      animation_fps = 120;
      redraw_fps = 120;
      disabled_animations = [ ];
      native_scrollbars = {
        chat = true;
        side_panel = true;
      };
    };

    features = {
      memory = true;
      swarm = true;
      message_timestamps = true;
      persist_memory_injections = false;
      kv_cache_miss_notices = true;
      update_channel = "stable";
    };

    websearch = {
      engine = "duckduckgo";
      fallback_engines = [ "bing" ];
      bing_market = "en-US";
    };

    tools = {
      profile = "full";
      disabled = [ "gmail" ];
      disable_base_tools = false;
    };

    auth = {
      trusted_external_sources = [ ];
      trusted_external_source_paths = [ ];
    };

    provider = {
      openai_reasoning_effort = "high";
      anthropic_reasoning_effort = "high";
      openai_transport = "auto";
      openai_service_tier = "priority";
      openai_native_compaction_mode = "auto";
      openai_native_compaction_threshold_tokens = 200000;
      preserve_reasoning_context = true;
      cross_provider_failover = "countdown";
      same_provider_account_failover = true;
      copilot_premium = "zero";
    };

    providers = {
    };

    agents = {
      swarm_model = "inherit";
      swarm_spawn_mode = "inline";
      swarm_gallery_max_pct = 35;
      memory_sidecar_enabled = true;
      memory_rerank_cadence = 3;
      memory_rerank_judges = 2;
      memory_rerank_min_agree = 2;
    };

    ambient = {
      enabled = false;
      allow_api_keys = false;
      min_interval_minutes = 5;
      max_interval_minutes = 120;
      pause_on_active_session = true;
      proactive_work = true;
      work_branch_prefix = "ambient/";
      visible = true;
    };

    safety = {
      ntfy_server = "https://ntfy.sh";
      desktop_notifications = true;
      email_enabled = false;
      email_smtp_port = 587;
      email_imap_port = 993;
      email_reply_enabled = false;
      telegram_enabled = false;
      telegram_reply_enabled = false;
      discord_enabled = false;
      discord_reply_enabled = false;
    };

    gateway = {
      enabled = false;
      port = 7643;
      bind_addr = "127.0.0.1";
    };

    compaction = {
      mode = "reactive";
      lookahead_turns = 15;
      ewma_alpha = 0.3;
      proactive_floor = 0.4;
      min_samples = 3;
      stall_window = 5;
      min_turns_between_compactions = 10;
      topic_shift_threshold = 0.45;
      relevance_keep_threshold = 0.65;
      goal_window_turns = 5;
    };

    autoreview = {
      enabled = false;
    };

    autojudge = {
      enabled = false;
    };
  };

  configFile = tomlFormat.generate "jcode-config" settings;
in
{
  config = mkIf (cfg.enable && builtins.elem "jcode" cfg.tools) {
    home.packages = [ pkg ];

    home.file = {
      ".jcode/config.toml".source = configFile;
      ".config/agents/skills".source = "${self}/modules/home-manager/profiles/collection/ai/skills";
      ".config/AGENTS.md".source = "${self}/modules/home-manager/profiles/collection/ai/AGENTS.md";
    };
  };
}
