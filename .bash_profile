defaults write -g com.apple.mouse.scaling -1                # mouse acceleration off
# defaults write -g ApplePressAndHoldEnabled -bool false      # enable key repeating
# defaults write com.jetbrains.webstorm ApplePressAndHoldEnabled -bool false  # CLion key repeating

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

[ -f $HOME/.bashrc ] && . $HOME/.bashrc
