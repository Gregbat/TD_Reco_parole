function contient = contains(nom, chaineTestee)

% Fonction renvoyant vrai si chaineTestee est dans nom, faux sinon
 
i = 1;
contient = 0;

while ((i <= length(nom)-length(chaineTestee)+1) && (contient == 0))
   
        if (nom(i:i+length(chaineTestee)-1) == chaineTestee)
            
            contient = 1;
            
        end
 

    i = i + 1;
    
end

