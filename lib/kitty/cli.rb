class CatBreeds::CLI

     

     def call  
        header       
        call_websites
        menu
        
        
        
     end  
     def header
          puts <<-DOC
    ***************************************************************************************
    ***************************************************************************************
    *                                                                                     *
    *                       .............                .""".             .""".          *
    *               ..."""""             """""...       $   . ".         ." .   $         *
    *           ..""        .   .   .   .   .    ..    $   $$$. ". ... ." .$$$   $        *
    *         ."    . " . " . " . " . " . " . " .  "" ."  $$$"""  "   "  """$$$  ".       *
    *       ."      . " . " . " . " . " . " . " .     $  "                    "   $       *
    *      ."   . " . " . "           "   " . " . "  ."      ...          ...     ".      *
    *     ."    . " . "    .."""""""""...     " . "  $     .$"              "$.    $      *
    *    ."     . " . " .""     .   .    ""..   . " $ ".      .""$     .""$      ." $     *
    *   ."    " . " .       . " . " . " .    $    " $ "      "  $$    "  $$       " $     *
    *   $     " . " . " . " . " . " . " . "   $     $             $$.$$             $     *
    *   $     " . " . " . " . " . " . " . " .  $  " $  " .        $$$$$        . "  $     *
    *   $     " . " . " . " . " . " . " . " .  $    $      "  ..   "$"   ..  "      $     *
    *   ".    " . " . " . " . " . " . " . "   ."  "  $  . . . $  . .". .  $ . . .  $      *
    *    $    " . " . " . " . " . " . " . "  ."   "            ".."   ".."                *
    *     $     . " . " . " . " . " . "   .."   . " . "..    "             "    .."       *
    *     ".      " . " . " . " . " .  .""    " . " .    """$...         ...$"""          *
    *      ". "..     " . " . " . " .  "........  "    .....  ."""....."""                *
    *        ". ."$".....                       $..."$"$"."   $".$"... `":....            *
    *          "".."    $"$"$"$"""$........$"$"$"  ."."."  ...""      ."".    `"".        *
    *              """.$.$." ."  ."."."    ."."." $.$.$"""".......  ". ". $ ". ". $       *
    *                     """.$.$.$.$.....$.$.""""               ""..$..$."..$..$."       *
    *                                                                                     *
    ***************************************************************************************
    *************************************** WELCOME ***************************************
    ***************************************************************************************    
         DOC
     end 

     def call_websites
         scraper = CatBreeds::Scraper.new    
         scraper.make_breeds  #generate list of breeds, can be also call through a class method. 
        
     end
     
     def menu 
         puts ""
         puts "   Select a number option"
         puts "   1. Check kitties Breeds"
         puts "   2. Search a breed by name."
         puts "   3. List of most adaptable breeds"
         puts "   4. List of most healthy breeds"
         puts "   5. Say goodbye kittens.(Exit)"
         input = gets.strip.to_i
          
         until input.between?(1,5)   
                puts ""  
                puts "   Bad Kitty!. Choose a correct option."
                puts ""
                puts ""
                menu            
         end

         case input
         when 1

             i = 0  
             puts ""
             puts ""    
             CatBreeds::Breed.all.each do |b|
                i += 1
                puts "#{i}. #{b.name}"             
             end

             choose_kitty_number
             input = gets.chomp.to_i 
             until input.between?(1,50)   
                puts ""   
                puts "   Bad Kitty!. Choose a correct option."
                puts ""
                puts ""
                input = gets.chomp.to_i         
             end
             second_level_list(input) 


          when 2   
    
            puts ""
            puts "   Enter the first letter of the name"
            str = gets.chomp     
            if CatBreeds::Breed.search_breed_by_name(str)               
                  choose_kitty_number 
                  second_level_list(gets.chomp.to_i)
            else
                puts ""
                puts "   Sorry, no kitty breed with that letter."
                puts ""
                menu
            end    
           
            
          when 3
            CatBreeds::Scraper.make_profile
            CatBreeds::Breed.most_adap           
            menu

          when 4
            
            CatBreeds::Scraper.make_profile
            CatBreeds::Breed.most_healthy
       
            # puts "   Type b for go back to the menu"
            # str = gets.chomp
            # validate_input(str)
            menu

          else

            exit            
          end
          
     end    
     def second_level_list(input)  
              
            kitty_charac_exist?(input)  #generate the kitty profile if it doesn't exits

            i = input.to_i-1
            puts "   Breed name: #{CatBreeds::Breed.all[i].name}"
            puts "   Characteristics:"
            CatBreeds::Breed.reference.each { |r0,r1|  
                      puts "----------------------------------------------------------------------------------------------------------------"         
                      puts "   #{r0}:"
                      puts "   #{r1}"
                      puts "   Rating: #{CatBreeds::Breed.all[i].send(r0.downcase.tr(" ","_"))}"    
                      puts "----------------------------------------------------------------------------------------------------------------" 
                       
            }
            
            # puts ("   Type b for go back to the menu.")
            # str = gets.chomp 
            # validate_input(str)   
            menu  
     end    
     # CLI messages. Refactoring repeat code.
     def choose_kitty_number

            puts ""
            puts "   Choose the number of breed you want to learn:"
            puts ""

     end   
     def validate_input(str)  
           
            until str == "b"  
                puts("")   
                puts "   Bad Kitty!. Choose a correct option." 
                puts "   Type b for go back to the menu"
                str = gets.chomp         
            end

     end
     def kitty_charac_exist?(input)   #enter an especific kitty Breed number
         i = input.to_i-1
         if CatBreeds::Breed.method_defined? :adaptability  #Exist at least one kitty breed in the collection? Method is dinamically created with first element
            if CatBreeds::Breed.all[i].adaptability != nil   #yes. Is the kitty I want in the class collection. Don't create.
              
               return true

            else
             CatBreeds::Scraper.make_profile(CatBreeds::Breed.all[i])   #Characteristics are not empty for some kitty breed but yes for this one.
            end
         else
             CatBreeds::Scraper.make_profile(CatBreeds::Breed.all[i])     #Characteristic is empty for all kitties, create only this kitty breed characteristic.
         end        
     end    

end