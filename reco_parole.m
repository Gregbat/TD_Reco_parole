clear
close all;

rep = 'oui-non/';
nonFichier = {};

flist = dir(strcat(rep,'*.wav'));

lpcs = {}; ss = {};
 
%Calcul des coefficients LPC sur le signal utile


for i = 1:length(flist)
    
    n = flist(i).name;

    nonFichier{length(nonFichier) + 1} = n;
    
    [s Fe nbits] = wavread(strcat(rep,n));
    
    s = s(:,1);
    
    sModif = rogner(s);
    
    ss{length(nonFichier)} = sModif; 
    
    lpc = calcul_lpc(sModif,Fe);
    
    lpcs{length(nonFichier)} = lpc;
    
end

%Calcul et mise en mémoire de la distance élastique entre chaque fichier 

D = zeros(length(lpcs));

indexTri = zeros(length(lpcs));


for i = 1: length(lpcs)
    
    for j = 1: length(lpcs)  
    
        D(i,j) = distance_elastique(lpcs{i},lpcs{j});
        
    end
    
    %Tri des distances
    
    [C I] = sort(D(i,:));
    
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
    
    title(['S_{utile} de ',nonFichier{l}]);
    
end

figure;

%Affichage des distances de chacun des fichiers à chacun des autres 

for k = 1:length(flist)
    
    subplot(5,5,k);

    bar(D(:,k));
    
    title(['Distance de ', nonFichier{k}]);
    
end
 


