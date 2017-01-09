clear
close all;

rep = 'oui-non/';
nomFichier = {};

flist = dir(strcat(rep,'*.wav'));

lpcs = {}; ss = {}; classOuiNon = {}; classOuiNonEstimee = {};


 
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
            
        else classOuiNon{length(nomFichier)} = 'und';
            
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

estimCorrecte = 0;
for i = 1: length(lpcs)
    
    for j = 1: length(lpcs)  
    
        distanceElast(i,j) = distance_elastique(lpcs{i},lpcs{j});
        
    end
    
    %Tri des distances
    
    [C I] = sort(distanceElast(i,:));
    
    indexTri(i,:) = I;
    
    %Classification des signaux
    classPredite = 0; kElements = 5;
    
    for k = 2:kElements+1
        
        if (classOuiNon{indexTri(i,k)} == 'oui')
            
            classPredite = classPredite + 1;
            
        else if (classOuiNon{indexTri(i,k)} == 'non')
                
                classPredite = classPredite - 1;
    
            end
        end
    end
        
        %Mémorisation de la prédiction
        
        if classPredite > 0
            
            classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'oui';
            
        else if classPredite < 0
                
            classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'non';
            
            else classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'und';
                
            end
        end
        
        %Comparaison avec la vérité
        
        if classOuiNonEstimee{end} == classOuiNon{i}
            
            estimCorrecte = estimCorrecte + 1;
            
        end
            
end


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
    
    legend(['Predit : ', classOuiNonEstimee{k}]);
    
end
 


