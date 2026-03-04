#!/usr/bin/env bash
# p10k-themes — Apply popular terminal theme colors to your Powerlevel10k prompt
# Only modifies prompt segment colors in ~/.p10k.zsh, nothing else.
#
# Usage:
#   ./p10k-themes.sh              # Interactive menu
#   ./p10k-themes.sh --list       # List available themes
#   ./p10k-themes.sh --theme 3    # Apply theme by number
#   ./p10k-themes.sh --restore    # Restore from backup

set -euo pipefail

P10K_CONFIG="${P10K_CONFIG:-$HOME/.p10k.zsh}"
BACKUP_DIR="$HOME/.p10k-backups"
BASELINE_FILE="${BACKUP_DIR}/p10k.zsh.baseline.bak"

# ── Cross-platform sed -i ────────────────────────────────────────────────────

sed_inplace() {
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

# ── Theme Names ──────────────────────────────────────────────────────────────

THEMES=(
  "Dracula"
  "Catppuccin Mocha"
  "Catppuccin Macchiato"
  "Catppuccin Frappé"
  "Catppuccin Latte"
  "Nord"
  "Gruvbox Dark"
  "Gruvbox Light"
  "Solarized Dark"
  "Solarized Light"
  "One Dark"
  "Tokyo Night"
  "Tokyo Night Storm"
  "Monokai"
  "Rosé Pine"
  "Rosé Pine Moon"
  "Kanagawa"
  "Everforest Dark"
  "Ayu Dark"
  "Material Dark"
)

# ── Theme Color Definitions ──────────────────────────────────────────────────
#
# Each theme defines two layers:
#
# 1) ANSI palette (c0–c8, c_orange): 256-color equivalents for ANSI 0–8 and
#    orange (208). These are applied globally to ALL segment FOREGROUND/BACKGROUND
#    values that use standard ANSI codes — this themes the right-side segments,
#    tool versions, cloud indicators, shell markers, time, context, vi mode, etc.
#
# 2) Core overrides: hand-tuned values for the most visible prompt segments
#    (dir, vcs, status, os_icon, prompt_char, exec_time, bg_jobs, gap,
#    time, context).  Applied after the global palette so they take precedence.

load_theme() {
  case "$1" in

    "Dracula")
      # Purple #bd93f9, Green #50fa7b, Yellow #f1fa8c, Red #ff5555
      # Cyan #8be9fd, Pink #ff79c6, Orange #ffb86c
      c0=236;  c1=203;  c2=84;   c3=228;  c4=141
      c5=212;  c6=117;  c7=253;  c8=240;  c_orange=215
      os_icon_fg=253;  os_icon_bg=141
      prompt_ok_fg=84;  prompt_error_fg=203
      dir_bg=141;  dir_fg=253;  dir_shortened_fg=189;  dir_anchor_fg=255
      vcs_clean_bg=84;  vcs_modified_bg=228;  vcs_untracked_bg=117
      vcs_conflicted_bg=203;  vcs_loading_bg=240
      status_ok_fg=84;  status_ok_bg=236
      status_error_fg=228;  status_error_bg=203
      exec_time_fg=236;  exec_time_bg=228
      bg_jobs_fg=117;  bg_jobs_bg=236
      gap_fg=240
      time_fg=253;  time_bg=240
      context_fg=215;  context_bg=236;  context_root_fg=203
      ;;

    "Catppuccin Mocha")
      # Blue #89b4fa, Green #a6e3a1, Yellow #f9e2af, Red #f38ba8
      # Mauve #cba6f7, Peach #fab387, Teal #94e2d5
      c0=234;  c1=211;  c2=151;  c3=223;  c4=111
      c5=183;  c6=116;  c7=189;  c8=240;  c_orange=216
      os_icon_fg=234;  os_icon_bg=183
      prompt_ok_fg=151;  prompt_error_fg=211
      dir_bg=111;  dir_fg=253;  dir_shortened_fg=189;  dir_anchor_fg=255
      vcs_clean_bg=151;  vcs_modified_bg=223;  vcs_untracked_bg=116
      vcs_conflicted_bg=211;  vcs_loading_bg=240
      status_ok_fg=151;  status_ok_bg=234
      status_error_fg=223;  status_error_bg=211
      exec_time_fg=234;  exec_time_bg=216
      bg_jobs_fg=116;  bg_jobs_bg=234
      gap_fg=240
      time_fg=189;  time_bg=240
      context_fg=216;  context_bg=234;  context_root_fg=211
      ;;

    "Catppuccin Macchiato")
      # Blue #8aadf4, Green #a6da95, Yellow #eed49f, Red #ed8796
      # Mauve #c6a0f6, Peach #f5a97f, Teal #8bd5ca
      c0=235;  c1=210;  c2=150;  c3=223;  c4=111
      c5=183;  c6=116;  c7=189;  c8=240;  c_orange=216
      os_icon_fg=235;  os_icon_bg=183
      prompt_ok_fg=150;  prompt_error_fg=210
      dir_bg=111;  dir_fg=253;  dir_shortened_fg=189;  dir_anchor_fg=255
      vcs_clean_bg=150;  vcs_modified_bg=223;  vcs_untracked_bg=116
      vcs_conflicted_bg=210;  vcs_loading_bg=240
      status_ok_fg=150;  status_ok_bg=235
      status_error_fg=223;  status_error_bg=210
      exec_time_fg=235;  exec_time_bg=216
      bg_jobs_fg=116;  bg_jobs_bg=235
      gap_fg=240
      time_fg=189;  time_bg=240
      context_fg=216;  context_bg=235;  context_root_fg=210
      ;;

    "Catppuccin Frappé")
      # Blue #8caaee, Green #a6d189, Yellow #e5c890, Red #e78284
      # Mauve #ca9ee6, Peach #ef9f76, Teal #81c8be
      c0=236;  c1=174;  c2=150;  c3=186;  c4=111
      c5=182;  c6=115;  c7=189;  c8=242;  c_orange=216
      os_icon_fg=236;  os_icon_bg=182
      prompt_ok_fg=150;  prompt_error_fg=174
      dir_bg=111;  dir_fg=253;  dir_shortened_fg=189;  dir_anchor_fg=255
      vcs_clean_bg=150;  vcs_modified_bg=186;  vcs_untracked_bg=115
      vcs_conflicted_bg=174;  vcs_loading_bg=242
      status_ok_fg=150;  status_ok_bg=236
      status_error_fg=186;  status_error_bg=174
      exec_time_fg=236;  exec_time_bg=186
      bg_jobs_fg=115;  bg_jobs_bg=236
      gap_fg=242
      time_fg=189;  time_bg=242
      context_fg=216;  context_bg=236;  context_root_fg=174
      ;;

    "Catppuccin Latte")
      # Blue #1e66f5, Green #40a02b, Yellow #df8e1d, Red #d20f39
      # Mauve #8839ef, Peach #fe640b, Teal #179299
      c0=238;  c1=160;  c2=34;   c3=172;  c4=27
      c5=92;   c6=30;   c7=255;  c8=250;  c_orange=202
      os_icon_fg=255;  os_icon_bg=92
      prompt_ok_fg=34;  prompt_error_fg=160
      dir_bg=27;  dir_fg=255;  dir_shortened_fg=252;  dir_anchor_fg=255
      vcs_clean_bg=34;  vcs_modified_bg=172;  vcs_untracked_bg=30
      vcs_conflicted_bg=160;  vcs_loading_bg=250
      status_ok_fg=34;  status_ok_bg=255
      status_error_fg=172;  status_error_bg=160
      exec_time_fg=255;  exec_time_bg=172
      bg_jobs_fg=30;  bg_jobs_bg=255
      gap_fg=250
      time_fg=238;  time_bg=250
      context_fg=202;  context_bg=255;  context_root_fg=160
      ;;

    "Nord")
      # Frost #5e81ac, Green #a3be8c, Yellow #ebcb8b, Red #bf616a
      # Purple #b48ead, Orange #d08770, Cyan #88c0d0
      c0=236;  c1=131;  c2=144;  c3=222;  c4=67
      c5=139;  c6=110;  c7=255;  c8=241;  c_orange=173
      os_icon_fg=255;  os_icon_bg=67
      prompt_ok_fg=144;  prompt_error_fg=131
      dir_bg=67;  dir_fg=255;  dir_shortened_fg=188;  dir_anchor_fg=255
      vcs_clean_bg=144;  vcs_modified_bg=222;  vcs_untracked_bg=110
      vcs_conflicted_bg=131;  vcs_loading_bg=241
      status_ok_fg=144;  status_ok_bg=236
      status_error_fg=222;  status_error_bg=131
      exec_time_fg=236;  exec_time_bg=222
      bg_jobs_fg=110;  bg_jobs_bg=236
      gap_fg=241
      time_fg=255;  time_bg=241
      context_fg=173;  context_bg=236;  context_root_fg=131
      ;;

    "Gruvbox Dark")
      # Blue #458588, Green #b8bb26, Yellow #fabd2f, Red #fb4934
      # Purple #d3869b, Aqua #8ec07c, Orange #fe8019
      c0=235;  c1=203;  c2=142;  c3=214;  c4=66
      c5=175;  c6=108;  c7=223;  c8=241;  c_orange=208
      os_icon_fg=223;  os_icon_bg=66
      prompt_ok_fg=142;  prompt_error_fg=203
      dir_bg=66;  dir_fg=223;  dir_shortened_fg=187;  dir_anchor_fg=223
      vcs_clean_bg=142;  vcs_modified_bg=214;  vcs_untracked_bg=108
      vcs_conflicted_bg=203;  vcs_loading_bg=241
      status_ok_fg=142;  status_ok_bg=235
      status_error_fg=214;  status_error_bg=203
      exec_time_fg=235;  exec_time_bg=214
      bg_jobs_fg=108;  bg_jobs_bg=235
      gap_fg=241
      time_fg=223;  time_bg=241
      context_fg=208;  context_bg=235;  context_root_fg=203
      ;;

    "Gruvbox Light")
      # Blue #076678, Green #98971a, Yellow #b57614, Red #9d0006
      # Purple #8f3f71, Aqua #427b58, Orange #af3a03
      c0=237;  c1=124;  c2=100;  c3=136;  c4=24
      c5=95;   c6=65;   c7=230;  c8=248;  c_orange=130
      os_icon_fg=230;  os_icon_bg=24
      prompt_ok_fg=100;  prompt_error_fg=124
      dir_bg=24;  dir_fg=230;  dir_shortened_fg=253;  dir_anchor_fg=255
      vcs_clean_bg=100;  vcs_modified_bg=136;  vcs_untracked_bg=65
      vcs_conflicted_bg=124;  vcs_loading_bg=250
      status_ok_fg=100;  status_ok_bg=230
      status_error_fg=136;  status_error_bg=124
      exec_time_fg=230;  exec_time_bg=136
      bg_jobs_fg=65;  bg_jobs_bg=230
      gap_fg=248
      time_fg=237;  time_bg=248
      context_fg=130;  context_bg=230;  context_root_fg=124
      ;;

    "Solarized Dark")
      # Blue #268bd2, Green #859900, Yellow #b58900, Red #dc322f
      # Magenta #d33682, Cyan #2aa198, Violet #6c71c4
      c0=234;  c1=160;  c2=106;  c3=136;  c4=33
      c5=162;  c6=37;   c7=254;  c8=240;  c_orange=166
      os_icon_fg=254;  os_icon_bg=33
      prompt_ok_fg=106;  prompt_error_fg=160
      dir_bg=33;  dir_fg=254;  dir_shortened_fg=246;  dir_anchor_fg=254
      vcs_clean_bg=106;  vcs_modified_bg=136;  vcs_untracked_bg=37
      vcs_conflicted_bg=160;  vcs_loading_bg=240
      status_ok_fg=106;  status_ok_bg=234
      status_error_fg=136;  status_error_bg=160
      exec_time_fg=234;  exec_time_bg=136
      bg_jobs_fg=37;  bg_jobs_bg=234
      gap_fg=240
      time_fg=254;  time_bg=240
      context_fg=166;  context_bg=234;  context_root_fg=160
      ;;

    "Solarized Light")
      # Same palette, light background
      c0=240;  c1=160;  c2=106;  c3=136;  c4=33
      c5=162;  c6=37;   c7=230;  c8=250;  c_orange=166
      os_icon_fg=230;  os_icon_bg=33
      prompt_ok_fg=106;  prompt_error_fg=160
      dir_bg=33;  dir_fg=230;  dir_shortened_fg=254;  dir_anchor_fg=255
      vcs_clean_bg=106;  vcs_modified_bg=136;  vcs_untracked_bg=37
      vcs_conflicted_bg=160;  vcs_loading_bg=252
      status_ok_fg=106;  status_ok_bg=230
      status_error_fg=136;  status_error_bg=160
      exec_time_fg=230;  exec_time_bg=136
      bg_jobs_fg=37;  bg_jobs_bg=230
      gap_fg=250
      time_fg=240;  time_bg=250
      context_fg=166;  context_bg=230;  context_root_fg=160
      ;;

    "One Dark")
      # Blue #61afef, Green #98c379, Yellow #e5c07b, Red #e06c75
      # Magenta #c678dd, Cyan #56b6c2
      c0=236;  c1=204;  c2=114;  c3=180;  c4=75
      c5=176;  c6=73;   c7=249;  c8=241;  c_orange=209
      os_icon_fg=236;  os_icon_bg=75
      prompt_ok_fg=114;  prompt_error_fg=204
      dir_bg=75;  dir_fg=253;  dir_shortened_fg=249;  dir_anchor_fg=255
      vcs_clean_bg=114;  vcs_modified_bg=180;  vcs_untracked_bg=73
      vcs_conflicted_bg=204;  vcs_loading_bg=241
      status_ok_fg=114;  status_ok_bg=236
      status_error_fg=180;  status_error_bg=204
      exec_time_fg=236;  exec_time_bg=180
      bg_jobs_fg=73;  bg_jobs_bg=236
      gap_fg=241
      time_fg=249;  time_bg=241
      context_fg=209;  context_bg=236;  context_root_fg=204
      ;;

    "Tokyo Night")
      # Blue #7aa2f7, Green #9ece6a, Yellow #e0af68, Red #f7768e
      # Magenta #bb9af7, Cyan #7dcfff, Orange #ff9e64
      c0=234;  c1=210;  c2=149;  c3=179;  c4=111
      c5=141;  c6=117;  c7=189;  c8=240;  c_orange=215
      os_icon_fg=189;  os_icon_bg=111
      prompt_ok_fg=149;  prompt_error_fg=210
      dir_bg=111;  dir_fg=253;  dir_shortened_fg=189;  dir_anchor_fg=255
      vcs_clean_bg=149;  vcs_modified_bg=179;  vcs_untracked_bg=117
      vcs_conflicted_bg=210;  vcs_loading_bg=240
      status_ok_fg=149;  status_ok_bg=234
      status_error_fg=179;  status_error_bg=210
      exec_time_fg=234;  exec_time_bg=179
      bg_jobs_fg=117;  bg_jobs_bg=234
      gap_fg=240
      time_fg=189;  time_bg=240
      context_fg=215;  context_bg=234;  context_root_fg=210
      ;;

    "Tokyo Night Storm")
      # Same palette, slightly lighter background
      c0=235;  c1=210;  c2=149;  c3=179;  c4=111
      c5=141;  c6=117;  c7=189;  c8=241;  c_orange=215
      os_icon_fg=189;  os_icon_bg=111
      prompt_ok_fg=149;  prompt_error_fg=210
      dir_bg=111;  dir_fg=253;  dir_shortened_fg=189;  dir_anchor_fg=255
      vcs_clean_bg=149;  vcs_modified_bg=179;  vcs_untracked_bg=117
      vcs_conflicted_bg=210;  vcs_loading_bg=241
      status_ok_fg=149;  status_ok_bg=235
      status_error_fg=179;  status_error_bg=210
      exec_time_fg=235;  exec_time_bg=179
      bg_jobs_fg=117;  bg_jobs_bg=235
      gap_fg=241
      time_fg=189;  time_bg=241
      context_fg=215;  context_bg=235;  context_root_fg=210
      ;;

    "Monokai")
      # Green #a6e22e, Yellow #f4bf75, Red #f92672, Purple #ae81ff
      # Cyan #66d9ef, Orange #fd971f
      c0=235;  c1=197;  c2=148;  c3=216;  c4=81
      c5=141;  c6=81;   c7=253;  c8=241;  c_orange=208
      os_icon_fg=253;  os_icon_bg=197
      prompt_ok_fg=148;  prompt_error_fg=197
      dir_bg=81;  dir_fg=253;  dir_shortened_fg=253;  dir_anchor_fg=255
      vcs_clean_bg=148;  vcs_modified_bg=208;  vcs_untracked_bg=81
      vcs_conflicted_bg=197;  vcs_loading_bg=241
      status_ok_fg=148;  status_ok_bg=235
      status_error_fg=216;  status_error_bg=197
      exec_time_fg=235;  exec_time_bg=208
      bg_jobs_fg=81;  bg_jobs_bg=235
      gap_fg=241
      time_fg=253;  time_bg=241
      context_fg=208;  context_bg=235;  context_root_fg=197
      ;;

    "Rosé Pine")
      # Iris #c4a7e7, Pine #31748f, Love #eb6f92, Gold #f6c177
      # Foam #9ccfd8, Rose #ebbcba
      c0=234;  c1=204;  c2=152;  c3=216;  c4=66
      c5=182;  c6=152;  c7=189;  c8=240;  c_orange=216
      os_icon_fg=234;  os_icon_bg=182
      prompt_ok_fg=115;  prompt_error_fg=204
      dir_bg=182;  dir_fg=234;  dir_shortened_fg=236;  dir_anchor_fg=234
      vcs_clean_bg=115;  vcs_modified_bg=216;  vcs_untracked_bg=152
      vcs_conflicted_bg=204;  vcs_loading_bg=240
      status_ok_fg=115;  status_ok_bg=234
      status_error_fg=216;  status_error_bg=204
      exec_time_fg=234;  exec_time_bg=216
      bg_jobs_fg=152;  bg_jobs_bg=234
      gap_fg=240
      time_fg=189;  time_bg=240
      context_fg=216;  context_bg=234;  context_root_fg=204
      ;;

    "Rosé Pine Moon")
      # Pine #3e8fb0, Love #eb6f92, Gold #f6c177, Foam #9ccfd8
      # Iris #c4a7e7, Rose #ea9a97
      c0=235;  c1=204;  c2=152;  c3=216;  c4=67
      c5=182;  c6=152;  c7=189;  c8=241;  c_orange=216
      os_icon_fg=235;  os_icon_bg=182
      prompt_ok_fg=152;  prompt_error_fg=204
      dir_bg=67;  dir_fg=189;  dir_shortened_fg=152;  dir_anchor_fg=255
      vcs_clean_bg=152;  vcs_modified_bg=216;  vcs_untracked_bg=182
      vcs_conflicted_bg=204;  vcs_loading_bg=241
      status_ok_fg=152;  status_ok_bg=235
      status_error_fg=216;  status_error_bg=204
      exec_time_fg=235;  exec_time_bg=216
      bg_jobs_fg=182;  bg_jobs_bg=235
      gap_fg=241
      time_fg=189;  time_bg=241
      context_fg=216;  context_bg=235;  context_root_fg=204
      ;;

    "Kanagawa")
      # Blue #7e9cd8, Green #76946a, Yellow #c0a36e, Red #c34043
      # Magenta #957fb8, Cyan #6a9589, Orange #ffa066
      c0=234;  c1=131;  c2=101;  c3=143;  c4=110
      c5=103;  c6=66;   c7=187;  c8=240;  c_orange=215
      os_icon_fg=187;  os_icon_bg=110
      prompt_ok_fg=101;  prompt_error_fg=131
      dir_bg=110;  dir_fg=253;  dir_shortened_fg=187;  dir_anchor_fg=255
      vcs_clean_bg=101;  vcs_modified_bg=143;  vcs_untracked_bg=66
      vcs_conflicted_bg=131;  vcs_loading_bg=240
      status_ok_fg=101;  status_ok_bg=234
      status_error_fg=143;  status_error_bg=131
      exec_time_fg=234;  exec_time_bg=143
      bg_jobs_fg=66;  bg_jobs_bg=234
      gap_fg=240
      time_fg=187;  time_bg=240
      context_fg=215;  context_bg=234;  context_root_fg=131
      ;;

    "Everforest Dark")
      # Blue #7fbbb3, Green #a7c080, Yellow #dbbc7f, Red #e67e80
      # Purple #d699b6, Aqua #83c092, Orange #e69875
      c0=236;  c1=174;  c2=144;  c3=180;  c4=109
      c5=175;  c6=108;  c7=187;  c8=241;  c_orange=174
      os_icon_fg=236;  os_icon_bg=109
      prompt_ok_fg=144;  prompt_error_fg=174
      dir_bg=109;  dir_fg=253;  dir_shortened_fg=187;  dir_anchor_fg=255
      vcs_clean_bg=144;  vcs_modified_bg=180;  vcs_untracked_bg=108
      vcs_conflicted_bg=174;  vcs_loading_bg=241
      status_ok_fg=144;  status_ok_bg=236
      status_error_fg=180;  status_error_bg=174
      exec_time_fg=236;  exec_time_bg=180
      bg_jobs_fg=108;  bg_jobs_bg=236
      gap_fg=241
      time_fg=187;  time_bg=241
      context_fg=174;  context_bg=236;  context_root_fg=174
      ;;

    "Ayu Dark")
      # Blue #59c2ff, Green #c2d94c, Yellow #ffb454, Red #f07178
      # Magenta #d2a6ff, Cyan #95e6cb, Orange #ff8f40
      c0=233;  c1=204;  c2=149;  c3=215;  c4=75
      c5=183;  c6=116;  c7=249;  c8=240;  c_orange=209
      os_icon_fg=233;  os_icon_bg=75
      prompt_ok_fg=149;  prompt_error_fg=204
      dir_bg=75;  dir_fg=253;  dir_shortened_fg=249;  dir_anchor_fg=255
      vcs_clean_bg=149;  vcs_modified_bg=215;  vcs_untracked_bg=116
      vcs_conflicted_bg=204;  vcs_loading_bg=240
      status_ok_fg=149;  status_ok_bg=233
      status_error_fg=215;  status_error_bg=204
      exec_time_fg=233;  exec_time_bg=215
      bg_jobs_fg=116;  bg_jobs_bg=233
      gap_fg=240
      time_fg=249;  time_bg=240
      context_fg=209;  context_bg=233;  context_root_fg=204
      ;;

    "Material Dark")
      # Blue #82aaff, Green #c3e88d, Yellow #ffcb6b, Red #f07178
      # Magenta #c792ea, Cyan #89ddff, Orange #f78c6c
      c0=236;  c1=204;  c2=150;  c3=221;  c4=111
      c5=176;  c6=117;  c7=255;  c8=241;  c_orange=209
      os_icon_fg=255;  os_icon_bg=111
      prompt_ok_fg=150;  prompt_error_fg=204
      dir_bg=111;  dir_fg=253;  dir_shortened_fg=255;  dir_anchor_fg=255
      vcs_clean_bg=150;  vcs_modified_bg=221;  vcs_untracked_bg=117
      vcs_conflicted_bg=204;  vcs_loading_bg=241
      status_ok_fg=150;  status_ok_bg=236
      status_error_fg=221;  status_error_bg=204
      exec_time_fg=236;  exec_time_bg=221
      bg_jobs_fg=117;  bg_jobs_bg=236
      gap_fg=241
      time_fg=255;  time_bg=241
      context_fg=209;  context_bg=236;  context_root_fg=204
      ;;

    *)
      echo "Unknown theme: $1" >&2
      return 1
      ;;
  esac

  # Derive VCS formatter text colors from palette
  vcs_text=$c0           # dark text on colored VCS backgrounds
  vcs_meta=$c7           # meta/separator text (light, visible on all bg)
  vcs_conflict_text=$c3  # conflict text on red bg (yellow on red)
}

