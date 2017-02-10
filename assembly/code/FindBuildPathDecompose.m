function [foundPath, sequence, dirs, partColoredArray]=FindBuildPathDecompose(partXY)
% Given a polyomino part, searches for a valid build path described by
% order sequence and move direcions dirs.
% Finds the build path by iteratively removing tiles.
%Decomposition : Worst case is 1/2 n (1 + n), best base is n
% Composition Worst case is n!, best case is n
% returns foundPath == true if a path is found, false else.
%Initialize a part with yx
% positions Passes the part and start node to Depth_firstsearch function to
% find possible sequence of joining the items The output is then passed to
% CheckPath function to check if the item can join the assembly from
% l,r,u,d direction
%
%Authors: Sheryl Manzoor, smanzoor2@uh.edu and Aaron T. Becker, atbecker@uh.edu, Sep 27, 2016
clc
format compact
if nargin <1
    partXY = TestFindBuildPath();
    % partXY=BigPartTry();
    % partXY = [5 3;4 3;4 2;3 2;2 2;1 2];
end
% Returned variables
foundPath = false;  % no valid path has been found yet
sequence = zeros(size(partXY));  % the order to build the part (computed in reverse )
dirs = char(zeros(1,size(partXY,1)-1));      % the directions to compose the part 

remPartXY = partXY;  % iterate until remaining is zero length
% color the part
IND = sub2ind(max(partXY),partXY(:,1),partXY(:,2));
partAr = zeros(max(partXY));
partAr(IND) = 1;
partColoredArray = labelColor(partAr); %label color to each item in part
dirs2 = ['d';'l';'u';'r'];

while size(remPartXY,1) > 1
    successfulRemove = false;
    for m = 1:size(remPartXY,1)%check each remaining tile to find a removeable one
        startPart = remPartXY(m,:);%try removing each particle
        restXY = [remPartXY(1:m-1,:);remPartXY(m+1:end,:)];
        partAr(startPart(1),startPart(2)) = 0; % remove this tile from BW array
        for j=1:4 %try taking this particle out in all 4 directions
            moveOK = CheckPath1Tile(partAr,startPart,dirs2(j),partColoredArray);
            % find a particle that can be successfully removed
            if moveOK
                n = bwconncomp(partAr,4); %TODO: SLOWEST PART OF ALGORITHM
                if n.NumObjects == 1  %ensure it does not generate 2 components
                    % remove the particle from remPartXY, and add it to revSequence & revDirs
                    remPartXY = restXY;
                    sequence(size(remPartXY,1)+1,:) = startPart; %store removal order in reverse
                    dirs(size(remPartXY,1)) = dirs2(j);%store directions in reverse
                    successfulRemove = true;
                    if size(remPartXY,1) == 1
                        foundPath = true;
                        sequence(1,:) = remPartXY;
                    end
                    break %exit FOR loop
                end %endif
            end %end if
        end %endfor (try moving in each direction)
        if ~successfulRemove
            partAr(startPart(1),startPart(2)) = 1; % replace this tile
        else
            break
        end
    end %endfor (try removing each existing tile until you can remove one)
    if successfulRemove == false
        display('no way to remove a particle, ==> there is no solution')
        break 
    end
end  %endwhile (repeat until all tiles removed)

%%% Draw the polyomino
G.fig = figure(51);clf;
set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY,1)),' tiles'])
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    1,0,0;
    0,0,1];
colormap(G.colormap);
set(gca,'Ydir','reverse');
axis equal
axis([ min(partXY(:,2))-2,max(partXY(:,2))+2,min(partXY(:,1))-2,max(partXY(:,1))+2])

if foundPath
    for k = 1:size(partXY,1)
        x = sequence(k,1);
        y = sequence(k,2);
        clr = partColoredArray(x,y);
        rectangle('Position',[y-1/2,x-1/2,1,1],...
            'FaceColor',G.colormap(clr+2,:),'linewidth',1);
        if k > 1
            ht = text(y,x,[num2str(k),textarrow( dirs(k-1) )],'HorizontalAlignment','center');
        else
            ht = text(y,x,num2str(k) ,'HorizontalAlignment','center');
        end
        set(ht, 'color','k')
    end
else
    text(1/2*(max(partXY(:,2))-min(partXY(:,2))),1/2*(max(partXY(:,1))-min(partXY(:,1))), 'No path found')
end
end

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




