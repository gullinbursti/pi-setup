
# if running bash, include .bashrc_pi file if it exists
if [ -n "$BASH_VERSION" ]; then [[ -f "$HOME/.bashrc_pi" ]] && . $HOME/.bashrc_pi ; fi
