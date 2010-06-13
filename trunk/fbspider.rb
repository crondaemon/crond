
require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'cgi'

start = 'http://www.facebook.com/XinFeiTorino'
load_delay = 0
max_depth = 2
outfile = 'xinfei.dot'

url_list = Array.new
url_list << { :url => start, :depth => 0 }

file = File.new(outfile, "w")

file.write("graph {\n")

graphlines = Array.new

puts "\n\nSpider starts from #{start} building web up to #{max_depth} levels\n\n"

url_list.each do |elem|
    
    if elem[:depth] > max_depth
        file.write("}\n")
        exit
    end
    
    u = elem[:url]
    
    puts "Seeking for #{u}, depth #{elem[:depth]} from root (#{graphlines.size}" +
        " loaded, #{url_list.size} pending)"

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
        else
            puts "Duplicate found!"
        end
                
        url_list << { :url => f[:href], :depth => elem[:depth]+1 }
   end

   sleep load_delay
end


# http://briansblog.net/blog1.php/2008/05/20/mechanize-for-page-scraping-facebook
# $fbUrl = "http://www.facebook.com"
# $agent = WWW::Mechanize.new
# $agent.user_agent_alias  = "Mac FireFox"

# page = $agent.get($fbUrl)

# loginf = page.forms[0]
# loginf['email'] = 'lomato@gmail'
# loginf['pass'] = 'xxx'

# home = $agent.submit(loginf, loginf.buttons.first)

