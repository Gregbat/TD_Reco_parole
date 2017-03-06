clear
close all;

rep = 'oui-non/';
nomFichier = {};

flist = dir(strcat(rep,'*.wav'));

lpcs = {}; ss = {}; classOuiNon = {}; classOuiNonEstimee = {};

CONST.ORDERLPC = 40;
CONST.RECLPC = 1/3;
CONST.KELEMENTS = 5;

nbFichiers = length(flist);
 
%Calcul des coefficients LPC sur le signal utile


for i = 1:nbFichiers
    
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
    
    %Normalisation de la forme d'onde
    
    sUtile = sUtile/(max(abs(sUtile)));
    
    %Mise en mémoire du signal tronqué
    
    ss{length(nomFichier)} = sUtile;
    
    %Calcul des coefficients lpc sur le signal utile
    
    lpc = calcul_lpc(sUtile,Fe,CONST.ORDERLPC,CONST.RECLPC);
    
    %ajout d'une matrice de coefficients lpc dans la matrice de matrice lpcs
    
    lpcs{length(nomFichier)} = lpc;
    
    
    
end

%Calcul et mise en mémoire de la distance élastique entre chaque fichier 

distanceElast = zeros(length(lpcs));

indexTri = zeros(length(lpcs));

estimCorrecte = 0;
for i = 1: nbFichiers
    
    for j = 1: nbFichiers
    
        distanceElast(i,j) = distance_elastique(lpcs{i},lpcs{j});
        
    end
    
    %Tri des distances
    
    [C I] = sort(distanceElast(i,:));
    
    indexTri(i,:) = I;
    
    %Classification des signaux
    classPrediteSgn = 0;
    
    for k = 2:CONST.KELEMENTS+1
        
        if (classOuiNon{indexTri(i,k)} == 'oui')
            
            classPrediteSgn = classPrediteSgn + 1;
            
        else if (classOuiNon{indexTri(i,k)} == 'non')
                
                classPrediteSgn = classPrediteSgn - 1;
    
            end
        end
    end
        
        %Mémorisation de la prédiction
        
        if classPrediteSgn > 0
            
            classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'oui';
            
        else if classPrediteSgn < 0
                
            classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'non';
            
            else classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'und';
                
            end
        end
        
        %Comparaison avec la vérité
        
        if classOuiNonEstimee{end} == classOuiNon{i}
            
            estimCorrecte = estimCorrecte + 1;
            
        end
            
end

%Calcul du nombre de fenêtres à afficher par ligne (5 max) et par colonne
nLi     = floor(nbFichiers/5)+ (mod(nbFichiers,5)>0);
nCol	= 5;


%affichage des signaux utiles (test de robustesse de la fonction rogner)

fig1 = figure;
set(fig1,{'Name','Outerposition'},{'Formes d onde des signaux utiles',[100, 450, 1000, 400]});

for l = 1:nbFichiers
    
    subplot(nLi,nCol,l);
    
    plot(ss{l});
    
    title(['S_{utile} de ',nomFichier{l}]);
    
end

fig2 = figure;

set(fig2,{'Name','Outerposition'},{'Distances élastiques',[100, 10, 1000, 450]});


%Affichage des distances de chacun des fichiers à chacun des autres 

for k = 1:nbFichiers
    
    subplot(nLi,nCol,k);

    bar(distanceElast(:,k));
    
    title(['Distance de ', nomFichier{k}]);
    
    legend(['Predit : ', classOuiNonEstimee{k}]);
    
end

%affichage du nombre de bonnes prédictions :
OrdreLPCStr = ['Ordre LPC : ', int2str(CONST.ORDERLPC)];
nombreCompStr = ['Nombre de comparaisons : ', int2str(CONST.KELEMENTS)];
recStr = ['Recouvrement : ',int2str(CONST.RECLPC*100),' %'];
nbElementsCorrectsStr = ['Nombre d élements prédits correctement :',int2str(estimCorrecte), '/ ', int2str(nbFichiers)]
 

h = msgbox({'Paramètres : ' OrdreLPCStr nombreCompStr recStr nbElementsCorrectsStr})


