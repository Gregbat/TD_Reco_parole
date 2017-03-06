function lpc = calcul_lpc(s, Fe, N, rec)

% Cette fonction a pour objectif de calculer et renvoyer les coefficients LPC de chaque
% fenêtre temporelle d'un signal, choisie à partir de Fe. Ordre LPC : N, recouvrement : rec 


% Pour ce faire, On utilise la matrice de covariance, qui, multipliée aux
% coefficients LPC, nous donne un vecteur nul sauf pour sa première ligne
% ou il vaut sigma^2. On récupère les coefficients LPC en inversant la
% matrice R et en la multipliant par (1 0 ... 0)' .

% ---------------------------------------------------------------------  


Ns = length(s);

Nechantillon = floor(0.02*Fe);% Taille de la fenêtre 

% décalage de la fenêtre -> recouvrement
offset = floor(Nechantillon*rec); 

Nfenetre = floor(Ns/offset)-floor(1/rec);  % Nb de fenetres (moins les dernières pour
                                % éviter les dépassements d'index)

lpc = zeros(N,Nfenetre);


vecteurInv = zeros(N+1,1); 

vecteurInv(1) = 1; % vecteur servant à résoudre l'équation R*A = sigma2 * (1; 0 ... 0))

for fen = 1: Nfenetre % Pour chaque fenetre
    
    % On définit la portion de s qui nous intéresse et on la multiplie par
    % une fenêtre de hamming pour éviter les effets de bords :
    
    debEchantillon = (fen - 1) * offset;
    
    f = hamming(Nechantillon).*s(debEchantillon + 1 : debEchantillon + Nechantillon);
    

    %Calcul des fonctions d'autocovariance R(i) = E(s(t)s(t+i))
    
    %On multiplie f par Smat, matrice contenant à la colonne i
    %l'échantillon f(t+i). Cela nous donne un vecteur des R(i) non
    %normalisés

    R = [];
    
    Smat = zeros(Nechantillon,N+1);

    for i = 0:N


        for t = 1:Nechantillon
            
            if (t + i) > Nechantillon
                
                Smat(Nechantillon * i + t) = 0;
            
            else
                
                Smat(Nechantillon * i + t) = f(t + i);
                
            end



        end

    end

    Ri = transpose(f)*Smat; 

    Ri = Ri./Nechantillon; % On trouve les Ri
    
    
    %Creation de la matrice R 

    R = zeros(N+1);

    for diago = 0:N


        R = R + diag(Ri(diago+1).*ones(N + 1 - diago, 1), diago );

        if diago > 0 

            R = R + diag(Ri(diago+1).*ones(N + 1 - diago, 1), - diago);
        end

    end
    
    
    %Calcul des coefficients LPC à partir de la matrice R



    lpci = R\vecteurInv;
    
    lpci = lpci./(lpci(1));
    
    lpci = lpci(2:end);
    
    
    %Rajout du nouveau vecteur coefficient dans la matrice
    
    lpc(:,fen) = lpci;
    
    
end


