#!/usr/bin/env ruby

# For now the AEG tools ( angr & manticore ) are all run as a docker service
# So don't run this script inside a docker container

require 'optparse'
require_relative '../setup_func'

include Myutil

$stderr.sync = true
$task_list = []
$options = {}
$symbols = ["angr", "manticore"]
$isall = false

def check_dependencies(tool)
    if not is_this_installed("docker")
        puts "Please install docker first"
        return false
    end
    if not is_dir_exist("#{Dir.home}/CTF-master/script/AEG/#{tool}")
        puts "Please install BCTK first"
        return false
    end

    return true    
end

def install_aeg(tool)
    if check_dependencies(tool)
        system("cp -r ~/CTF-master/script/AEG/#{tool}/ ~/")
        system("cd ~/#{tool} && make pull")
    end
end

def init_options()
    for symbol in $symbols
        $options[symbol] = false
    end
end

def handle_task()
    if $task_list.empty?
        puts "No option was set. Use the -h or --help option to check the usage."
        return
    end

    for task in $task_list
        install_aeg(task)
    end
end

def ready_task()
    for symbol in $symbols
        if $options[symbol] == true
            $task_list << symbol
        end
    end
end

def set_all()
    $isall = true
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
   
    opts.on("-A", "--all", "Enable all the following options ( = Install all of them )") { set_all() }
    opts.on("--angr", "Install angr") { $options["angr"] = true }
    opts.on("--manticore", "Install manticore") { $options["manticore"] = true }
    opts.on("-h", "--help", "Display this message")         { puts opts; exit 0 }

    OPT = opts

    begin opts.parse!
    rescue OptionParser::InvalidOption => e
        puts e
        puts opts
        exit -1
    end
end

# check_options()
ready_task()
handle_task()
