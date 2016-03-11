#!/usr/bin/env ruby

# executed by install.sh

$CUR_DIR = File.expand_path(File.dirname(__FILE__))

def install_tmux()
    puts "installing tmux..."
    system("sudo apt-get install -y tmux")
    puts "setting .tmux.conf..."
    system("ln -s #{$CUR_DIR}/.tmux.conf ~/.tmux.conf")
    puts "setting tmux done."
end

def install_NOT() # installing nautilus-open-terminal
    puts "installing nautilus-open-terminal..."
    system("sudo apt-get install -y nautilus-open-terminal")
    system("nautilus -q && nautilus &")
    puts "done installing nautilus-open-terminal"
end

def set_bashrc()
    puts "setting .bashrc..."
    system("rm -f ~/.bashrc")
    system("ln -s #{$CUR_DIR}/bash/.bashrc ~/.bashrc")
    puts "done setting .bashrc"
end

def gen_git_sshkey(my_email)
    key_file = "#{Dir.home}/.ssh/id_rsa.pub"
    
    if File.exist?key_file # ssh key already exist
        puts "ssh key already exist on this machine."
    else
        puts "generating ssh key pair..."
        system("ssh-keygen -t rsa -b 4096 -C \"#{my_email}\"")
        system("ssh-add #{Dir.home}/.ssh/id_rsa")
        puts "done generating ssh key."
    end
end

def set_git()
    puts "setting git..."
    puts "setting .gitconfig..."
    system("ln -s #{$CUR_DIR}/git/.gitconfig ~/.gitconfig")
    puts "generating ssh key for git..."
    gen_git_sshkey("bruce30262@gmail.com")
    puts "done setting git."
end

########### main function #############

install_tmux()
install_NOT()
set_bashrc()
set_git()
