
require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'cgi'

start = 'http://www.facebook.com/XinFeiTorino'
load_delay = 0
outfile = 'xinfei.dot'

url_list = Array.new
url_list << start

file = File.new(outfile, "w")

file.write("graph {\n")

graphlines = Array.new

url_list.each do |u|
    
    puts "seeking for #{u} (#{url_list.size} pending)"

    doc = Hpricot(open(u, 
        'User-Agent' => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) ' + 
        'Gecko/20100330 Fedora/3.5.9-2.fc12 Firefox/3.5.9').read)

    this_user = doc.search("//title").inner_html.split('|')[0].chop

    url_list.delete(u)

    friends = doc.search("//div[@class='UIPortrait_Text']/a")
    
    friends.each do |f|
        #puts "\"#{this_user}\" -- \"#{f[:title]}\""
        tu = CGI::unescapeHTML(this_user)
        tit = f[:title]
        
        user1 = (tu < tit ? tu : tit)
        user2 = (tu < tit ? tit : tu)
        
        line = "\"#{user1}\" -- \"#{user2}\";\n"

        if !graphlines.include?(line)
            graphlines << line
            file.write(line)
            file.flush
        end
                
        url_list << f[:href]
   end

   sleep load_delay
end



