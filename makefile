.PHONY: link
link: 
	ln -s `pwd`/cmdnotify/cmdnotif.sh $(HOME)/.scripts/cmdnotif.sh
	ln -s `pwd`/tmux/mux.sh $(HOME)/.scripts/mux.sh
	ln -f `pwd`/brew_update.sh $(HOME)/.scripts/brew_update.sh
	ln -f `pwd`/typo.sh $(HOME)/.scripts/typo.sh
	ln -f `pwd`/ssh_change_profile.sh $(HOME)/.scripts/ssh_change_profile.sh

