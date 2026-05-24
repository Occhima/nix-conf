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
      session_picker_enter = "current-terminal";
    };

    dictation = {
      command = "";
      mode = "send";
      key = "off";
      timeout_secs = 90;
    };

    display = {
      diff_mode = "pinned";
      queue_mode = true;
      auto_server_reload = true;
      mouse_capture = true;
      debug_socket = false;
      centered = false;
      show_thinking = true;
      diagram_mode = "pinned";
      markdown_spacing = "document";
      pin_images = true;
      idle_animation = true;
      prompt_entry_animation = true;
      disabled_animations = [ ];
      diff_line_wrap = true;
      performance = "full";
      animation_fps = 120;
      redraw_fps = 120;
      prompt_preview = true;
      native_scrollbars = {
        chat = true;
        side_panel = true;
      };
    };

    features = {
      memory = true;
      swarm = true;
      message_timestamps = true;
      update_channel = "stable";
    };

    auth = {
      trusted_external_sources = [ ];
    };

    provider = {
      openai_reasoning_effort = "high";
      openai_native_compaction_mode = "auto";
      openai_native_compaction_threshold_tokens = 200000;
      cross_provider_failover = "countdown";
      same_provider_account_failover = true;
    };

    providers = { };

    agents = {
      memory_sidecar_enabled = false;
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
      bind_addr = "0.0.0.0";
    };

    compaction = {
      mode = "reactive";
      lookahead_turns = 15;
      ewma_alpha = 0.30000001192092896;
      proactive_floor = 0.4000000059604645;
      min_samples = 3;
      stall_window = 5;
      min_turns_between_compactions = 10;
      topic_shift_threshold = 0.44999998807907104;
      relevance_keep_threshold = 0.6499999761581421;
      goal_window_turns = 5;
    };

    autoreview = {
      enabled = false;
    };

    autojudge = {
      enabled = false;
    };
  };
in
{
  config = mkIf (cfg.enable && builtins.elem "jcode" cfg.tools) {
    home.packages = [ pkg ];

    xdg.configFile."jcode/config.toml".source = tomlFormat.generate "jcode-config" settings;
  };
}
