#!/usr/bin/env ruby

resp = `find $HOME -name ".git"`.split("\n")

repo = []

for d in resp
    if d.include?".vim" # ~/.vim is special case
        next
    else
        repo << d.split(".git")[0]
    end
end

puts "The following repos will be updated:"
puts repo

while true
    print "\nStart git pull ? <y/n>"
    choice = gets.chomp.strip().downcase
    if choice == "n"
        puts "Program exit..."
        exit 1
    elsif choice == "y"
        puts "OK"
        break
    else
        puts "Wrong input"
    end
end

for dir in repo
    puts "git pulling #{dir}..."
    system("cd #{dir} && git pull")
end

puts "All done !!"
