


class CatBreeds::Scraper
     attr_accessor :breeds, :webs, :reference, :charac, :name, :web
     URL = "http://www.vetstreet.com"   #Ask Technical coach if BP?

     def make_breeds
       html =  Nokogiri::HTML(open("http://www.vetstreet.com/cats/breeds"))      
       html.css("div.desktop-experience #hub-breed-list-container").children[3].css("a").each do |b|               
                breed =  CatBreeds::Breed.new(b.text)             
                breed.web = URL+b.attribute("href").value 
         end       

    end  
    
    def self.make_profile(breed= nil)   #when breed is nil we upload all Kitties breed characteristics. Otherwise I get only the kitty breed I need.
       
        charac = { }
        if breed != nil
                                    #Kitty characteristics are not created from webprofile.So we need to create them.
                         
                                    html =  Nokogiri::HTML(open(breed.web))
                                  
                                    #GET THE REFERENCE TABLE FOR PRINTING IN CLI- PROCESS ONLY ONE TIME
                                    if CatBreeds::Breed.reference.length == 0
                                    html.css(".desktop-experience table tr td").each do |w|  
                                            
                                                        v = []
                                                        #mental note: the html has an error in one class name, this code correct the error to get the data.
                                                        if w.attribute("class").value == "title" || w.attribute("class").value == "title first"  || w.attribute("class").value == "title "
                                                            v = w.text.delete("\n\t").split("                                                                     ")
                                                            v[1] = v[1].strip                                 
                                                            CatBreeds::Breed.reference <<  v            
                                                        end        
                                                end
                                    end       
                                        
                                    #GET CHARACTERISTIC OF KITTIES AND VALUES TO BUILD INSTANCE ATTRIBUTES. ASSUMPTIONS: ALL THE CHARACTERISTICS HAVE RATING.
                                    html.css(".desktop-experience table tr td.rating").each_with_index do |w , index|
                                                
                                            charac[CatBreeds::Breed.reference[index][0].downcase.tr(" ","_")] = w.text.gsub!(/[a-zA-Z]/,'').strip.to_i  #transform the value in integer
                                    end
                                        
                                    breed.add(charac)   
                                                
                       
        else

                                    #User wants compare caracteristic, I need to upload those that have not been created.
                                    CatBreeds::Breed.all.each do |b| 
                                                        if b.methods.include?("adaptability")   # Some data exist, just complete breed with no profile uploaded.
                                                                  if b.adaptability == nil     
                                                                                        html =  Nokogiri::HTML(open(b.web))
                                                                                            
                                                                                        #GET CHARACTERISTIC OF KITTIES AND VALUES TO BUILD INSTANCE ATTRIBUTES. ASSUMPTIONS: ALL THE CHARACTERISTICS HAVE RATING.
                                                                                        html.css(".desktop-experience table tr td.rating").each_with_index do |w , index|
                                                                                                    
                                                                                                charac[CatBreeds::Breed.reference[index][0].downcase.tr(" ","_")] = w.text.gsub!(/[a-zA-Z]/,'').strip.to_i  #transform the value in integer
                                                                                        end
                                                                                            
                                                                                        b.add(charac)    
                                                                  end                        
                                                       else       
                                                                  #only create them if class collection is empty.
                                                                  html =  Nokogiri::HTML(open(b.web)) 
                                                                  #GET THE REFERENCE TABLE FOR PRINTING IN CLI- PROCESS ONLY ONE TIME
                                                                  if CatBreeds::Breed.reference.length == 0
                                                                           html.css(".desktop-experience table tr td").each do |w|  
                                                                                                
                                                                                                            v = []
                                                                                                            #mental note: the html has an error in one class name, this code correct the error to get the data.
                                                                                                            if w.attribute("class").value == "title" || w.attribute("class").value == "title first"  || w.attribute("class").value == "title "
                                                                                                                v = w.text.delete("\n\t").split("                                                                     ")
                                                                                                                v[1] = v[1].strip                                 
                                                                                                                CatBreeds::Breed.reference <<  v            
                                                                                                            end        
                                                                            end
                                                                 end      


                                                                          
                                                                          #GET CHARACTERISTIC OF KITTIES AND VALUES TO BUILD INSTANCE ATTRIBUTES. ASSUMPTIONS: ALL THE CHARACTERISTICS HAVE RATING.
                                                                          html.css(".desktop-experience table tr td.rating").each_with_index do |w , index|                                                                    
                                                                          charac[CatBreeds::Breed.reference[index][0].downcase.tr(" ","_")] = w.text.gsub!(/[a-zA-Z]/,'').strip.to_i  #transform the value in integer
                                                                          end                                                           
                                                                           b.add(charac)                                                   
                                                               end                     
                                            end      
        end    
     end     
    

end    