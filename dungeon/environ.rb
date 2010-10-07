# Environment commands

def go(room = nil)
    if room.nil?
        puts "Uso: go <room>"
        return
    end
    if @me.position.exits.include?(room)
        if @me.position.can_go_out?
            @me.set_pos(room)
        end
    else
        puts "Uscita inesistente (#{roomname})"
    end
end

def show(obj = nil)
    look(obj)
end

def look(obj = nil)
    # if no params, look this room
    if obj.nil?
        @me.position.show
        return
    end
    
    if @me.position.objs.include?(obj)
        obj.show
        return
    end
    
    if @me.objs.include?(obj)
        obj.show
        return
    end
    
    puts "Non vedo nessun oggetto #{obj.name}"
end

def helpme
    puts "\nComandi disponibili:\n\n"
    puts "go <stanza> - vai nella stanza"
    puts "show - mostra la stanza corrente"
    puts "look <oggetto> - esamina un oggetto"
    puts "use <oggetto> - usa un oggetto"
    puts "pick <oggetto> - raccogli un oggetto"
    puts "drop <oggetto> - lascia un ggetto"
end

def use(obj = nil)
    if obj.nil?
        puts "Uso: use <object>"
        return
    end
    
    if @me.position.objs.include?(obj)
        obj.use
    else
        puts "Oggetto non presente (#{obj.name})"
    end
end

def pick(obj = nil)
    if obj.nil?
        puts "Uso: pick <object>"
        return
    end
    
    if @me.position.objs.include?(obj)
        @me.position.del_object(obj)
        @me.add_object(obj)
        puts "Oggetto #{obj.name} raccolto."
    else
        puts "Oggetto non presente."
    end
end

def drop(obj = nil)
    if obj.nil?
        puts "Uso: drop <object>"
        return
    end
    
    if @me.objs.include?(obj)
        @me.del_object(obj)
        @me.position.add_object(obj)
        puts "Oggetto #{obj.name} lasciato."
    else
        puts "Oggetto non presente."
    end
end

def inventory
    puts "[inventario]\n\n"
    @me.objs.each do |o|
        puts "#{o.name}: #{o.desc}"
    end
    puts "\n\n"
end

def i
    inventory
end

