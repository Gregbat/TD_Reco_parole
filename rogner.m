function sModif = rogner(s)

% Cette fonction a pour objectif de rogner le signal de manière à ne 
%conserver que le signal utile


% Pour ce faire, on balaye le signal au carré (proportionnel à l'énergie)
% du début en établissant à chaque nouvel échantillon

% ---------------------------------------------------------------------  


%Définition du rapport limite

CONST.SEUIL = 0.03; % Constante seuil choisie empiriquement 
CONST.SINUTILE = 10000; % nb d'échantillons à partir d'où faire le balayage

%On calcule le signal Carré du signal moins sa moyenne, récupère le max

sMoy = s - mean(s);

sCarre = sMoy.*sMoy;

maxSCarre = max(sCarre);

%initialisation des variables d'échantillon du début et de la fin du signal
%utile (

debut = CONST.SINUTILE; 

fin = length(s) - CONST.SINUTILE; 

debutNonTrouve = 1; finNonTrouvee = 1;

% On crée une boucle simulant le balayage du signal 

while(debutNonTrouve)
    
    %Tant que le signal au carre ne dépasse pas un certain seuil, on
    %continue de balayer le signal

    if (sCarre(debut)/maxSCarre) < CONST.SEUIL

        debut = debut + 1;

    else
 
        debutNonTrouve = 0;

    end
end

while(finNonTrouvee)


    if (((sCarre(fin)/maxSCarre) < CONST.SEUIL) ||((fin - debut) > 15000))

        fin = fin - 1;

    else

        finNonTrouvee = 0;

    end
end


%Retourner la valeur rognée


sModif = s(debut:fin);

