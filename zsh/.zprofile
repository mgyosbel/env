# Homebrew PATH — must come FIRST (only if brew is installed; macOS or Linuxbrew)
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -x "$_brew" ]; then eval "$("$_brew" shellenv)"; break; fi
done
unset _brew

# Setting PATH for Python 3.13 (macOS framework path; only if present)
[ -d "/Library/Frameworks/Python.framework/Versions/3.13/bin" ] && \
  export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"


termwidth="$(tput cols)"

# Adjust the spacing for the "Welcome to ..." and "All rights ..." lines.

left_align() {
  local padding="$(printf '%0.1s' \ {1..500})"
  local padding_percentage="$1"
  local padding_width=$((termwidth*padding_percentage/100))
  printf '%*.*s %s %*.*s\n' "$padding_width" "$padding_width" "$padding" "$2" 0 "$((termwidth-1-${#2}-padding_width))" "$padding"
}

left_align 6 "Let's rock and roll baby!"

# Banner: use figlet if available, preferring the "slant" font but falling back
# to any installed font. Colorize with lolcat only when it's installed.
if command -v figlet >/dev/null 2>&1; then
  _fig_font=standard
  for _f in slant future standard mono12 smblock; do
    if figlet -f "$_f" "" >/dev/null 2>&1; then _fig_font="$_f"; break; fi
  done
  if command -v lolcat >/dev/null 2>&1; then
    figlet -w "${termwidth}" -f "$_fig_font" KYUUBI | lolcat
  else
    figlet -w "${termwidth}" -f "$_fig_font" KYUUBI
  fi
  unset _fig_font _f
fi
# NOTE: Do NOT source ~/.zshrc here. Interactive login shells already read
# ~/.zshrc automatically AFTER ~/.zprofile, so sourcing it here made the whole
# config run twice (doubling startup time). Removed intentionally.
