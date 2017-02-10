function moveValid = CheckPath1Tile(partialAssembly, loc, direction, partColored)
% CheckPath1Tile
%   Input:
%   - partialAssembly: a binary, 2D array of the current state of the part  (0= empty, 1 = filled)
%   - loc  (x,y) location of the next tile
%   - direction:  direction the new tile is moving
%   ('u','d','l','r')
%
% Output: moveValid = true if the first mating tile the new tile
% touches as it moves in the direction 'direction' is when it reaches
% location
%           otherwise, moveValid = false
%
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu, Sep 27, 2016

if nargin<2
    % test inputs if no arguments are given
    partialAssembly = [...
        0,1,0,1,0;
        1,1,1,1,0;
        0,1,0,1,0;
        0,0,0,0,0;
        0,0,0,0,0;];
    direction = 'l';
<<<<<<< HEAD
    loc = [3,5];
    partColored=[ 0 1 0 1 0;
=======
    loc = [2,5];
    partColored=[ ...
        0 1 0 1 0;
>>>>>>> origin/master
        1 2 1 2 1;
        0 1 0 1 2;
        0 0 0 0 0;
        0 0 0 0 0];
end

[r,c] = size(partialAssembly);

Color = partColored(loc(1,1),loc(1,2));
tmpAssembly = partialAssembly.*partColored;
% rearrange shape so part is always entering from right
if direction == 'l'  %tile is moving left
    Location = loc;
elseif direction == 'r'  %tile is moving right
    Location = [loc(1,1),c-loc(1,2)+1];
    tmpAssembly = fliplr(tmpAssembly);
elseif direction == 'u'  %tile is moving up
    Location = [c-loc(1,2)+1,loc(1,1)];
    tmpAssembly = rot90(tmpAssembly);
elseif direction == 'd' %tile is moving down
    Location = [loc(1,2),r-loc(1,1)+1];
    tmpAssembly = rot90(tmpAssembly,3);
end
c = size(tmpAssembly,2);

rowForAssembly = tmpAssembly(Location(:,1),Location(:,2):c);
if sum(rowForAssembly) > 0
    moveValid = false; %There's a blocking tile in the row/column in which this tile must move
else
    tmpAssembly_pad = padarray(tmpAssembly,[1 1]); %adds zeros on all sides
    array_up = tmpAssembly_pad(Location(1,1):(Location(1,1)+2),Location(1,2)+2:c+1);
    if sum(sum(array_up == 3-Color)) > 0
        moveValid = false;%There's an opposite colored tile in the upper/lower row for left right movement and side columns for up/down movement
    else
        if tmpAssembly_pad(Location(1,1)+2,Location(1,2)+1) == 3-Color...
                || tmpAssembly_pad(Location(1,1),Location(1,2)+1) == 3-Color ...
                || tmpAssembly_pad(Location(1,1)+1,Location(1,2)) == 3-Color
            moveValid = true; %There is at least one opposite-colored tile adjacent to the goal location
        else
            moveValid = false;
        end
    end
end