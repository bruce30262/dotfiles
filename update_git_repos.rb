#!/usr/bin/env ruby

repo = []

def ask(dir)
    while true
        print "\ngit pull #{dir}? <y/n>"
        choice = gets.chomp.strip().downcase
        if choice == "n"
            return false
        elsif choice == "y"
            return true
        else
            puts "Wrong input"
        end
    end
end

resp = `find $HOME -name ".git"`.split("\n")

for d in resp
    if d.include?".vim" # ~/.vim is special case
        next
    else
        repo << d.split(".git")[0]
    end
end

for dir in repo
    if ask(dir)
        puts "git pulling #{dir}..."
        system("cd #{dir} && git pull")
    end
end

puts "\nAll done !!"
