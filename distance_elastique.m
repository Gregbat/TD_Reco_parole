function D = distance_elastique(u1, u2)

%return distance between two series of vectors


%pondering Coefficients

wi = 1;

wd = 1;

ws = 1;


[N, L1] = size(u1); %L1 temporal windows,  LPC order : N

[N, L2] = size(u2); 

d = zeros(L1, L2); % future matrix (scalar product of vectors)

g = zeros(L1, L2); %future matrice (lenght of the way)

%calculation of g(1,1)

d(1,1) = sqrt(transpose(u1(:,1)-u2(:,1))*(u1(:,1)-u2(:,1)));

g(1,1) = d(1,1);

% First line

for j = 2: L2
    
    d(1,j) = sqrt(transpose(u1(:,1)-u2(:,j))*(u1(:,1)-u2(:,j)));
    
    g(1,j) = g(1,j-1) + wi * d(1,j);
    
end

% First Column

for i = 2:L1
    
    d(i,1) = sqrt(transpose(u1(:,i)-u2(:,1))*(u1(:,i)-u2(:,1)));
    
    g(i,1) = g(i - 1,1) + wd * d(i,1);

    
end

%general case

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





        