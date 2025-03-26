export DOTDIR="$HOME/.config"
export ZDOTDIR="$DOTDIR/zsh"
export ZSH_CUSTOM="$ZDOTDIR/custom"
export GIT_CONFIG_GLOBAL=$DOTDIR/git/.gitconfig
export ZSH="$ZDOTDIR/ohmyzsh"
export ZSH_THEME="gruvbox"


# personal paths and variables
export GH="https://github.com"
export NOTES="$HOME/notes"
export TODOFILE="$NOTES/todo.md"


# colors
export nc=$'\033[0m' # no coloring
export red=$'\033[1;31m'
export yellow=$'\033[1;33m'
export green=$'\033[1;32m'

: << 'COLORS'
Black        0;30
Red          0;31
Green        0;32
Brown/Orange 0;33
Blue         0;34
Purple       0;35
Cyan         0;36
Light Gray   0;37
Dark Gray     0;30
Light Red     1;31
Light Green   1;32
Yellow        1;33
Light Blue    1;34
Light Purple  1;35
Light Cyan    1;36
White         1;37
COLORS
