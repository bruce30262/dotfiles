#!/usr/bin/env ruby

require_relative '../setup_func'

module Install_Tool
    include Myutil

    def install_bctk
        # my CTF toolkit (Bruce CTF TooKit)
        if not is_dir_exist("#{Dir.home}/CTF-master")
            puts "Installing bruce30262 CTF-toolkit..."
            system("git clone https://github.com/bruce30262/CTF.git ~/CTF-master")
        else
            puts "bruce30262 CTF-toolkit already installed"
        end
    end

    def install_pwntools
        # pwntools
        res = system("python -c 'import pwn'")
        if res == false # start installing
            puts "Installing pwntools..."
            install("python2.7 python2.7-dev python-pip libffi-dev libssl-dev libssh-dev")
            system("sudo pip install --upgrade git+https://github.com/Gallopsled/pwntools.git")
        else # already install
            puts "pwntools already installed"
        end
    end

    def install_ropgadget
        # ROPGadget
        if not is_this_installed("ROPgadget")
            system("git clone https://github.com/JonathanSalwan/ROPgadget.git ~/ROPgadget")
            system("cd ~/ROPgadget && sudo python setup.py install")
        end
    end

    def install_libcdb
        # libc-database
        if not is_dir_exist("#{Dir.home}/libc-database")
            puts "Downloading libc-database..."
            system("git clone https://github.com/niklasb/libc-database.git ~/libc-database")
        else
            puts "libc-database already exist"
        end
    end

    def install_ipython
        # ipython
        if not is_this_installed("ipython")
            puts "Installing ipython..."
            system("sudo pip install --upgrade ipython")
        end
    end

    def install_r2
        # radare2
        if not is_this_installed("r2")
            puts "Installing radare2..."
            system("git clone https://github.com/radare/radare2.git ~/radare2")
            system("cd ~/radare2/sys && sudo ./install.sh")
        end
    end

    def install_z3
        # Z3
        res = system("python -c 'import z3'")
        if res == false # start installing
            puts "Installing z3..."
            system("git clone https://github.com/Z3Prover/z3.git ~/z3")
            system("cd ~/z3 && python scripts/mk_make.py --python")
            system("cd ~/z3/build && make && sudo make install")
        else
            puts "z3 already installed"
        end
    end

    def install_angr
        # angr
        # first check virtualenv
        find_virtualenv = "sudo find / -name virtualenvwrapper.sh"
        source_virtualenv = "source $(#{find_virtualenv})"
        res = system("bash -c '#{source_virtualenv} 2>/dev/null'")
        if res == false # no virtualenv
            puts "Installing angr dependencies..."
            install("python-dev libffi-dev build-essential virtualenvwrapper")
        end
        system("cp $(#{find_virtualenv}) #{$CUR_DIR}/aliases/virtualenvwrapper.sh.alias")
        # then check angr
        resp = `bash -c '#{source_virtualenv} && lsvirtualenv'`
        if resp.include?"angr"
            puts "angr already installed"
        else # not install angr virtualenv yet
            system("bash -c '#{source_virtualenv} && mkvirtualenv angr && pip install --upgrade angr && deactivate'")
        end
    end

    def install_afl
        # afl
        if not is_this_installed("afl-fuzz")
            puts "Installing AFL fuzzer..."
            install("clang llvm libtool-bin automake autoconf bison")
            system("cd ~ && wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz")
            system("cd ~ && tar -xzvf afl-latest.tgz && rm afl-latest.tgz")
            system("cd ~/afl-* && make && cd llvm_mode && make && cd ../ && sudo make install && cd qemu_mode && sudo ./build_qemu_support.sh && sudo cp ~/afl-*/afl-qemu-trace /usr/local/bin/")
        end
    end

    def install_qira
        # qira 
        if not is_this_installed("qira")
            puts ("Installing qira...")
            system("cd ~ && git clone https://github.com/BinaryAnalysisPlatform/qira.git")
            system("cd ~/qira/ && sudo ./install.sh")
        end
    end

    def install_pin
        # Intel pin
        if not is_dir_exist("#{Dir.home}/pin")
            puts "Installing Intel-pin..."

            # get the latest download link of intel-pin for gcc-linux
            download_url = "http://software.intel.com/sites/landingpage/pintool/downloads/"
            pin_gcc_linux = /pin-\d+\.\d+-\d+-gcc[.\d]*-linux\.tar\.gz/
            resp = `curl -s https://software.intel.com/en-us/articles/pin-a-binary-instrumentation-tool-downloads`
            latest_pin_file = resp.scan(pin_gcc_linux).sort.reverse[0]
            url = download_url + latest_pin_file
            # download intel-pin and installed inscount0.so
            system("wget #{url} -O ~/pin.tar.gz")
            system("cd ~ && tar xvf pin.tar.gz && rm pin.tar.gz && mv pin-*-gcc*-linux/ pin/")
            system("cd ~/pin/source/tools/ManualExamples/ && make obj-intel64/inscount0.so")
        else
            puts "Intel-pin already exist"
        end
    end
end
