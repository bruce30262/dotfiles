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
            system("cp ~/CTF-master/ctfrc ~/dotfiles/rcS/ctfrc.alias")
        end
        if system("python -c 'import brucepwn'") == false
            # install brucepwn
            puts "Installing brucepwn..."
            system("cd ~/CTF-master/script/brucepwn/ && sudo python setup.py install")
        else
            puts "bruce30262 CTF-toolkit already installed"
        end
    end

    def install_pwntools
        # python3 pwntools
        res = system("python3 -c 'import pwn'")
        if res == false # start installing
            puts "Installing pwntools..."
            install("python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential")
            system("sudo pip3 install --upgrade pip")
            system("sudo pip3 install --upgrade pwntools")
        else # already install
            puts "pwntools already installed"
        end
    end

    def install_ropper
        # ropper
        if not is_this_installed("ropper")
            system("sudo pip3 install capstone")
            system("sudo pip3 install filebytes")
            system("sudo pip3 install ropper")
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
        # python3 ipython
        if not is_this_installed("ipython3")
            puts "Installing ipython3..."
            system("sudo pip3 install --upgrade ipython")
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
        res = system("python3 -c 'import z3'")
        if res == false # start installing
            puts "Installing z3..."
            system("git clone https://github.com/Z3Prover/z3.git ~/z3")
            system("cd ~/z3 && python3 scripts/mk_make.py --python")
            system("cd ~/z3/build && make -j $(nproc) && sudo make install")
        else
            puts "z3 already installed"
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
            url, d_url = "https://api.github.com/repos/rr-debugger/rr/releases/latest", nil
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
