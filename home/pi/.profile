
# if running bash, include .bashrc_pi file
if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc_pi" ]; then . $HOME/.bashrc_pi ; fi
fi
