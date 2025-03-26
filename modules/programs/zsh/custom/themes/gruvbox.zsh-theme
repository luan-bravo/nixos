### Segment drawing
CURRENT_BG='NONE'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='3';;
    *)     CURRENT_FG='0';;
esac

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0' # 
  RIGHT_SEPARATOR=$'\ue0b2'   # 
}

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components

# OS: Displays OS icon (e.g., WSL or system logo)
prompt_os() {
  local os_icon
  local distro=$(. /etc/os-release && echo "$NAME" || echo "")
  case "$OSTYPE" in
    linux*)
      case "$distro" in
        Arch*)
          os_icon="\uf303" ;; # 󰣇
        Debian*)
          os_icon="\uf306" ;; # 󰣚
        Ubuntu*)
          os_icon="\uebc9" ;; # 
        Nix*)
          os_icon="\uf313" ;; # 
        *)
          os_icon="\ue712" ;; # 
      esac
    ;;
    darwin*) os_icon="\ue29e" ;; # 
    *)       os_icon="\uf17a" ;; # 
  esac
  if [[ -n $WSL_DISTRO_NAME ]]; then
    os_icon+=" @ wsl"
  fi
  prompt_segment 237 7 "$os_icon"
}

# Dir: Current working directory (full path)
prompt_dir() {
  prompt_segment 4 $CURRENT_FG '%~'
}

# Git: Branch, status, stash count
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR=$'\ue0a0' # 
  local ref dirty mode repo_path stash_count

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2>/dev/null) || ref="➦ $(git rev-parse --short HEAD 2>/dev/null)"
    stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')

    if [[ -n $dirty ]]; then
      prompt_segment 3 0 # Dirty state
    else
      prompt_segment 2 $CURRENT_FG # Clean state
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' formats ' %m'
    zstyle ':vcs_info:*' actionformats ' %m'
    zstyle ':vcs_info:git*+set-message:*' hooks git-st
    vcs_info

    local git_status="${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
    [[ $stash_count -gt 0 ]] && git_status+=" \ueb4b $stash_count"
    echo -n "$git_status"
  fi
}

# Git status hook
function +vi-git-st() {
  local ahead behind
  local -a gitstatus
  local -a ahead_and_behind=($(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null))
  local -a stat=("$(git status --porcelain)")
  local -a untracked=($(echo "$stat" | grep '^??' | wc -l))
  local -a modified=($(echo "$stat" | grep '^.M' | wc -l))
  local -a staged=($(echo "$stat" | grep '^[AM]' | wc -l))

  ahead=${ahead_and_behind[1]}
  behind=${ahead_and_behind[2]}

  (( $modified )) && gitstatus+=( "%{\033[1m%}${modified}\uf044" )
  (( $staged )) && gitstatus+=( "%{\033[1m%}${staged}\uf046" )
  (( $untracked )) && gitstatus+=( "%{\033[1m%}${untracked}\ueb32" )
  (( $ahead )) && gitstatus+=( '' )
  (( $behind )) && gitstatus+=( '' )

  [[ -n "$gitstatus" ]] && hook_com[misc]+=' '
  hook_com[misc]+=${(j:  :)gitstatus}
}

# Go: Version if in a Go project
prompt_go() {
  (( $+commands[go] )) || return
  if [[ -f "go.mod" || -n "$(find . -maxdepth 1 -name '*.go')" ]]; then
    local go_version=$(go version 2>/dev/null | grep -o 'go[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "")
    [[ -n $go_version ]] && prompt_segment 12 0 "\ue626 $go_version"
  fi
}

# Julia: Version if in a Julia project
prompt_julia() {
  (( $+commands[julia] )) || return
  if [[ -f "Project.toml" || -n "$(find . -maxdepth 1 -name '*.jl')" ]]; then
    local julia_version=$(julia --version 2>/dev/null | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "")
    [[ -n $julia_version ]] && prompt_segment 4 0 "\ue624 $julia_version"
  fi
}

# Python: Version if in a Python project
prompt_python() {
  if [[ -f "pyproject.toml" || -f "requirements.txt" || -n "$(find . -maxdepth 1 -name '*.py')" ]]; then
    local python_version=$(python --version 2>/dev/null | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "")
    [[ -n $python_version ]] && prompt_segment 11 0 "\ue235 $python_version"
  fi
}

# Ruby: Version if in a Ruby project
prompt_ruby() {
  (( $+commands[ruby] )) || return
  if [[ -f "Gemfile" || -n "$(find . -maxdepth 1 -name '*.rb')" ]]; then
    local ruby_version=$(ruby --version 2>/dev/null | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "")
    [[ -n $ruby_version ]] && prompt_segment 1 7 "\ue791 $ruby_version"
  fi
}

# Azure Functions: Presence check
prompt_azfunc() {
  [[ -f "host.json" || -f "function.json" ]] && prompt_segment 208 7 "\uf0e7"
}

# AWS: Profile and region if present
prompt_aws() {
  local aws_profile="${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}"
  local aws_region="$AWS_REGION"
  if [[ -n $aws_profile ]]; then
    local aws_info="\ue7ad $aws_profile"
    [[ -n $aws_region ]] && aws_info+="@$aws_region"
    prompt_segment 3 7 "$aws_info"
  fi
}

# Root: Indicates root user
prompt_root() {
  [[ $UID -eq 0 ]] && prompt_segment 11 0 "\uf0ad"
}

# Status: Error and jobs
prompt_status() {
  local -a symbols
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{1}%}󰜺"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{15}%}\ufb36"
  [[ -n "$symbols" ]] && prompt_segment 166 7 "$symbols"
}

## Main prompt (left side)
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_os
  prompt_dir
  prompt_git
  prompt_go
  prompt_julia
  prompt_python
  prompt_ruby
  prompt_azfunc
  prompt_aws
  prompt_root
  prompt_end
}

## Right prompt (date and time with \ue0b2)
build_rprompt() {
  # echo -n "%{%F{237}%K{235}%}$RIGHT_SEPARATOR%{%F{7}%K{237}%} $(date '+%d/%m/%y - %H:%M:%S') "
  # calendar_separator="%{%F{237}%K{235}%}$RIGHT_SEPARATOR"
  # calendar="%{%F{7}%K{237}%} $(date '+%d/%m/%y') "

  clock_separator="%{%F{15}%K{235}%}$RIGHT_SEPARATOR"
  clock="%{%F{237}%K{15}%} $(date '+%H:%M:%S')"

  # rprompt=$calendar_separator$calendar$clock_separator$clock
  rprompt=$clock_separator$clock
  echo -n $rprompt
}

PROMPT='%{%f%b%k%}$(build_prompt) '
RPROMPT='$(build_rprompt)'
