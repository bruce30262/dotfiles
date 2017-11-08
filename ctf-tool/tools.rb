#!/usr/bin/env ruby

require_relative '../setup_func'
require 'json'

module Tools
    include Myutil

    def install_bctk
        # my CTF toolkit (Bruce CTF TooKit)
        if not is_dir_exist("#{Dir.home}/CTF-master")
            puts "Installing bruce30262 CTF-toolkit..."
            system("git clone https://github.com/bruce30262/CTF.git ~/CTF-master")
            system("cp ~/CTF-master/ctfrc ~/dotfiles/aliases/ctfrc.alias")
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
            system("cd ~/libc-database && ./get")
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
            # install r2pipe
            system("sudo pip install r2pipe")
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
            puts "Installing qira..."
            system("cd ~/ && wget -qO- https://github.com/BinaryAnalysisPlatform/qira/archive/v1.2.tar.gz | tar zx && cd qira-1.2 && sudo ./install.sh")
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

    def install_rr
        if not is_this_installed("rr")
            # check arch
            arch = `uname -a`
            if arch.include?"x86_64"
                arch = "x86_64"
            elsif arch.include?"i686"
                arch = "i686"
            else
                puts "rr for arch #{arch} not supported"
                puts "Cancelling rr installation..."
                return
            end
            # install perf
            puts "Installing perf..."
            install("linux-tools-common linux-tools-`uname -r`")
            # get latest release download url
            url, d_url = "https://api.github.com/repos/mozilla/rr/releases/latest", nil
            resp = JSON.parse(`curl -s #{url}`)
            for assets in resp["assets"]
                name = assets["name"]
                if name.include?"#{arch}" and name.include?".deb"
                    d_url = assets["browser_download_url"]
                    break
                end
            end

            return if d_url == nil
           
            # download & install the latest release
            filename = d_url.split("/")[-1]
            puts "Download latest release: #{d_url}"
            system("wget #{d_url}")
            puts "Installing #{filename}"
            system("sudo dpkg -i ./#{filename}")
            puts "Removing #{filename}"
            system("rm ./#{filename}")

            # write perf_event_paranoid
            system("sudo bash -c 'echo 1 >/proc/sys/kernel/perf_event_paranoid'")
            system("sudo bash -c 'echo kernel.perf_event_paranoid=1 > /etc/sysctl.d/local.conf'")

            # print final message
            puts "Done installing rr"
            pep = `cat /proc/sys/kernel/perf_event_paranoid`.strip()
            puts "Current /proc/sys/kernel/perf_event_paranoid = #{pep} ( should <= 1 for rr to work )"
            puts "If you're in VMware, make sure to enable \"Virtualize CPU performance counters\" option"
        end
    end
end
