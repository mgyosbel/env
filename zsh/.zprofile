# Homebrew PATH — must come FIRST
eval "$(/opt/homebrew/bin/brew shellenv)"

# Setting PATH for Python 3.13
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
export PATH


termwidth="$(tput cols)"

# Adjust the spacing for the "Welcome to ..." and "All rights ..." lines.

left_align() {
  local padding="$(printf '%0.1s' \ {1..500})"
  local padding_percentage="$1"
  local padding_width=$((termwidth*padding_percentage/100))
  printf '%*.*s %s %*.*s\n' "$padding_width" "$padding_width" "$padding" "$2" 0 "$((termwidth-1-${#2}-padding_width))" "$padding"
}

left_align 6 "Let's rock and roll baby!"
figlet -w ${termwidth} -f slant KYUUBI | lolcat
# NOTE: Do NOT source ~/.zshrc here. Interactive login shells already read
# ~/.zshrc automatically AFTER ~/.zprofile, so sourcing it here made the whole
# config run twice (doubling startup time). Removed intentionally.
