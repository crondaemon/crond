
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
        puts "Questo oggetto non ha un uso particolare"
    end
end

class Ringer < GenericObject
    def actions
        puts "\n\n"
        (1..3).each do
            puts "Un campanello suona"
            sleep 1
        end
    end
    
    def use
        (1..5).each do
            print "drin "
            sleep 1
        end
        puts "\n\n"
    end
end

class Banana < GenericObject
    def actions
        puts "Appena entri metti il piede su una buccia di banana e scivoli"
    end
end
