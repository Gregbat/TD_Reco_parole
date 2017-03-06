function contient = contains(nom, chaineTestee)

% Function returning true if chaineTestee is in nom, otherwise false
 
i = 1;
contient = 0;

while ((i <= length(nom)-length(chaineTestee)+1) && (contient == 0))
   
        if (nom(i:i+length(chaineTestee)-1) == chaineTestee)
            
            contient = 1;
            
        end
 

    i = i + 1;
    
end

