function moveValid = CheckPath1Tile(partialAssembly, loc, direction, partColored)
% CheckPath1Tile
%   Input:
%   - partialAssembly: a binary, 2D array of the current state of the part  (0= empty, 1 = filled)
%   - loc  (x,y) location of the next component
%   - direction:  direction the new particle is moving
%   ('u','d','l','r')
%
% Output: moveValid = true if the first mating particle the new particle
% touches as it moves in the direction 'direction' is when it reaches
% location
%           otherwise, moveValid = false
%
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu, Sep 27, 2016

if nargin<2
    % test inputs if no arguments are given
    partialAssembly = [...
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0;
        0,0,0,0,0;
        0,0,0,0,0;];
    direction = 'l';
    loc = [1,4];
    partColored=[ 0 1 0 1 0;
        1 2 1 2 1;
        0 1 0 1 0;
        0 0 0 0 0;
        0 0 0 0 0];
end

[r,c] = size(partialAssembly);

Color = partColored(loc(1,1),loc(1,2));
if direction == 'l'  %item is moving from right to left
    Location = loc;
elseif direction == 'r'  %item is moving from left to right
    Location = [loc(1,1),c-loc(1,2)+1];
    partialAssembly = fliplr(partialAssembly);
    partColored = fliplr(partColored);
elseif direction == 'u'  %item is moving from down to up
    Location = [c-loc(1,2)+1,loc(1,1)];
    partialAssembly = rot90(partialAssembly);
    partColored = rot90(partColored);
elseif direction == 'd' %item is moving from up to down
    Location = [loc(1,2),r-loc(1,1)+1];
    partialAssembly = rot90(partialAssembly,3);
    partColored = rot90(partColored,3);
end
tmpAssembly = partialAssembly.*partColored;

[~,c] = size(partialAssembly);

array_rc = partialAssembly(Location(:,1),Location(:,2):c);
if sum(array_rc) >=1  
    moveValid = false;%There's a blocking particle in the row/column in which this particle must move
else
    tmpAssembly_pad = padarray(tmpAssembly,[1 1]);
    array_up = tmpAssembly_pad(Location(1,1):(Location(1,1)+2),Location(1,2)+2:c+1);
    if sum(sum(array_up == 3-Color)) >0 
        moveValid = false;%There's an opposite colored item in the upper/lower row for left right movement and side columns for up/down movement
    else
        if tmpAssembly_pad(Location(1,1)+1+1,Location(1,2)+1) == 3-Color...
                || tmpAssembly_pad(Location(1,1)-1+1,Location(1,2)+1)== 3-Color ...
                || tmpAssembly_pad(Location(1,1)+1,Location(1,2)-1+1)== 3-Color
            moveValid = true; %There is at least one opposite-colored particle adjacent to the goal location
        else
            moveValid = false;
        end
    end
end