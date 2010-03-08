
class Player
    attr_reader :name
    attr :position
    attr :objs
    
    def initialize(name)
        @name = name
        @objs = Array.new
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
    
    def fade
        @position = nil
    end
end

