#!/usr/bin/env ruby

# bunch of setup functions

$CUR_DIR = File.expand_path(File.dirname(__FILE__))
$default_email = "bruce30262@gmail.com"

module Myutil

    def install(package)
        system("sudo apt-get install -y #{package}")
    end

    def set_symlink(lnk, real_file)
        system("ln -sf #{real_file} #{lnk}")
    end

    def is_this_installed(cmd)
        resp = `bash -c 'type -P #{cmd}'`
        if resp.empty?
            return false
        else
            puts "#{cmd} already installed."
            return true
        end
    end

    def is_dir_exist(dir)
        return Dir.exist?(dir)
    end

    def is_file_exist(f)
        return File.file?(f)
    end

end

module Setup
    include Myutil

    def install_tmux()
        if not is_this_installed("tmux")
            puts "installing tmux..."
            install("tmux")
        end
        puts "setting .tmux.conf..."
        set_symlink("~/.tmux.conf", "#{$CUR_DIR}/.tmux.conf")
        puts "setting tmux done."
    end

    def install_NOT() # installing nautilus-open-terminal
        if not is_this_installed("nautilus")
            puts "installing nautilus-open-terminal..."
            install("nautilus-open-terminal")
            system("nautilus -q && nautilus &")
            puts "done installing nautilus-open-terminal"
        end
    end

    def set_zsh()
        # checking if zsh is installed or not
        if not is_this_installed("zsh")
            puts "installing zsh..."
            install("zsh")
        end

        # checking if oh my zsh is installed or not
        if not is_dir_exist("#{Dir.home}/.oh-my-zsh/")
            puts "installing oh my zsh..."
            system("cd ~ && sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\"")
        else
            puts("oh my zsh seems installed")
        end

        # setting .zshrc
        puts "setting .zshrc..."
        set_symlink("~/.zshrc", "#{$CUR_DIR}/zsh/.zshrc")
        puts "done setting zsh."
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
        set_symlink("~/.gitconfig", "#{$CUR_DIR}/git/.gitconfig")
        
        puts "generating ssh key for git..."
        if File.exist?key_file # ssh key already exist
            puts "ssh key already exist on this machine."
        else
            gen_git_sshkey($default_email)
        end

        puts "done setting git."
    end

end

