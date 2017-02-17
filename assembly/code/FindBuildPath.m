function [foundPath, sequence, dirs, partColoredArray]=FindBuildPath(partXY)
% FINDBUILDPATH, given a polyomino part, searches for a valid build path described by
% order sequence and move direcions dirs.
% returns foundPath == true if a path is found, false else.
% Initialize a part with yx
% positions Passes the part and start node to Depth_firstsearch function to
% find possible sequence of joining the items The output is then passed to
% CheckPath function to check if the item can join the assembly from
% l,r,u,d direction 
% Outputs: sequence of coordinates (sequence), directions from which each
% tile will be added (dirs) and labelled matrix (partColoredArray)
%
%Authors: Sheryl Manzoor, smanzoor2@uh.edu and Aaron T. Becker, atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
%clear all

format compact
if nargin <1  
partXY = [5 3;4 3;4 2;3 2;2 2;1 2];
end

% Returned variables
foundPath = 'false';  % no valid path has been found yet  
sequence = [];
dirs = [];
partColoredArray = [];


    pos = partXY(:,1:2);
    tmpPartt = zeros(max(pos(:,1)),max(pos(:,2))); %create 2D space for 
                                                    %[yx]
    for i=1:size(pos,1)
       tmpPartt(pos(i,1),pos(i,2)) = 1; %save y,x positions of items 
    end

% try all possible start nodes until we get a path that  
for m=1:size(partXY,1)
    Start = partXY(m,:);
    [Output,Seq,Tmppart] = DepthFirstSearch(partXY,Start); %depth first search on part
    partColored = labelColor(Tmppart(:,:,1)); %label color to each item in part
    partialAssembly = zeros(size(Tmppart(:,:,1),1),size(Tmppart(:,:,1),2));
    partialAssembly(Output(1,1),Output(1,2)) = 1;

   
    dirsFinal= size(partXY,1)-1; %Array saves the directions of the items
    dirsFinal = char(dirsFinal);
    dirs2 = ['d';'l';'u';'r'];
    for i=2:size(Output,1) 
        for j=1:4
            move = CheckPath1Tile(partialAssembly,Output(i,:),dirs2(j,:),partColored);  %Check directionn from which tile can be added
            if move
               partialAssembly(Output(i,1),Output(i,2)) = 1;
               dirsFinal(i-1,:) = num2str(dirs2(j,:));
               break;
            end
        end
        if ~move && m~=size(partXY,1)
            clear output seq tmp_part partColored partialAssembly dirs_final;
            break;
        end

        if move && i==size(Output,1)  %If all the moves are true until the loop runs for size of the part then there is a valid path
           foundPath=true; 
        end
    end
    
    if foundPath==true
       sequence = Output;
       dirs = dirsFinal;
       partColoredArray = partColored;
       break; 
    end

end



    

%Display Part with directions
G.fig = figure(50);clf;
set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY,1)),' tiles'])
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    1,0,0;
    0,0,1];
colormap(G.colormap);
set(gca,'Ydir','reverse');
axis equal
axis([ min(partXY(:,2))-2,max(partXY(:,2))+2,min(partXY(:,1))-2,max(partXY(:,1))+2])

for k = 1:i
    s = Seq(k);
    clr = partColoredArray(Output(k,1),Output(k,2));
    rectangle('Position',[Output(k,2)-1/2,Output(k,1)-1/2,1,1],...
        'FaceColor',G.colormap(clr+2,:),'linewidth',1);

    
    if s > 1
    ht = text(Output(k,2),Output(k,1),[num2str(s),textarrow( dirs(s-1) )],'HorizontalAlignment','center');
    else
        ht = text(Output(k,2),Output(k,1),num2str(s) ,'HorizontalAlignment','center');
    end
    set(ht, 'color','k')
end
end

%function for drawing direction arrows on the part
function dirText = textarrow(dir)
if dir == 'd'
    dirText = '\downarrow';
elseif dir == 'u'
    dirText = '\uparrow';
elseif dir == 'r'
    dirText = '\rightarrow';
else
    dirText = '\leftarrow';
end
    
    
end





