clear
close all;

rep = 'oui-non/';
nomFichier = {};

flist = dir(strcat(rep,'*.wav'));

lpcs = {}; ss = {}; classOuiNon = {}; classOuiNonEstimee = {};


 
%Calculation of LPC coefficients of the interesting part of the signal


for i = 1:length(flist)
    
    n = flist(i).name;

    nomFichier{length(nomFichier) + 1} = n;
    
    %if the file name is 'oui' ('non'), then class is 'oui' ('non') 
    % otherwise -> undefined
    
    if (contains(n, 'non'))
        
        classOuiNon{length(nomFichier)} = 'non';
        
    else if (contains(n, 'oui'))
            
            classOuiNon{length(nomFichier)} = 'oui';
            
        else classOuiNon{length(nomFichier)} = 'und';
            
        end
   
    end
            
    
    [s Fe nbits] = wavread(strcat(rep,n));
    
    s = s(:,1);
    
    %Let's crop the signal to get only the useful part
    
    sUtile = rogner(s);
    
    %put this signal in  list
    
    ss{length(nomFichier)} = sUtile;
    
    %Calculation of LPC coefficients lpc on cropped signal 
    
    lpc = calcul_lpc(sUtile,Fe);
    
    %add LPC coefficients in lpcs matrix 
    
    lpcs{length(nomFichier)} = lpc;
    
    
    
end

%Calculation and record of 'elastical distance' between each file

distanceElast = zeros(length(lpcs));

indexTri = zeros(length(lpcs));

estimCorrecte = 0;
for i = 1: length(lpcs)
    
    for j = 1: length(lpcs)  
    
        distanceElast(i,j) = distance_elastique(lpcs{i},lpcs{j});
        
    end
    
    %sort
    
    [C I] = sort(distanceElast(i,:));
    
    indexTri(i,:) = I;
    
    %Classification of signals
    classPredite = 0; kElements = 5;
    
    for k = 2:kElements+1
        
        if (classOuiNon{indexTri(i,k)} == 'oui')
            
            classPredite = classPredite + 1;
            
        else if (classOuiNon{indexTri(i,k)} == 'non')
                
                classPredite = classPredite - 1;
    
            end
        end
    end
        
        %Memorisation of prediction
        
        if classPredite > 0
            
            classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'oui';
            
        else if classPredite < 0
                
            classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'non';
            
            else classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'und';
                
            end
        end
        
        %Comparison with truth
        
        if classOuiNonEstimee{end} == classOuiNon{i}
            
            estimCorrecte = estimCorrecte + 1;
            
        end
            
end


% plot cropped signal (test of robustness of 'rogner' function )


for l = 1:length(flist)
    
    subplot(5,5,l);
    
    plot(ss{l});
    
    title(['S_{utile} de ',nomFichier{l}]);
    
end

figure;

% plot distances from files to each other

for k = 1:length(flist)
    
    subplot(5,5,k);

    bar(distanceElast(:,k));
    
    title(['Distance de ', nomFichier{k}]);
    
    legend(['Predit : ', classOuiNonEstimee{k}]);
    
end
 


