clear
close all;

rep = 'oui-non/';
nomFichier = {};

flist = dir(strcat(rep,'*.wav'));

lpcs = {}; ss = {}; classOuiNon = {};
 
%Calcul des coefficients LPC sur le signal utile


for i = 1:length(flist)
    
    n = flist(i).name;

    nomFichier{length(nomFichier) + 1} = n;
    
    %Si le nom du fichier contient 'non', la classe est 'non' et
    %pareil avec 'oui' 
    
    if (contains(n, 'non'))
        
        classOuiNon{length(nomFichier)} = 'non';
        
    else if (contains(n, 'oui'))
            
            classOuiNon{length(nomFichier)} = 'oui';
            
        else classOuiNon{length(nomFichier)} = 'undefined';
            
        end
   
    end
            
    
    [s Fe nbits] = wavread(strcat(rep,n));
    
    s = s(:,1);
    
    %Troncage du signal pour ne conserver que la partie utile
    
    sUtile = rogner(s);
    
    %Mise en mémoire du signal tronqué
    
    ss{length(nomFichier)} = sUtile;
    
    %Calcul des coefficients lpc sur le signal utile
    
    lpc = calcul_lpc(sUtile,Fe);
    
    %ajout d'une colonne de coefficients lpc dans la matrice lpcs
    
    lpcs{length(nomFichier)} = lpc;
    
    
    
end

%Calcul et mise en mémoire de la distance élastique entre chaque fichier 

distanceElast = zeros(length(lpcs));

indexTri = zeros(length(lpcs));


for i = 1: length(lpcs)
    
    for j = 1: length(lpcs)  
    
        distanceElast(i,j) = distance_elastique(lpcs{i},lpcs{j});
        
    end
    
    %Tri des distances
    
    [C I] = sort(distanceElast(i,:));
    
    indexTri(i,:) = I;
    
end

% 
% %Classification des signaux
% 
% for k = 1:length(flist)
%    
%     
%     
% end


%affichage des signaux utiles (test de robustesse de la fonction rogner)


for l = 1:length(flist)
    
    subplot(5,5,l);
    
    plot(ss{l});
    
    title(['S_{utile} de ',nomFichier{l}]);
    
end

figure;

%Affichage des distances de chacun des fichiers à chacun des autres 

for k = 1:length(flist)
    
    subplot(5,5,k);

    bar(distanceElast(:,k));
    
    title(['Distance de ', nomFichier{k}]);
    
end
 


