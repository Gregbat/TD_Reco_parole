function lpc = calcul_lpc(s, Fe, N, rec)

% This function returns LPC coefficients of a signal s sampled with the frequency Fe.
%
% LPCs are defined like : s(t(i)) = a1*t(i-1) + a2*t(i-2) + ... + an*t(i-n)

% For each small window of s, we calculate the autocovariance functions R(i) = R(i) = E(s(t)s(t+i))
%
% Once we have correlation matrix R, we know that R*A = sigma2 * (1; 0 ... 0)), with A = (1; a1; a2; ... ; an) 
%
% Then we find A.

% ---------------------------------------------------------------------  


Ns = length(s);

Nechantillon = floor(0.02*Fe);% window lenght

% window offset ('recouvrement')
offset = floor(Nechantillon*rec); 

Nfenetre = floor(Ns/offset)-floor(1/rec);   % number of windows (minus the three last ones 
                                            % to avoid index overcharging)

                                            
lpc = zeros(N,Nfenetre);


vecteurInv = zeros(N+1,1); 

vecteurInv(1) = 1; % vector used for the equation R*A = sigma2 * (1; 0 ... 0)) 

for fen = 1: Nfenetre % For each  window
    
    % definition of the portion of s which interests us, then
    % multiplication with hamming window :
    
    debEchantillon = (fen - 1) * offset;
    
    f = hamming(Nechantillon).*s(debEchantillon + 1 : debEchantillon + Nechantillon);
    

    %Calculation of autocovariance functions R(i) = E(s(t)s(t+i))
    
    % Smat(i,j) = f(t+i+j) if t+i+j < tmax
    % We get the unnormalized R(i) by multiplicating 
     

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

    Ri = Ri./Nechantillon; % R(i)
    
    
    % Creation of R matrix

    R = zeros(N+1);

    for diago = 0:N


        R = R + diag(Ri(diago+1).*ones(N + 1 - diago, 1), diago );

        if diago > 0 

            R = R + diag(Ri(diago+1).*ones(N + 1 - diago, 1), - diago);
        end

    end
    
    
    % Calculation of LPC coefficients from R matrix
 

    lpci = R\vecteurInv;
    
    lpci = lpci./(lpci(1));
    
    lpci = lpci(2:end);
    
    
    %add the new lpc coefficents vector in lpc matrix
    
    lpc(:,fen) = lpci;
    
    
end


