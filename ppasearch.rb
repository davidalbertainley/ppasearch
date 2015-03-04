#! /usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'net/https'
require 'openssl'
require 'optparse'

#to stop a problem from coming out when the program is exited via cntrl+c
#stty_save = `stty -g`.chomp
#trap('INT') { system('stty', stty_save); exit }

# This hash will hold all of the options
# parsed from the command-line by
# OptionParser.
options = {}
 
optparse = OptionParser.new do|opts|
	# Set a banner, displayed at the top
	# of the help screen.
	opts.banner = 'Usage: Just type "ppasearch whatever", whatever being the name of the PPA you want to search for.  Spaces are okay.'
   
	# This displays the help screen, all programs are
	# assumed to have this option.
	opts.on( '-h', '--help', 'Display this screen' ) do
		puts opts
		exit
	end


	opts.on( '-c', '--changes', 'Display changes for current version' ) do
		puts "Changes for ppasearch version 0.7 => added package search."
		exit
	end

	opts.on('-v', '--version', 'Display version' ) do
		puts "Version 0.7.1"
		exit
	end



	opts.on( '-p', '--package', 'Display packages instead of repositories' )do

		module OpenSSL
			module SSL
			remove_const :VERIFY_PEER
		end
	end

	OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

	if ARGV[0].nil?
		puts 'To search for a package, type "ppasearch --p pino", with pino being the package or program you are looking for.'
		Process.exit! 
	end

	search1 = ARGV[0]

	search = "#{search1}"

#unfortunately, html addresses can't handle spaces.  whenever they see one, they replace it with a plus, so im doing the same.
	if search.include? ' '
		search.sub!(' ','+')
	end

	puts "\n"
	puts "Searching..."

#This opens the page with hpricot. Whatever you put in for 'search' is put in where the search would go in the html. also uses the links.
	doc = Hpricot( open( 'https://launchpad.net/ubuntu/+ppas?name_filter=' + search) )

#getting some data from the website.  tds are the name of the ppas, and links are the 
	tds=(doc/"/html/body/div/div[3]/div/div[2]/div[2]/table[2]/tbody/tr/td/a")
	linkz =(doc/"/html/body/div/div[3]/div/div[2]/div[2]/table[2]/tbody/tr/td/a")

#this array is for the array of html paths needed for the installation choice of ppa.  also flatoutarray, for the -v opt.
	sweetassarray = Array.new
	flatoutarray = Array.new
	testingarray = Array.new
	afourtharray = Array.new
	whothefuckknows = Array.new
	thisismyarray = Array.new
	anoldarray = Array.new
	arrayforspacing = Array.new
	davidsarray = Array.new
	yespossibly6 = Array.new
	yespossibly7 = Array.new

#this makes a nice list of data needed for the users choice later on.
	flabber=(linkz).inject([]) do |links,anchor|
		flatoutarray << anchor.attributes['href']
	end

#each item in flabber, is being called a pathway, and then being opened in hpricot.  i need each one of THOSE though, 
#so I can open up each page as is own thing.  then i need
#to figure out a way to search the table for pathway, and print them.
	flabber.each { |pathway| testingarray << Hpricot( open( 'https://launchpad.net' + pathway + '?field.series_filter=')) }

#tis is getting a slice of the data i need.  the subs clean up the data, getting rid of html tags and whatnot, but its still not very clean or usable.
	testingarray.each { |parses| afourtharray << (parses/"/html/body/div/div[3]/div/div/div[4]/div/table[2]/tbody/tr/td").inner_text.gsub("\ ", "").gsub("\n", " ")}

#changes the slice into a string
	clean = afourtharray.to_s
#substituting every four spaces with a new line
	cleaner = clean.gsub("    ", "\n")
#then subbing the first two spaces with a nothing
	cleanest = cleaner.sub("  ","")
#then creating an array using the split function, splitting wherever there is a newline
	whothefuckknows = cleanest.split(/\n/)

#look at each element in whothefuckknows.  does it contain what we searched for? if yes, add it to anoldarray.
	whothefuckknows.each do |elmt|
		if elmt.include? "#{search}"
			anoldarray << elmt
		else
		end
	end

