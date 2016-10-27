function [foundPath, sequence, dirs]=FindBuildPath(partXY)
% Given a polyomino part, searches for a valid build path described by
% order sequence and move direcions dirs.
% returns foundPath == true if a path is found, false else.
%Initialize a part with yx
% positions Passes the part and start node to Depth_firstsearch function to
% find possible sequence of joining the items The output is then passed to
% CheckPath function to check if the item can join the assembly from
% l,r,u,d direction 
%
%Authors: Sheryl Manzoor, smanzoor2@uh.edu and Aaron T. Becker, atbecker@uh.edu, Sep 27, 2016

clc
%clear all

format compact
if nargin <1  
% partXY= TestDepthFirstSearch();
% partXY=BigPartTry();
partXY = [5 3;4 3;4 2;3 2;2 2;1 2];
end

% Returned variables
foundPath = 'false';  % no valid path has been found yet  
sequence = [];
dirs = [];


for m=1:size(partXY,1) % try all possible start nodes until we get a path that  
    Start = partXY(m,:);
    [Output,Seq,Tmppart] = DepthFirstSearch(partXY,Start); %depth first search on part
    partColored = labelColor(Tmppart(:,:,1)); %label color to each item in part
    partialAssembly = zeros(size(Tmppart(:,:,1),1),size(Tmppart(:,:,1),2));
    partialAssembly(Output(1,1),Output(1,2)) = 1;

   
    dirsFinal= size(partXY,1)-1; %Array saves the directions of the items
    dirsFinal = char(dirsFinal);
    dirs2 = ['l';'r';'u';'d'];
    for i=2:size(Output,1) 
        for j=1:4
            move = CheckPath1Tile(partialAssembly,Output(i,:),dirs2(j,:),partColored);  
            if strcmp(move,'true')
               partialAssembly(Output(i,1),Output(i,2)) = 1;
               dirsFinal(i-1,:) = num2str(dirs2(j,:));
               break;
            end
        end
        if strcmp(move,'false')
            break;
        end

        if strcmp(move,'true') && i==size(Output,1)  
           foundPath=true; 
        end
    end
    
    if foundPath==true
       sequence = Output;
       dirs = dirsFinal;
       break; 
    end

end



    tmpAssembly = partialAssembly.*partColored;  
    G.fig = figure;
    set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY,1)),' tiles'])   
    G.colormap = [  1,1,1; %Empty = white  
        0,0,0; %obstacle
        hsv(numel(unique(tmpAssembly))-1);];
    colormap(G.colormap);
    G.axis=imagesc(tmpAssembly); 
    axis equal
    for k = 1:i
        s = Seq(k);
        ht = text(Output(k,2),Output(k,1),num2str(s));
        set(ht, 'color','k')
    end
end





