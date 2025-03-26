# ZSH base configuration

# oh-my-zsh
plugins=(
    git
    z
    fzf
    man
    tldr
    gh
    archlinux
    arduino-cli
    npm
    bun
    tmux
    rust
    zsh-autosuggestions
    zsh-syntax-highlighting
)
if  [[ ! -f "$ZSH/oh-my-zsh.sh" ]]; then
    echo "${red}No 'oh-my-zsh.sh' file found. Attempting to update zsh config folder submodules${nc}"
    pushd "$ZDOTDIR" > /dev/null || return 1
    git submodule update --init -f
    popd > /dev/null || return 1
    [[ -s "$ZSH/oh-my-zsh.sh" ]] || echo "${green}ZSH submodules updated. ${yellow}Please, run 'exec zsh' to see applied changes${nc}"
else
    source "$ZSH/oh-my-zsh.sh" || echo "${red}Could not source 'oh-my-zsh.sh' file${nc}"
fi

zstyle ':omz:update' mode auto
export ENABLE_CORRECTION="false"

# ZSH enviroment
if [[ -e "$HOME/.zshenv" ]]; then
    source "$ZDOTDIR/.zshenv"
else
    echo "${red}No '.zshenv' file found in '\$HOME' directory. Attempting create symbolic link from file in '\$ZDOTDIR'${nc}"
    ln -s "$ZDOTDIR/.zshenv" "$HOME/.zshenv"
    if [[ -e "$HOME/.zshenv" ]]; then
        echo "${green}Symbolic link created. Sourcing.${nc}"
        source "$HOME/.zshenv"
    else
        echo "${red}Could not create '.zshenv' symlink in home directory.${nc}"
    fi
fi


if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nvim'
else
    export EDITOR='vim'
fi

# bun completions
[ -s "/home/lul/.bun/_bun" ] && source "/home/lul/.bun/_bun"