#good news!  if we put whothefuckknows as it is above, we get a fairly decent  list.  but they look ugly.  they need to be systematically spaced!

	thefirst = anoldarray.join(":")
	offspring = thefirst.to_s
	offspring2 = offspring.gsub( /\s+/, "\t" )
	offspring3 = offspring2.gsub(":", "\n")
	arrayforspacing << offspring3.split(/\n/)

	x = IO.popen("column -t", "w+"){|p|
		p.puts arrayforspacing.join("\n")
		p.close_write
		p.read
	}

	davidsarray = x.split(/\n/)


	if davidsarray.any?
		puts "\n"
		puts "Good news! Found #{davidsarray.count} results!"
		puts "\n"

		davidsarray.each_with_index do |davidsarrayname, index|
			puts "[#{index+1}] #{davidsarrayname}"
			end
		puts "\n"
		puts "Which package would you like to install?"
		
		choosingapackage = STDIN.gets
		
		choosingapackage2 = choosingapackage.to_i 
		
		thisshouldwork = flatoutarray[choosingapackage2-1]
		
		okayletssee = Hpricot( open( 'https://launchpad.net' + thisshouldwork + "?field.series_filter=") )
		thefinal2 = (okayletssee/"/html/body/div/div[3]/div/div/div[3]/div/div/p/strong").inner_html
		
		puts "Add " + thefinal2 + " to your Software Sources? [Y/N]"
		
		babies=STDIN.gets
		
		if babies.include?('Y')
			puts "Would you like to see what other packages are in that repository? [Y/N]"
			babies2=STDIN.gets
			if babies2.include?('Y')
				yespossibly = ((okayletssee/"/html/body/div/div[3]/div/div/div[4]/div/table[2]/tbody/tr/td").inner_text.gsub("\ ", "").gsub("\n", " "))
				yespossibly2 = yespossibly.gsub("    ", "\n")
				yespossibly4 = yespossibly2.sub("  ","")
				yespossibly6 << yespossibly4.split(/\n/)
					
				o = IO.popen("column -t", "w+"){|e|
					e.puts yespossibly6.join("\n")
					e.close_write
					e.read
				}

				puts "\n"
				puts o
				puts "\n"
				
			
			elsif babies2.include?('y')
				yespossibly1 = ((okayletssee/"/html/body/div/div[3]/div/div/div[4]/div/table[2]/tbody/tr/td").inner_text.gsub("\ ", "").gsub("\n", " "))
				yespossibly3 = yespossibly1.gsub("    ", "\n")
				yespossibly5 = yespossibly3.sub("  ","")
				yespossibly7 << yespossibly5.split(/\n/)
				
				t = IO.popen("column -t", "w+"){|c|
					c.puts yespossibly7.join("\n")
					c.close_write
					c.read
				}

				puts "\n"
				puts t
				puts "\n"
				
			
			else
			Process.exit!
			end
			
			puts "Continue? [Y/N]"
			babies3=STDIN.gets
			
			puts "\n"
			if babies3.include?('Y')
				system ('sudo add-apt-repository ' + thefinal2)
			
			elsif babies3.include?('y')
				system ('sudo add-apt-repository ' + thefinal2)
			
		
			else
			Process.exit!
			end
			
			puts "\n"
			puts "Do you want to update your sources now? [Y/N]"
			updateanswer2=STDIN.gets
			puts "\n"
			
			if updateanswer2.include?('Y')
				system ('sudo apt-get update')
				Process.exit!
			elsif updateanswer2.include?('y')
				system ('sudo apt-get update')
				Process.exit!
			else
			Process.exit!
			end
			
		elsif babies.include?('y')
			puts "Would you like to see what other packages are in that repository? [Y/N]"
			babies2=STDIN.gets
			if babies2.include?('Y')
				yespossibly = ((okayletssee/"/html/body/div/div[3]/div/div/div[4]/div/table[2]/tbody/tr/td").inner_text.gsub("\ ", "").gsub("\n", " "))
				yespossibly2 = yespossibly.gsub("    ", "\n")
				yespossibly4 = yespossibly2.sub("  ","")
				yespossibly6 << yespossibly4.split(/\n/)
					
				o = IO.popen("column -t", "w+"){|e|
					e.puts yespossibly6.join("\n")
					e.close_write
					e.read
				}

				puts "\n"
				puts o
				puts "\n"
				
			
			elsif babies2.include?('y')
				yespossibly1 = ((okayletssee/"/html/body/div/div[3]/div/div/div[4]/div/table[2]/tbody/tr/td").inner_text.gsub("\ ", "").gsub("\n", " "))
				yespossibly3 = yespossibly1.gsub("    ", "\n")
				yespossibly5 = yespossibly3.sub("  ","")
				yespossibly7 << yespossibly5.split(/\n/)
				
				t = IO.popen("column -t", "w+"){|c|
					c.puts yespossibly7.join("\n")
					c.close_write
					c.read
				}

				puts "\n"
				puts t
				puts "\n"
			
			else
			end
			
			puts "Continue? [Y/N]"
			babies3=STDIN.gets
			puts "\n"
			
			if babies3.include?('Y')
				system ('sudo add-apt-repository ' + thefinal2)
			
			elsif babies3.include?('y')
				system ('sudo add-apt-repository ' + thefinal2)
								
			else
			Process.exit!
			end
			
			puts "\n"
			puts "Do you want to update your sources now? [Y/N]"
			updateanswer2=STDIN.gets
			puts "\n"
			
			if updateanswer2.include?('Y')
				system ('sudo apt-get update')
				Process.exit!
			elsif updateanswer2.include?('y')
				system ('sudo apt-get update')
				Process.exit
			else
			Process.exit!
			end
		
		else
		Process.exit!
		end
		
		
	else
	puts "No results found."
	Process.exit!
	end




