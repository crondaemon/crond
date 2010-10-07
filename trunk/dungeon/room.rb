
class Room
    attr_accessor :desc
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
        if @players.include?(player)
            @players.delete(player)
        else
            puts "Player #{player.name} non presente"
        end
    end
    
    def add_object(obj)
        @objs << obj
    end
    
    def del_object(obj)
        if @objs.include?(obj)
            @objs.delete(obj)
        else
            puts "Oggetto #{obj.name} non presente"
        end
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
    
    def can_go_out?
        return true
    end
end
