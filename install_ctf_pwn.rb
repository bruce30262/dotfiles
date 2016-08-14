#!/usr/bin/env ruby

require_relative 'setup_func'
include Myutil

# my CTF toolkit
if not is_dir_exist("#{Dir.home}/CTF")
    puts "Installing bruce30262 CTF-toolkit..."
    system("git clone https://github.com/bruce30262/CTF.git ~/CTF")
else
    puts "bruce30262 CTF-toolkit already installed"
end

# pwntools
res = system("python -c 'import pwn'")
if res == false # start installing
    puts "Installing pwntools..."
    system("sudo apt-get install -y python2.7 python2.7-dev python-pip libffi-dev libssl-dev libssh-dev")
    system("sudo pip install --upgrade git+https://github.com/Gallopsled/pwntools.git")
else # already install
    puts "pwntools already installed"
end

# ROPGadget
if not is_this_installed("ROPgadget")
    system("git clone https://github.com/JonathanSalwan/ROPgadget.git ~/ROPgadget")
    system("cd ~/ROPgadget && sudo python setup.py install")
end

# libc-database
if not is_dir_exist("#{Dir.home}/libc-database")
    puts "Downloading libc-database..."
    system("git clone https://github.com/niklasb/libc-database.git ~/libc-database")
else
    puts "libc-database already exist"
end

# ipython
if not is_this_installed("ipython")
    puts "Installing ipython..."
    system("sudo pip install --upgrade ipython")
end

# radare2
if not is_this_installed("r2")
    puts "Installing radare2..."
    system("git clone https://github.com/radare/radare2.git ~/radare2")
    system("cd ~/radare2/sys && sudo ./install.sh")
end

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

# angr
# first check virtualenv
FIND_VIRTUALENV = "sudo find / -name virtualenvwrapper.sh"
SOURCE_VIRTUALENV = "source $(#{FIND_VIRTUALENV})"
res = system("bash -c '#{SOURCE_VIRTUALENV} 2>/dev/null'")
if res == false # no virtualenv
    puts "Installing angr dependencies..."
    system("sudo apt-get install -y python-dev libffi-dev build-essential virtualenvwrapper")
end
system("cp $(#{FIND_VIRTUALENV}) #{$CUR_DIR}/aliases/virtualenvwrapper.sh.alias")
# then check angr
resp = `bash -c '#{SOURCE_VIRTUALENV} && lsvirtualenv'`
if resp.include?"angr"
    puts "angr already installed"
else # not install angr virtualenv yet
    system("bash -c '#{SOURCE_VIRTUALENV} && mkvirtualenv angr && pip install --upgrade angr && deactivate'")
end

