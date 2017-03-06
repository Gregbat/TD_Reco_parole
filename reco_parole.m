%% This Program takes in input wave files and tries to predict whether it is a 'oui' or a 'non' which is pronounced

 

%%Declaration of variables

clear
close all;

rep = 'oui-non/';
nomFichier = {};

flist = dir(strcat(rep,'*.wav'));

lpcs = {}; ss = {}; classOuiNon = {}; classOuiNonEstimee = {};

CONST.ORDERLPC = 40; %system order
CONST.RECLPC = 1/3; % Recouvrement
CONST.KELEMENTS = 5; %Classification : k -elements

nbFichiers = length(flist);
 
%Calculation of LPC coefficients of the interesting part of the signal


for i = 1:nbFichiers
    
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
    
 
    %Normalization of sUtile
    
    sUtile = sUtile/(max(abs(sUtile)));
 
    %put this signal in  list
 
    ss{length(nomFichier)} = sUtile;
    
    %Calculation of LPC coefficients lpc on cropped signal 
    
    lpc = calcul_lpc(sUtile,Fe,CONST.ORDERLPC,CONST.RECLPC);
 
    %add LPC coefficients in lpcs matrix 
 
    
    lpcs{length(nomFichier)} = lpc;
    
    
    
end

%Calculation and record of 'elastical distance' between each file

distanceElast = zeros(length(lpcs));

indexTri = zeros(length(lpcs));

estimCorrecte = 0;
for i = 1: nbFichiers
    
    for j = 1: nbFichiers
    
        distanceElast(i,j) = distance_elastique(lpcs{i},lpcs{j});
        
    end
    
    %sort
    
    [C I] = sort(distanceElast(i,:));
    
    indexTri(i,:) = I;
    
 
    classPrediteSgn = 0;
 
    %Classification of signals
    classPredite = 0; kElements = 5;
 
    for k = 2:CONST.KELEMENTS+1
        
        if (classOuiNon{indexTri(i,k)} == 'oui')
            
            classPrediteSgn = classPrediteSgn + 1;
            
        else if (classOuiNon{indexTri(i,k)} == 'non')
                
                classPrediteSgn = classPrediteSgn - 1;
    
            end
        end
    end
        
        %Memorisation of prediction
        
        if classPrediteSgn > 0
            
            classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'oui';
            
        else if classPrediteSgn < 0
                
            classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'non';
            
            else classOuiNonEstimee{length(classOuiNonEstimee) + 1 } = 'und';
                
            end
        end
        
        %Comparison with truth
        
        if classOuiNonEstimee{end} == classOuiNon{i}
            
            estimCorrecte = estimCorrecte + 1;
            
        end
            
end

%Plotting aspects (max. 5 window a line)
nLi     = floor(nbFichiers/5)+ (mod(nbFichiers,5)>0);
nCol	= 5;


% plot cropped signal (test of robustness of 'rogner' function )

fig1 = figure;
set(fig1,{'Name','Outerposition'},{'Formes d onde des signaux utiles',[100, 450, 1000, 400]});

for l = 1:nbFichiers
    
    subplot(nLi,nCol,l);
    
    plot(ss{l});
    
    title(['S_{utile} de ',nomFichier{l}]);
    
end

fig2 = figure;

set(fig2,{'Name','Outerposition'},{'Distances �lastiques',[100, 10, 1000, 450]});


% plot distances from files to each other

for k = 1:nbFichiers
    
    subplot(nLi,nCol,k);

    bar(distanceElast(:,k));
    
    title(['Distance from ', nomFichier{k}]);
    
    legend(['Predicted : ', classOuiNonEstimee{k}]);
    
end

%plotting the predictions:
OrdreLPCStr = ['LPC Order : ', int2str(CONST.ORDERLPC)];
nombreCompStr = ['Number of comparisons : ', int2str(CONST.KELEMENTS)];
recStr = ['Recouvrement : ',int2str(CONST.RECLPC*100),' %'];
nbElementsCorrectsStr = ['Number of correct predictions :',int2str(estimCorrecte), '/ ', int2str(nbFichiers)]
 

h = msgbox({'Parameters : ' OrdreLPCStr nombreCompStr recStr nbElementsCorrectsStr})


