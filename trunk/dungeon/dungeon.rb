
require 'room.rb'
require 'generic_object.rb'
require 'player.rb'
require 'environ.rb'

class Object
  def get_name
    line_number   = caller[0].split(':')[1].to_i
    line_exectued = File.readlines(__FILE__)[line_number-1]
    line_exectued.match(/(\S+)\.get_name/)[1]
  end
end 


@ingresso = Room.new("ingresso", "Un ingresso spoglio")
@bagno = Room.new("bagno", "Un bagno con le piastrelle azzurre.")
@salone = Room.new("salone", "Un grosso salone")
@cucina = Room.new("cucina", "Una cucina dalle piastrelle gialle e un tavolo al centro.")
@scala = Room.new("scala", "Una scala di legno.")
@giardino = Room.new("giardino", "Un giardino abbandonato.")

# Override of the description of "giardino"
@giardino.desc << "\nSono le #{Time.new.hour}, il giardino e' #{Time.new.hour.between?(8,20) ? 'luminoso' : 'oscuro'}."

@ingresso.connect(@bagno)
@ingresso.connect(@salone)
@ingresso.connect(@scala)
@salone.connect(@cucina)
@cucina.connect(@giardino)

# Room constraints
@giardino.instance_variable_set("@broken", false)
def @giardino.can_go_out?
    if @broken
        puts "La porta e' stata scardinata"
        return true
    end
    
    puts "La porta ti si e' chiusa alle spalle e ora non puoi rientrare"
    return false
end

# Objects
@campanello = Ringer.new("campanello", "Un campanello da bici")
@ingresso.objs << @campanello
@banana = Banana.new("banana", "Una buccia di banana")
@giardino.objs << @banana

print "Inserire il nome del giocatore: "
pname = gets.chomp
@me = Player.new(pname)
@me.set_pos(@ingresso)

puts "Digita start per iniziare a giocare"
