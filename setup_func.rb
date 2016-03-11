#!/usr/bin/env ruby

# bunch of setup functions

$CUR_DIR = File.expand_path(File.dirname(__FILE__))
$default_email = "bruce30262@gmail.com"

module Setup
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

    def gen_git_sshkey(email)
        puts "generating RSA 4096 bits ssh key pair..."
        system("ssh-keygen -t rsa -b 4096 -C \"#{email}\"")
        puts "adding ssh key to ~/.ssh/ ..."
        system("ssh-add #{Dir.home}/.ssh/id_rsa")
        puts "done generating ssh key."
    end

    def set_git()
        key_file = "#{Dir.home}/.ssh/id_rsa.pub"
        
        puts "setting git..."
        puts "setting .gitconfig..."
        system("ln -s #{$CUR_DIR}/git/.gitconfig ~/.gitconfig")
        
        puts "generating ssh key for git..."
        if File.exist?key_file # ssh key already exist
            puts "ssh key already exist on this machine."
        else
            gen_git_sshkey($default_email)
        end

        puts "done setting git."
    end

end

