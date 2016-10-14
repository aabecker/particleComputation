function [foundPath, sequenceXY, dirs,partColoredArr]=FindBuildPath(partXY)
% Given a polyomino part, searches for a valid build path described by
% order sequence and move direcions dirs.
% returns foundPath == true if a path is found, false else.
%Initialize a part with yx
% positions Passes the part and start node to Depth_firstsearch function to
% find possible sequence of joining the items The output is then passed to
% CheckPath function to check if the item can join the assembly from
% l,r,u,d direction 
% 
% Input:  TODO
%
%  Output: TODO  (must ensure partColored is useable by BuildFactory)
%
%Authors: Sheryl Manzoor and Aaron T. Becker, Sep 27, 2016

clc
%clear all

% GOAL FOR 10/14/2016: figure 4.2 left  in bachelor thesis, find a valid build order!
format compact
if nargin <1
% partXY = [1 2 ;2 2 ;3 2 ;4 3 ;5 3 ;4 2 ]; %contains the item positions for the Part
% partXY=[7 6;
%       9 6;
%       6 7;
%       7 7;
%       8 7;
%       9 7;
%       10 7;
%       7 8;
%       9 8;
%       6 9;
%       7 9;
%       8 9;
%       9 9;
%       10 9;
%       7 10;
%       9 10];
 
% partXY=[4 2;
%       5 2; % Spiral part inner node [5 5]
%       6 2
%       7 2;
%       8 2;
%       8 3;
%       8 4;
%       8 5;
%       8 6;
%       8 7;
%       7 7;
%       6 7;
%       5 7;
%       4 7;
%       4 3;
%       4 4;
%       4 5;
%       5 5];
  
% partXY=[5,2;6,2;7,2;8,2;9,2;10,2;5,3;5,4;6,4;7,4;8,4;9,4;10,4;5,5;10,5;5,6;7,6;8,6;10,6;5,7;7,7;10,7;5,8;7,8;
%         8,8;9,8;10,8;10,9;10,10;10,11;10,12;9,10;9,12;8,10;8,12;7,10;7,12;6,10;6,12;5,10;5,11;5,12];
end

% Returned variables
foundPath = false;  % no valid path has been found yet
sequenceXY = [];
dirs = [];


for m=1:size(partXY,1)
    % try all possible start nodes until we get a path that works
    start = partXY(m,:);

    [output,seq,tmp_part] = Depth_firstsearch(partXY,start); %depth first search on part
    partColoredArr = labelColor(tmp_part(:,:,1)); %label color to each item in part
    partialAssembly = zeros(size(tmp_part(:,:,1),1),size(tmp_part(:,:,1),2));
    partialAssembly(output(1,1),output(1,2)) = 1;

    dirs_final= size(partXY,1)-1; %Array saves the directions of the items
    dirs_final = char(dirs_final);
    dirs2 = ['l';'r';'u';'d'];
    for i=2:size(output,1)
        for j=1:4
            %move = CheckPath(partialAssembly,output(i,:),dirs2(j,:),partColored);
            move = CheckPath1Tile(partialAssembly,output(i,:),dirs2(j,:),partColoredArr); 
            if strcmp(move,'true')
               partialAssembly(output(i,1),output(i,2)) = 1;
               dirs_final(i-1,:) = num2str(dirs2(j,:));
               break;
            end
        end
        if strcmp(move,'false')
            break;
        end

        if strcmp(move,'true') && i==size(output,1)  
           foundPath=true; 
        end
    end
    
    if foundPath==true
       sequenceXY = output;
       dirs = dirs_final;
       break; 
    end
    % clears memory
    clear output seq tmp_part partColored partialAssembly dirs_final;

end
% draw part
    tmpAssembly = flipud(partialAssembly.*partColoredArr);  
    G.fig = figure;
    set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY,1)),' tiles'])
    G.colormap = [  1,1,1; %Empty = white
        0,0,0; %obstacle
        hsv(numel(unique(tmpAssembly))-1);];
    colormap(G.colormap);
    G.axis=imagesc(tmpAssembly);
    axis equal
    for k = 1:i
        s = seq(k);
        ht = text(output(k,2),1+size(partialAssembly,1)-output(k,1),num2str(s));
        set(ht, 'color','k')
    end
end





