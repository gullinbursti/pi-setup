
# if running bash, include .bashrc file
if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc.pi" ]; then . $HOME/.bashrc.pi ; fi
fi