# ── Apply Theme ──────────────────────────────────────────────────────────────

apply_theme() {
  local config="$1"

  # Helper: replace a POWERLEVEL9K variable's value in the config file
  set_var() {
    local var="$1" val="$2"
    sed_inplace "s|\(${var}=\)[^[:space:]#]*|\1${val}|" "$config"
  }

  # ── Step 1: Global ANSI palette replacement ───────────────────────────────
  # Replace every FOREGROUND/BACKGROUND value that is a bare ANSI code (0-8)
  # with the theme's 256-color equivalent. This catches all right-side segments:
  # time, context, direnv, asdf, virtualenv, pyenv, nodenv, nvm, rbenv,
  # kubecontext, terraform, aws, azure, gcloud, vi_mode, ranger, yazi, nnn,
  # nix_shell, battery, and dozens more.
  local n cval
  for n in 0 1 2 3 4 5 6 7 8; do
    eval "cval=\$c${n}"
    sed_inplace "s|\(POWERLEVEL9K_.*FOREGROUND=\)${n}\([[:space:]].*\)\{0,1\}$|\1${cval}\2|" "$config"
    sed_inplace "s|\(POWERLEVEL9K_.*BACKGROUND=\)${n}\([[:space:]].*\)\{0,1\}$|\1${cval}\2|" "$config"
  done
  # Orange (used by Rust, etc.)
  sed_inplace "s|\(POWERLEVEL9K_.*FOREGROUND=\)208\([[:space:]].*\)\{0,1\}$|\1${c_orange}\2|" "$config"
  sed_inplace "s|\(POWERLEVEL9K_.*BACKGROUND=\)208\([[:space:]].*\)\{0,1\}$|\1${c_orange}\2|" "$config"

  # ── Step 2: Core prompt segment overrides (hand-tuned per theme) ──────────
  set_var "POWERLEVEL9K_OS_ICON_FOREGROUND"                                    "$os_icon_fg"
  set_var "POWERLEVEL9K_OS_ICON_BACKGROUND"                                    "$os_icon_bg"

  set_var "POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND"   "$prompt_ok_fg"
  set_var "POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND" "$prompt_error_fg"

  set_var "POWERLEVEL9K_DIR_BACKGROUND"                                        "$dir_bg"
  set_var "POWERLEVEL9K_DIR_FOREGROUND"                                        "$dir_fg"
  set_var "POWERLEVEL9K_DIR_SHORTENED_FOREGROUND"                              "$dir_shortened_fg"
  set_var "POWERLEVEL9K_DIR_ANCHOR_FOREGROUND"                                 "$dir_anchor_fg"

  set_var "POWERLEVEL9K_VCS_CLEAN_BACKGROUND"                                  "$vcs_clean_bg"
  set_var "POWERLEVEL9K_VCS_MODIFIED_BACKGROUND"                               "$vcs_modified_bg"
  set_var "POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND"                              "$vcs_untracked_bg"
  set_var "POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND"                             "$vcs_conflicted_bg"
  set_var "POWERLEVEL9K_VCS_LOADING_BACKGROUND"                                "$vcs_loading_bg"

  set_var "POWERLEVEL9K_STATUS_OK_FOREGROUND"                                  "$status_ok_fg"
  set_var "POWERLEVEL9K_STATUS_OK_BACKGROUND"                                  "$status_ok_bg"
  set_var "POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND"                             "$status_ok_fg"
  set_var "POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND"                             "$status_ok_bg"

  set_var "POWERLEVEL9K_STATUS_ERROR_FOREGROUND"                               "$status_error_fg"
  set_var "POWERLEVEL9K_STATUS_ERROR_BACKGROUND"                               "$status_error_bg"
  set_var "POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND"                        "$status_error_fg"
  set_var "POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND"                        "$status_error_bg"
  set_var "POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND"                          "$status_error_fg"
  set_var "POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND"                          "$status_error_bg"

  set_var "POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND"                     "$exec_time_fg"
  set_var "POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND"                     "$exec_time_bg"

  set_var "POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND"                            "$bg_jobs_fg"
  set_var "POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND"                            "$bg_jobs_bg"

  set_var "POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND"                 "$gap_fg"

  set_var "POWERLEVEL9K_TIME_FOREGROUND"                                      "$time_fg"
  set_var "POWERLEVEL9K_TIME_BACKGROUND"                                      "$time_bg"

  set_var "POWERLEVEL9K_CONTEXT_FOREGROUND"                                   "$context_fg"
  set_var "POWERLEVEL9K_CONTEXT_BACKGROUND"                                   "$context_bg"
  set_var "POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND"                              "$context_root_fg"
  set_var "POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND"                              "$context_bg"
  set_var "POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND"              "$context_fg"
  set_var "POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_BACKGROUND"              "$context_bg"

  # ── Step 3: VCS formatter inline text colors ──────────────────────────────
  # These are the %F{} codes used inside my_git_formatter() for branch names,
  # commit info, counts, etc. displayed ON TOP of the VCS segment backgrounds.
  sed_inplace "s|local  *meta='%[^']*'.*|local       meta='%F{${vcs_meta}}' # meta foreground|" "$config"
  sed_inplace "s|local  *clean='%[^']*'.*|local      clean='%F{${vcs_text}}' # clean foreground|" "$config"
  sed_inplace "s|local  *modified='%[^']*'.*|local   modified='%F{${vcs_text}}' # modified foreground|" "$config"
  sed_inplace "s|local  *untracked='%[^']*'.*|local  untracked='%F{${vcs_text}}' # untracked foreground|" "$config"
  sed_inplace "s|local  *conflicted='%[^']*'.*|local conflicted='%F{${vcs_conflict_text}}' # conflicted foreground|" "$config"
}

