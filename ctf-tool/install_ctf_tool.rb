#!/usr/bin/env ruby

require 'optparse'
require_relative 'tools'

include Tools

$stderr.sync = true
$task_list = []
$options = {}
$symbols = Tools.instance_methods(false)

def init_options()
    for symbol in $symbols
        $options[symbol.to_s] = false
    end
end

def handle_task()
    if $task_list.empty?
        puts "No option was set. Use the -h or --help option to check the usage."
        return
    end

    for task in $task_list
        task.call()
    end
end

def ready_task()
    for symbol in $symbols
        if $options[symbol.to_s] == true
            $task_list << method(symbol)
        end
    end
end

def set_all()
    $options.each do |func, doit|
        $options[func] = true
    end
end

def check_options()
    $options.each do |func, doit|
        puts "#{func} : #{doit}"
    end
end

######### main function ##########

init_options()

# setting opitions
file = __FILE__
ARGV.options do |opts|
    opts.banner = "Usage: #{file} [options] [param]"
   
    opts.on("-A", "--all", "Enable all the following options ( = Install all of them )") { set_all()  }
    opts.on("--bctk", "Install bruce30262's CTF-toolkit (BCTK)") { $options["install_bctk"] = true }
    opts.on("--pwntools", "Install pwntools") { $options["install_pwntools"] = true }
    opts.on("--ropgadget", "Install ropgadget") { $options["install_ropgadget"] = true }
    opts.on("--libcdb", "Download libc database") { $options["install_libcdb"] = true }
    opts.on("--ipython", "Install ipython") { $options["install_ipython"] = true }
    opts.on("--r2", "Install radare2") { $options["install_r2"] = true }
    opts.on("--z3", "Install z3") { $options["install_z3"] = true }
    opts.on("--angr", "Install angr") { $options["install_angr"] = true }
    opts.on("--afl", "Install afl") { $options["install_afl"] = true }
    opts.on("--qira", "Install qira") { $options["install_qira"] = true }
    opts.on("--pin", "Install Intel-pin") { $options["install_pin"] = true }
    opts.on("-h", "--help", "Display this message")         { puts opts; exit 0 }

    OPT = opts

    begin opts.parse!
    rescue OptionParser::InvalidOption => e
        puts e
        puts opts
        exit -1
    end
end

# check_options
ready_task()
handle_task()
