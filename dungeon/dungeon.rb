
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
@giardino = Room.new("giardino", "Un giardino abbandonato")
@scala = Room.new("scala", "Una scala di legno.")

@ingresso.connect(@bagno)
@ingresso.connect(@salone)
@ingresso.connect(@scala)
@salone.connect(@cucina)
@cucina.connect(@giardino)

@campanello = Ringer.new("campanello", "Un campanello da bici")
@ingresso.objs << @campanello

# Environment commands

def start
    print "Inserire il nome del giocatore: "
    pname = gets.chomp
    @me = Player.new(pname)
    @me.set_pos(@ingresso)
end