# ── Menu ─────────────────────────────────────────────────────────────────────

show_menu() {
  echo ""
  echo "  Powerlevel10k Prompt Color Themes"
  echo "  ──────────────────────────────────"
  echo ""

  local i
  for i in "${!THEMES[@]}"; do
    printf "  %2d) %s\n" "$((i + 1))" "${THEMES[$i]}"
  done

  echo ""
  echo "   0) Restore from backup"
  echo ""
}

# ── Backup / Restore ────────────────────────────────────────────────────────

backup_config() {
  mkdir -p "$BACKUP_DIR"
  local stamp
  stamp="$(date +%Y%m%d-%H%M%S)"
  cp "$P10K_CONFIG" "${BACKUP_DIR}/p10k.zsh.${stamp}.bak"
  echo "  Backup saved to ${BACKUP_DIR}/p10k.zsh.${stamp}.bak"
}

save_baseline() {
  mkdir -p "$BACKUP_DIR"
  if [[ ! -f "$BASELINE_FILE" ]]; then
    cp "$P10K_CONFIG" "$BASELINE_FILE"
    echo "  Saved original config as baseline."
  fi
}

restore_baseline() {
  if [[ -f "$BASELINE_FILE" ]]; then
    cp "$BASELINE_FILE" "$P10K_CONFIG"
  fi
}

