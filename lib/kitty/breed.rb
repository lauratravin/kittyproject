class CatBreeds::Breed
        @@all= [ ]
        @@reference= [ ]
        attr_accessor :name, :web
    def initialize(name, web=nil)
        @name= name
        @web= web if web != nil
        @@all << self
    end    
    def add(attributes)  #creates attributes dynamically                
        attributes.each do |attribute_name, attribute_value|               
            self.class.send(:define_method, "#{attribute_name}=".to_sym) do |value|
                    instance_variable_set("@" + attribute_name.to_s, value)
            end
            self.class.send(:define_method, attribute_name.to_sym) do
                    instance_variable_get("@" + attribute_name.to_s)
            end
            self.send("#{attribute_name}=".to_sym, attribute_value)                
        end

        
    end
    def self.all
        @@all
    end 
    def self.reference
        @@reference
    end   
    def self.search_breed_by_name(str)  #A or a  
        var = false
        self.all.select.with_index do |b,index|     
            if b.name[0].downcase == str.strip  #dont use function match, doesnt work very well.
                puts "   #{index+1}. #{b.name}"
                var = true              
            end                   
        end 
        return var     
         
    end  
    def self.most_adap  #breed with rating == 5 
        @@all.each do |a|              
            if a.adaptability == 5
                puts "   #{a.name}"
            end                  
        end      
        puts ""
    end     
    def self.most_healthy  #breed with rating == 1 
        @@all.each do  |a|              
            if a.health_issues == 1
                puts "   #{a.name}"
            end    
        end
    end
end