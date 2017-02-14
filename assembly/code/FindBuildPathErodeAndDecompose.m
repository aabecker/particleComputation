function [foundPath, sequence, dirs, partColoredArray,partXY]=FindBuildPathErodeAndDecompose(partXY)
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
%     partXY = TestFindBuildPath();
    % partXY=BigPartTry();
    % partXY = [5 3;4 3;4 2;3 2;2 2;1 2];
%      partXY=[5 5;6 5;6 6;6 7;5 7;4 7;3 7;3 6;3 5;3 4;3 3;4 3;5 3;6 3;7 3;8 3;8 4;8 5;8 6;8 7;8 8;8 9;7 9;6 9];%spiral inner node
    partXY=double(coordinates);
end

% color the part
IND = sub2ind(max(partXY),partXY(:,1),partXY(:,2));
partAr = zeros(max(partXY));
partAr(IND) = 1;
%ensure the part has 0 on all sides
partAr = padarray(partAr,[1 1]); %adds zeros on all sides
partColoredArray = labelColor(partAr); %label color to each item in part
[x,y] = find(partAr==1);
partXY = [x,y];
% Call the recursive function
[foundPath, sequence, dirs]=FindBuildPath(partXY,partAr,partColoredArray);

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
if ~foundPath
    sequence = partXY;
end

    for k = 1:size(partXY,1)
        x = sequence(k,1);
        y = sequence(k,2);
        clr = partColoredArray(x,y);
        rectangle('Position',[y-1/2,x-1/2,1,1],...
            'FaceColor',G.colormap(clr+2,:),'linewidth',1);
        if foundPath
        if k > 1
            ht = text(y,x,[num2str(k),textarrow( dirs(k-1) )],'HorizontalAlignment','center');
        else
            ht = text(y,x,num2str(k) ,'HorizontalAlignment','center');
        end
        set(ht, 'color','k')
        end
    end
if ~foundPath
    text(1/2*(max(partXY(:,2))-min(partXY(:,2))),1/2*(max(partXY(:,1))-min(partXY(:,1))), 'No path found')
end
end

function [remPartXY,partAr,sequence, dirs,foundPath,loops]=ErodePoly(remPartXY,partAr,partColoredArray)
sequence = zeros(size(remPartXY));  % the order to build the part (computed in reverse )
dirs = char(zeros(1,size(remPartXY,1)-1));      % the directions to compose the part
foundPath = false;
loops = false;
dirs2 = ['d';'l';'u';'r'];
p = bwconncomp(1-partAr,8); %the number of white connected components
initwhiteObj = p.NumObjects;
while size(remPartXY,1) > 1
    successfulRemove = false;
    for m = 1:size(remPartXY,1)%check each remaining tile to find a removeable one
        startPart = remPartXY(m,:);%try removing each particle
        restXY = [remPartXY(1:m-1,:);remPartXY(m+1:end,:)];
        partAr(startPart(1),startPart(2)) = 0; % remove this tile from BW array
        for j=1:4 %try taking this particle out in all 4 directions
            % find a particle that can be successfully removed
            if CheckPath1Tile(partAr,startPart,dirs2(j),partColoredArray)
                n = bwconncomp(partAr,4); %TODO: SLOWEST PART OF ALGORITHM
                if n.NumObjects == 1
                    p = bwconncomp(1-partAr,8); %the number of white connected components
                    if p.NumObjects ~= initwhiteObj
                        loops = true;
                    else
                        %ensure it does not generate 2 components & no loops are broken
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
                    end
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
        display(['no way to remove tile ==> the shape is eroded, size =',num2str(size(remPartXY,1)), ' loops = ',num2str(loops)])
        break
    end
end  %endwhile (repeat until all tiles removed)


end

function [foundPath, sequence, dirs]=FindBuildPath(partXY,partAr,partColoredArray)
% Returned variables
dirs2 = ['d';'l';'u';'r'];
% call ERODE
[remPartXY,remPartAr,sequence, dirs,foundPath,loops]=ErodePoly(partXY,partAr,partColoredArray);
if foundPath
    return
end
% Else, now only loops remain.  We must break the loops, but order matters.
if loops
    for m = 1:size(remPartXY,1)%check each remaining tile to find a removeable one
        display(['Try removing tile ',num2str(m),' of ',num2str(size(remPartXY,1))] )
        startPart = remPartXY(m,:);%try removing each particle
        restXY = [remPartXY(1:m-1,:);remPartXY(m+1:end,:)];
        remPartAr(startPart(1),startPart(2)) = 0; % remove this tile from BW array
        for j=1:4 %try taking this particle out in all 4 directions
            % find a particle that can be successfully removed
            if CheckPath1Tile(remPartAr,startPart,dirs2(j),partColoredArray);
                n = bwconncomp(remPartAr,4); %TODO: SLOWEST PART OF ALGORITHM
                if n.NumObjects == 1  %ensure it does not generate 2 components
                    % add Tile & dir to revSequence & revDirs
                    sequence(size(restXY,1)+1,:) = startPart; %store removal order in reverse
                    dirs(size(restXY,1)) = dirs2(j);%store directions in reverse
                    [foundPath, sequenceS, dirsS]=FindBuildPath(restXY,remPartAr,partColoredArray);
                    if  foundPath == true
                        sequence(1:size(sequenceS,1),:) = sequenceS;
                        dirs(1:numel(dirsS)) = dirsS;
                        return
                    end
                    break %exit FOR loop
                end %endif
            end %end if
        end %endfor (try moving in each direction)
        remPartAr(startPart(1),startPart(2)) = 1; % replace this tile
    end %endfor (try removing each existing tile until you can remove one)
end
display('no way to remove a tile ==> there is no solution')
end  %endfunction


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




