#!/usr/bin/env ruby

require 'fileutils'

$CUR_DIR = File.expand_path(File.dirname(__FILE__))

def err_out(msg)
    puts msg
    exit 1
end

if Process.euid != 0
    err_out("Use sudo to run this program.")
end

puts "Truetype folder Creating..."

$TRUETYPE_DIR = "/usr/share/fonts/truetype"
Dir.glob("#{$CUR_DIR}/*tf") do |filename|
    # get font name
    eidx = filename.length-1
    while(filename[eidx] != '.')
        eidx -= 1
    end
    sidx = eidx
    while(filename[sidx] != '/')
        sidx -= 1
    end
    font_file = filename[sidx+1..-1]
    folder_name = "#{$TRUETYPE_DIR}/" + filename[sidx+1..eidx-1]
    # create folder and copy font to that folder
    puts "Creating folder: #{folder_name}/"
    FileUtils.mkdir_p folder_name
    puts "Copying #{filename} to #{folder_name}..."
    FileUtils.cp(filename, folder_name)
    # modify permission
    puts "Modifying font permission..."
    FileUtils.chmod 0644,"#{folder_name}/#{font_file}"
end

puts "Installing font with fc-cache..."
system("fc-cache -fv")

puts("All done!")

