#!/usr/bin/env ruby

# bunch of setup functions

$CUR_DIR = File.expand_path(File.dirname(__FILE__))
$default_email = "bruce30262@pm.me"
$dbg_repo = "https://raw.githubusercontent.com/bruce30262/CTF/master/debugger/"

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

    def curl_download_to(url, to)
        puts "downloading #{url} to #{to}..."
        system("curl -fsSL #{url} -o #{to}")
    end

end

module Setup
    include Myutil

    def install_tmux()
        if not is_this_installed("tmux")
            puts "installing tmux..."
            install("tmux")
        end
        if not is_dir_exist("#{Dir.home}/.tmux/plugins/tpm")
            puts "installing tpm..."
            system("cd ~ && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm")
        end

        puts "setting .tmux.conf..."
        set_symlink("~/.tmux.conf", "#{$CUR_DIR}/.tmux.conf")
        puts "setting tmux done."
        puts "In tmux, use <prefix> + I to install tmux plugins."
    end

    def install_fonts() # install fonts
        system("cd #{$CUR_DIR}/fonts && sudo ./install_fonts.rb")
    end

    def set_bashrc()
        puts "setting .bashrc..."
        set_symlink("~/.bashrc", "#{$CUR_DIR}/bash/.bashrc")
        puts "done setting .bashrc"
    end

    def set_zsh()
        # checking if zsh is installed or not
        if not is_this_installed("zsh")
            puts "installing zsh..."
            install("zsh")
        end
        
        def set_rcS()
            # Setup zsh rc files
            system("cp #{$CUR_DIR}/zsh/.z* ~/")
            set_symlink("~/.zshrc", "#{$CUR_DIR}/zsh/.zshrc")
            set_symlink("~/.zimrc", "#{$CUR_DIR}/zsh/.zimrc")
            set_symlink("~/.p10k.zsh", "#{$CUR_DIR}/zsh/.p10k.zsh")
        end
        # checking if zimfw is installed or not
        if not is_dir_exist("#{Dir.home}/.zim/")
            puts "installing zimfw..."
            # Fetch & prepare zimfw
            system("mkdir -p ~/.zim")
            curl_download_to("https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh", "~/.zim/zimfw.zsh")
            system("chmod +x ~/.zim/zimfw.zsh")
            # Set rc files before installing zimfw
            set_rcS()
            # Start install zimfw
            system("zsh -c \"source ~/.zim/zimfw.zsh install\"")
        else
            puts("zimfw seems installed. Set rc files only.")
            set_rcS()
        end
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

    def set_angelheap()
        # checking if Pwngdb is installed or not
        if not is_dir_exist("#{Dir.home}/Pwngdb/")
            # install Pwngdb
            puts "installing Pwngdb (for angelheap)..."
            system("cd ~ && git clone https://github.com/scwuaptx/Pwngdb.git ~/Pwngdb/")
        end
    end

    def set_peda()
        # checking if peda is installed or not
        if not is_dir_exist("#{Dir.home}/peda/")
            # install peda
            puts "installing peda..."
            system("cd ~ && git clone https://github.com/bruce30262/peda.git ~/peda/")
        end
        
        # setting angelheap
        set_angelheap()
        
        peda_init = $dbg_repo + ".gdbinit_peda"
        gdbp = $dbg_repo + "gdbp"

        puts "downloading .gdbinit & other utilities..."
        curl_download_to(peda_init, "~/.gdbinit_peda")
        curl_download_to(gdbp, "~/gdbp")
         
        puts "setting file permission..."
        system("cd ~ && chmod u+x ~/gdbp")
    
        puts "done setting peda ( alias: gdbp )"
    end

    def set_pwndbg()
        # checking if pwndbg is installed or not
        if not is_dir_exist("#{Dir.home}/pwndbg/")
            # install pwndbg
            puts "installing pwndbg..."
            system("cd ~ && git clone https://github.com/pwndbg/pwndbg ~/pwndbg/")
            system("cd ~/pwndbg && sudo ./setup.sh")
        end

        # setting angelheap
        set_angelheap()
        
        pwndbg_init = $dbg_repo + ".gdbinit_pwndbg"
        gdb = $dbg_repo + "gdb"

        puts "downloading .gdbinit & other utilities..."
        curl_download_to(pwndbg_init, "~/.gdbinit_pwndbg")
        curl_download_to(gdb, "~/gdb")
        
        puts "setting file permission..."
        system("cd ~ && chmod u+x ~/gdb")

        puts "done setting pwndbg"
    end
    
    def set_gef()
        # check if gef is installed or not
        if not is_file_exist("#{Dir.home}/.gdbinit-gef.py")
            # install gef
            puts "installing gef..."
            curl_download_to("https://github.com/hugsy/gef/raw/dev/gef.py", "~/.gdbinit-gef.py")
        end
        set_angelheap()

        gef_init = $dbg_repo + ".gdbinit_gef"
        mygef = $dbg_repo + "gef"
        gefrc = $dbg_repo + ".gef.rc"

        puts "downloading .gdbinit & other utilities..."
        curl_download_to(gef_init, "~/.gdbinit_gef")
        curl_download_to(mygef, "~/gef")
        curl_download_to(gefrc, "~/.gef.rc")
         
        puts "setting file permission..."
        system("cd ~ && chmod u+x ~/gef")
    
        puts "done setting gef"
    end

    def set_dbg(choice)

        if choice == "peda"
            puts "setting gdb-peda..."
            set_peda()
        elsif choice == "pwndbg"
            puts "setting pwndbg..."
            set_pwndbg()
        elsif choice == "gef"
            puts "setting gef..."
            set_gef()
        elsif choice == "all"
            puts "setting gdb-peda & pwndbg & gef..."
            set_peda()
            set_pwndbg()
            set_gef()
        else
            puts "Invalid choice. Aborting..."
            return
        end

        puts "setting debugger alias..."
        curl_download_to($dbg_repo+"dbg.alias", $CUR_DIR+"/rcS/dbg.alias")

        puts "reset ~/.gdbinit..."
        system("rm -f ~/.gdbinit && touch ~/.gdbinit")

        puts "source ~/.zshrc to apply the latest debugger setting"
    end

end

