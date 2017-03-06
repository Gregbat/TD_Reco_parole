function sModif = rogner(s)

% This function returns a signal cropped, in order to get only the useful
% part of the signal. This improves the SNR, so the prediction.


% To get that signal, we take s^2, then we apply a threshold to get a
% number of sample for the beginning and an other number for the end
 

% ---------------------------------------------------------------------  


%Definition of threshold

CONST.SEUIL = 0.03; % Const threshold (empiric choice
CONST.SINUTILE = 10000; % sample from which testing the threshold
CONST.LONGSINMIN = 15000;% min (number of samples)


%Calsulation of max of square of s minus mean(s)

sMoy = s - mean(s);

sCarre = sMoy.*sMoy;

maxSCarre = max(sCarre);

%initialisation of variables corresponding to sample index 

debut = CONST.SINUTILE; 

fin = length(s) - CONST.SINUTILE; 

debutNonTrouve = 1; finNonTrouvee = 1;

% creating a loop 

while(debutNonTrouve)
    
    %while sCarre < threshold, continue

    if (sCarre(debut)/maxSCarre) < CONST.SEUIL

        debut = debut + 1;

    else
 
        debutNonTrouve = 0;

    end
end

while(finNonTrouvee)


    if (((sCarre(fin)/maxSCarre) < CONST.SEUIL) ||((fin - debut) > CONST.LONGSINMIN))

        fin = fin - 1;

    else

        finNonTrouvee = 0;

    end
end


%Return cropped signal


sModif = s(debut:fin);

