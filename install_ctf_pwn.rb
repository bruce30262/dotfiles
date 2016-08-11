#!/usr/bin/env ruby

require_relative 'setup_func'
include Myutil

# my CTF toolkit
if not is_dir_exist("#{Dir.home}/CTF")
    puts "Installing bruce30262 CTF-toolkit..."
    system("git clone https://github.com/bruce30262/CTF.git ~/CTF")
elsif
    puts "bruce30262 CTF-toolkit already installed"
end

# pwntools
res = system("python -c 'import pwn'")
if res == false # start installing
    puts "Installing pwntools..."
    system("sudo apt-get install -y python2.7 python2.7-dev python-pip libffi-dev libssl-del libssh-dev")
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
elsif
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

# angr
res = system("python -c 'import angr'")
if res == false
    system("sudo apt-get install -y python-dev libffi-dev build-essential virtualenvwrapper")
    system("sudo pip install --upgrade angr")
else
    puts "angr already installed"
end
