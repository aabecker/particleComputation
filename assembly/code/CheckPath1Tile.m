function moveValid = CheckPath1Tile(partialAssembly, loc, Direction, partColored)
% labelColor
%   Input: 
%   - partialAssemblya binary, 2D array partialAssembly of the current state of the part  (0= empty, 1 = filled)
%   - location  (x,y) location of the next component
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
    % an initial condition that should be false
    partialAssembly = [...
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0;
        0,0,0,0,0;
        0,0,0,0,0;];
    Direction = 'l';
    loc = [1,4];
    partColored=[ 0 1 0 1 0;
                  1 2 1 2 1;
                  0 1 0 1 0;
                  0 0 0 0 0;
                  0 0 0 0 0];
end


[r,c] = size(partialAssembly);


if Direction == 'l'  %item is moving from right to left
    Color = partColored(loc(1,1),loc(1,2));
    Location = loc;
    tmpAssembly = partialAssembly.*partColored;
elseif Direction == 'r'  %item is moving from left to right
    Color = partColored(loc(1,1),loc(1,2));
    Location = [loc(1,1),c-loc(1,2)+1];  
    partialAssembly = fliplr(partialAssembly);
    partColored = fliplr(partColored);
    tmpAssembly = partialAssembly.*partColored;
elseif Direction == 'u'  %item is moving from down to up
    Color = partColored(loc(1,1),loc(1,2));
    Location = [c-loc(1,2)+1,loc(1,1)];  
    partialAssembly = rot90(partialAssembly);
    partColored = rot90(partColored);
    tmpAssembly = partialAssembly.*partColored;
elseif Direction == 'd' %item is moving from up to down 
    Color = partColored(loc(1,1),loc(1,2));
    Location = [loc(1,2),r-loc(1,1)+1];  
    partialAssembly = rot90(partialAssembly,3);
    partColored = rot90(partColored,3);
    tmpAssembly = partialAssembly.*partColored;
end


[~,c] = size(partialAssembly);

array_rc = partialAssembly(Location(:,1),Location(:,2):c);
if sum(array_rc) >=1 %There's no item in the row/column in which the item is moving
    moveValid = 'false';
    return;
else
    tmpAssembly_pad = padarray(tmpAssembly,[1 1]);
    array_up = tmpAssembly_pad((Location(1,1)-1+1):(Location(1,1)+1+1),Location(1,2)+1+1:c+1);
    if sum(sum(array_up == 3-Color)) >0 %There's no opposite colored item in the upper/lower row for left right movement and side columns for up/down movement
        moveValid = 'false';
        return;
    else
if tmpAssembly_pad(Location(1,1)+1+1,Location(1,2)+1) ~=Color...   %There are no same colored items adjacent to the goal location
            && tmpAssembly_pad(Location(1,1)-1+1,Location(1,2)+1)~=Color ...
               && tmpAssembly_pad(Location(1,1)+1,Location(1,2)-1+1)~=Color
            moveValid = 'true';
            return;
        else 
            
        moveValid = 'false';
end
    end   
end