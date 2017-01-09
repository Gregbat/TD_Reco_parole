function D = distance_elastique(u1, u2)


%Coefficients pond�rateurs

wi = 1;

wd = 1;

ws = 1;


[N, L1] = size(u1); %L1 fen�tres temporelles, ordre LPC : N

[N, L2] = size(u2); 

d = zeros(L1, L2); % future matrice produit scalaire de vecteurs

g = zeros(L1, L2); %future matrice du chemin parcouru

%calcul de g(1,1)

d(1,1) = sqrt(transpose(u1(:,1)-u2(:,1))*(u1(:,1)-u2(:,1)));

g(1,1) = d(1,1);

%On fait la premiere ligne

for j = 2: L2
    
    d(1,j) = sqrt(transpose(u1(:,1)-u2(:,j))*(u1(:,1)-u2(:,j)));
    
    g(1,j) = g(1,j-1) + wi * d(1,j);
    
end

%On fait la premiere colonne

for i = 2:L1
    
    d(i,1) = sqrt(transpose(u1(:,i)-u2(:,1))*(u1(:,i)-u2(:,1)));
    
    g(i,1) = g(i - 1,1) + wd * d(i,1);

    
end

%Cas g�n�ral

cas = zeros(1,3);

for i = 2: L1
    
    for j = 2:L2
        
        d(i,j) = sqrt(transpose(u1(:,i)-u2(:,j))*(u1(:,i)-u2(:,j)));
        
        cas(1) = abs(g(i,j-1) + wi * d(i,j));
        
        cas(2) = abs(g(i - 1,j) + wd * d(i,j));
        
        cas(3) = abs(g(i - 1,j - 1) + ws * d(i,j));
        
        g(i,j) = min(cas);
        
    end
    
end


D = g(L1, L2)/(L1 + L2);





        