restore_config() {
  if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "  No backups found in $BACKUP_DIR" >&2
    exit 1
  fi

  local latest
  latest="$(ls -t "$BACKUP_DIR"/p10k.zsh.*.bak 2>/dev/null | head -1)"

  if [[ -z "$latest" ]]; then
    echo "  No backups found in $BACKUP_DIR" >&2
    exit 1
  fi

  echo ""
  echo "  Available backups (most recent first):"
  echo ""
  local backups=()
  while IFS= read -r f; do
    backups+=("$f")
  done < <(ls -t "$BACKUP_DIR"/p10k.zsh.*.bak 2>/dev/null | head -5)

  local i
  for i in "${!backups[@]}"; do
    printf "  %d) %s\n" "$((i + 1))" "$(basename "${backups[$i]}")"
  done
  echo ""

  local choice
  read -rp "  Select backup to restore [1]: " choice
  choice="${choice:-1}"

  local idx=$((choice - 1))
  if [[ $idx -lt 0 || $idx -ge ${#backups[@]} ]]; then
    echo "  Invalid selection." >&2
    exit 1
  fi

  cp "${backups[$idx]}" "$P10K_CONFIG"
  echo ""
  echo "  Restored from $(basename "${backups[$idx]}")"
  echo "  Run 'exec zsh' to apply changes."
}

# ── Main ─────────────────────────────────────────────────────────────────────

main() {
  # Check config exists
  if [[ ! -f "$P10K_CONFIG" ]]; then
    echo "  Error: $P10K_CONFIG not found." >&2
    echo "  Run 'p10k configure' first, or set P10K_CONFIG to your config path." >&2
    exit 1
  fi

  # Handle flags
  case "${1:-}" in
    --list|-l)
      echo ""
      for i in "${!THEMES[@]}"; do
        printf "  %2d) %s\n" "$((i + 1))" "${THEMES[$i]}"
      done
      echo ""
      exit 0
      ;;
    --restore|-r)
      restore_config
      exit 0
      ;;
    --reset-baseline)
      mkdir -p "$BACKUP_DIR"
      rm -f "$BASELINE_FILE"
      echo "  Baseline cleared. Next theme apply will use current config as the new baseline."
      exit 0
      ;;
    --theme|-t)
      local num="${2:-}"
      if [[ -z "$num" || "$num" -lt 1 || "$num" -gt ${#THEMES[@]} ]] 2>/dev/null; then
        echo "  Usage: $0 --theme <1-${#THEMES[@]}>" >&2
        echo "  Run '$0 --list' to see available themes." >&2
        exit 1
      fi
      local theme_name="${THEMES[$((num - 1))]}"
      load_theme "$theme_name"
      save_baseline
      backup_config
      restore_baseline
      apply_theme "$P10K_CONFIG"
      echo "  Applied: $theme_name"
      echo "  Run 'exec zsh' to see the changes."
      exit 0
      ;;
    --help|-h)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "  Interactive theme selector for Powerlevel10k prompt colors."
      echo "  Themes all prompt segment colors — left side, right side, and"
      echo "  inline VCS text — without touching layout or behavior."
      echo ""
      echo "Options:"
      echo "  --list, -l          List available themes"
      echo "  --theme N, -t N     Apply theme by number (non-interactive)"
      echo "  --restore, -r       Restore from a backup"
      echo "  --reset-baseline    Clear saved baseline (use after re-running p10k configure)"
      echo "  --help, -h          Show this help"
      echo ""
      echo "Environment:"
      echo "  P10K_CONFIG         Path to .p10k.zsh (default: ~/.p10k.zsh)"
      exit 0
      ;;
  esac

  # Interactive mode — try fzf first
  local selected_num=""

  if command -v fzf >/dev/null 2>&1; then
    local fzf_input=""
    for i in "${!THEMES[@]}"; do
      fzf_input+="$(printf "%2d) %s" "$((i + 1))" "${THEMES[$i]}")"$'\n'
    done
    fzf_input+=" 0) Restore from backup"

    local picked
    picked="$(echo "$fzf_input" | fzf --height=24 --reverse --prompt="  Theme: " --header="  Select a color theme for your p10k prompt" || true)"

    if [[ -z "$picked" ]]; then
      echo "  Cancelled."
      exit 0
    fi

    selected_num="$(echo "$picked" | sed 's/^[[:space:]]*//' | cut -d')' -f1)"
  else
    show_menu
    read -rp "  Select theme [1-${#THEMES[@]}]: " selected_num
  fi

  # Validate
  if [[ -z "$selected_num" ]]; then
    echo "  Cancelled."
    exit 0
  fi

  if [[ "$selected_num" == "0" ]]; then
    restore_config
    exit 0
  fi

  if [[ "$selected_num" -lt 1 || "$selected_num" -gt ${#THEMES[@]} ]] 2>/dev/null; then
    echo "  Invalid selection." >&2
    exit 1
  fi

  local theme_name="${THEMES[$((selected_num - 1))]}"

  # Load, backup, apply from baseline
  load_theme "$theme_name"
  save_baseline
  backup_config
  restore_baseline
  apply_theme "$P10K_CONFIG"

  echo ""
  echo "  Applied: $theme_name"
  echo "  Run 'exec zsh' to see the changes."
  echo ""
}

main "$@"
