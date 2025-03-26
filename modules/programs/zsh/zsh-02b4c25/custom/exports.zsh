# Exports

src() {
    [[ -f "$1" ]] && source "$1"
}
xpt() {
    [[ -d "$2" ]] && export "$1"="$2"
}


xpt IDF_PATH "/opt/esp-idf"
src "$IDF_PATH/export.sh"

# Exports for set up
xpt GIT_CONFIG_GLOBAL "$HOME/.config/.gitconfig"
# src "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # now in plugins

# Path and sourcing
if [ -d "$HOME/.local/share/adb-fastboot/platform-tools" ] ; then
    xpt PATH "$PATH:$HOME/.local/share/adb-fastboot/platform-tools"
fi

src "$HOME/.bun/_bun"
xpt BUN_INSTALL "$HOME/.bun"
xpt PATH "$PATH:$BUN_INSTALL/bin"

xpt ANDROID_HOME "$HOME/Android/sdk"
xpt PATH "$PATH:$ANDROID_HOME/emulator"
xpt PATH "$PATH:$ANDROID_HOME/platform-tools"

xpt FLYCTL_INSTALL "$HOME/.fly"
xpt PATH "$PATH:$FLYCTL_INSTALL/bin"

xpt PATH "$PATH:$HOME/.turso"

xpt PNPM_HOME "$HOME/.local/share/pnpm"
case ":$PATH:" in
    # find if this case is really necessary, if it isn't, remove the echo in the next line, else modify every $PATH update in this file to use a case statement
  *":$PNPM_HOME:"*) ;;
  *) xpt PATH "$PATH:$PNPM_HOME" ;;
esac
xpt PATH "$PATH:$ZDOTDIR/custom/bin"

# WSL browser, requires wslu installation to be followerd
if [[ -n $WSL_DISTRO_NAME ]]; then
    xpt BROWSER "wslview"
fi