end

end

 
# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options. What's left is the list of files to resize.

optparse.parse!

module OpenSSL
	module SSL
		remove_const :VERIFY_PEER
	end
end

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

if ARGV[0].nil?
	puts 'To search for a PPA, type "ppasearch ppaname"'
	Process.exit! 
end

search1 = ARGV[0]

search = "#{search1}"

#unfortunately, html addresses can't handle spaces.  whenever they see one, they replace it with a plus, so im doing the same.
if search.include? ' '
	search.sub!(' ','+')
end

#This opens the page with hpricot. Whatever you put in for 'search' is put in where the search would go in the html. also uses the links.
doc = Hpricot( open( 'https://launchpad.net/ubuntu/+ppas?name_filter=' + search) )

#getting some data from the website.  tds are the name of the ppas, and links are the 
tds=(doc/"/html/body/div/div[3]/div/div[2]/div[2]/table[2]/tbody/tr/td/a")
linkz =(doc/"/html/body/div/div[3]/div/div[2]/div[2]/table[2]/tbody/tr/td/a")


#this array is for the array of html paths needed for the installation choice of ppa
sweetassarray = Array.new

#this makes a nice list of data needed for the users choice later on.
(linkz).inject([]) do |links,anchor|
	sweetassarray << anchor.attributes['href']
end

#creating an array to be used later, to keep the names / numbers of ppas orderly.
myarray = Array.new

#gets the ppa names, puts them into the array 'myarray'
ppas=(tds/"///<td>").each do |k|
	myarray << k
end

#if there were any ppas, it prints the amount, adds a blank line, prints the ppas, prints another line, and asks the user which one they want to install.
#the if else statement has to be long, because the program needs to end if no results are found.
if ppas.any?
	puts "\n"
	puts "Good news! Found #{ppas.count} results!"
	puts "\n"

#takes each unit in the myarray array, and gets the name and number (or, "index") and prints them.
#remember, indexes start with 0, so you need to say +1 to start on one instead of zero.
	myarray.each_with_index do |ppaname, index|
		puts "[#{index+1}] #{ppaname}"
	end

	puts "\n"
	puts "Which one would you like to install?"

	radical = STDIN.gets

	#they put in a number, i convert it to an integer.
	givethemwhattheywant = radical.to_i

#from there, i use that integer to give me the area of the sweetassarray (the one that has all the html directories), of the corresponding ppa.
	correct = sweetassarray[givethemwhattheywant-1]

#more of the same
	seconddoc = Hpricot( open( 'https://launchpad.net' + correct) )
	thefinal = (seconddoc/"/html/body/div/div[3]/div/div/div[3]/div/div/p/strong").inner_html

	puts "Are you SURE you want to add " + thefinal + " to your Software Sources? [Y/N]"
	answerlol=STDIN.gets

	if answerlol.include? 'Y'
		system ('sudo add-apt-repository ' + thefinal)
	else
	end

	if answerlol.include? 'y'
		system ('sudo add-apt-repository ' + thefinal)
	else
	end

	puts "\n"
	puts "Do you want to update your sources now? [Y/N]"
	updateanswer=STDIN.gets

	if updateanswer.include? 'Y'
		system ('sudo apt-get update')
	else
	end

	if updateanswer.include? 'y'
		system ('sudo apt-get update')
	else
	end

#creates the last array
	lastarray = Array.new

else
puts "No results found.  Try refining your search."
end