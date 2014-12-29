# PACKAGES
##########
# https://wiki.archlinux.org/index.php/Pacman_Tips#Backing_up_and_retrieving_a_list_of_installed_packages
# backup installed packages (alternatively use aura -B and auro -Br)
#comm -23 <(pacman -Qeq|sort) <(pacman -Qmq|sort) > pkglist.txt
# restore
#pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort badpkdlist) )


# VIM
#####
# https://github.com/gmarik/vundle
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# https://github.com/tpope/vim-sensible
# otherwise it puts the files in the current directory
mkdir -p ~/.local/share/vim/{swap,backup,undo}

