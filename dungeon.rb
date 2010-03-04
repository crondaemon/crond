
# eval File.read('dungeon.rb')

class Room
    attr :desc
    attr_reader :name
    attr :exits
    attr :players
    attr :objs
    
    def initialize(name, desc)
        @name = name
        @desc = desc
        @exits = Array.new
        @players = Array.new
        @objs = Array.new
    end
    
    def connect(room, propagate=true)
        if (!@exits.include?(room))
            @exits << room
        end
        if (propagate == true)
            room.connect(self, false)
        end
    end
    
    def connected?(room)
        return @exits.include?(room)
    end
    
    def add_player(player)
        @players << player
    end
    
    def del_player(player)
        @players.delete(player)
    end
    
    def show
        puts "\n*** #{@name} ***\n"
        puts "#{@desc}\n\n"
        puts "[personaggi]\n"
        puts @players.collect {|p| p.name}
        puts "\n"
        puts "[oggetti]\n"
        puts @objs.collect {|o| o.name}
        puts "\n"
        puts "[uscite]\n"
        puts @exits.collect {|e| e.name}
    end
    
    def act
        @objs.each do |o|
            o.actions
        end
    end
end

class GenericObject
    attr :name
    attr :desc
    def initialize(name, desc)
        @name = name
        @desc = desc
    end
    
    def actions
    end
    
    def show
        puts desc
    end
    
    def use
    end
end

class Ring < GenericObject
    def actions
        puts "\n\n"
        (1..3).each do
            puts "Un campanello suona"
            sleep 1
        end
    end
    
    def use
        puts "ring ring"
    end
end

class Player
    attr_reader :name
    attr :position
    
    def initialize(name)
        @name = name
    end
    
    def set_pos(room)
        # check if room is a good exit
        if (@position && !@position.connected?(room))
            puts "Passaggio non valido"
            return
        end
    
        # remove me from current room
        @position.del_player(self) if @position
    
        # add me to new room
        @position = room
        room.add_player(self)
        room.show
        # run action of the room
        room.act
    end
    
    def fade
        @position = nil
    end
end

@r1 = Room.new("ingresso", "Un ingresso spoglio")
@r2 = Room.new("bagno", "Un bagno con le piastrelle azzurre.")
@r3 = Room.new("salone", "Un grosso salone")
@r4 = Room.new("cucina", "Una cucina dalle piastrelle gialle e un tavolo al centro.")
@r5 = Room.new("giardino", "Un giardino abbandonato")
@r6 = Room.new("scala", "Una scala di legno.")

@r1.connect(@r2)
@r1.connect(@r3)
@r1.connect(@r6)
@r3.connect(@r4)
@r4.connect(@r5)

@ring = Ring.new("campanello", "Un campanello da bici")
@r1.objs << @ring

# Environment commands

def start
    print "Inserire il nome del giocatore: "
    pname = gets.chomp
    @player = Player.new(pname)
    @player.set_pos(@r1)
end

def translate(group, objname)
    group.each do |o|
        return o if o.name == objname
    end
end

def go(roomname)
    room = translate(@player.position.exits, roomname)
    if room
        @player.set_pos(room)
    else
        puts "Uscita inesistente (#{roomname})"
    end
end

def show
    @player.position.show
end

def look(objname)
    obj = translate(@player.position.objs, objname)
    obj.show
end

def helpme
    puts "\nComandi disponibili:\n\n"
    puts "go <stanza> - vai nella stanza"
    puts "show - mostra la stanza corrente"
    puts "look <oggetto> - esamina un oggetto"
    puts "use <oggetto> - usa un oggetto"
end

def use(objname)
    obj = translate(@player.position.objs, objname)
    obj.use
end
