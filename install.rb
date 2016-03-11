#!/usr/bin/env ruby

# executed by install.sh

require 'optparse'
require_relative 'setup_func'
include Setup

$stderr.sync = true
$task_list = []
$options = {}
$symbols = Setup.instance_methods(false)

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

def init_options()
    for symbol in $symbols
        $options[symbol.to_s] = false
    end
end

def isValidEmail(email)
    if email.empty? or email.nil?
        return nil
    else
        res = email.match(VALID_EMAIL_REGEX)
        if res.nil?
            return nil
        else
            return res[0] # valid email address
        end
    end
end

def handle_task()
    if $task_list.empty?
        puts "No option was set. Use the -h or --help option to check the usage."
        return
    end

    for task in $task_list
        if task.name.to_s == "gen_git_sshkey"
            puts "Prepare to generate ssh key. Please enter a valid email address:"
            input = gets.chomp
            email = isValidEmail( input.strip() )
            if email.nil? # invalid email address
                puts "Invalid format of email address: #{input}"
                puts "Aborting task..."
                next
            else
                task.call(email)
            end
        else
            task.call()
        end
    end
end

def ready_task()
    $options["gen_git_sshkey"] = false if $options["set_git"] == true

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
    opts.on("--tmux", "Install tmux and set .tmux.conf") { $options["install_tmux"] = true }
    opts.on("--NOT", "Install nautilus-open-terminal") { $options["install_NOT"] = true }
    opts.on("--bashrc", "Set the .bashrc file") { $options["set_bashrc"] = true }
    opts.on("--git", "Setting git, including setting the .gitconfig file and generate the ssh key") { $options["set_git"] = true }
    opts.on("--sshkey", "Generate a RSA 4096 bit ssh key pair ( require user email )") { $options["gen_git_sshkey"] = true }
    opts.on("-h", "--help", "Display this message")         { puts opts; exit 0 }

    OPT = opts
    opts.parse!
end

# check_options()
ready_task()
handle_task()
