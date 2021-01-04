.PHONY: link
link: 
	ln -f `pwd`/ajipsy/ajipsy $HOME/bin/ajipsy
	ln -f `pwd`/repo/rp $HOME/bin/rp  
	ln -f `pwd`/cmdnotify/cmdnotif $HOME/bin/cmdnotif
	ln -f `pwd`/snitch/snitch $HOME/bin/snitch         
	ln -f `pwd`/brew_update.sh $HOME/bin/brew_update.sh
	ln -f `pwd`/overleaf_backup.sh $HOME/bin/overleaf_backup.sh
	ln -f `pwd`/typo.sh $HOME/bin/typo.sh