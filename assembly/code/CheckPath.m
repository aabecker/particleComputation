function moveValid = CheckPath(partialAssembly, loc, direction, partColored)
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
% Authors: Sheryl Manzoor and Aaron T. Becker, Sep 27, 2016

if nargin<2  
    % an initial condition that should be false
    partialAssembly = [...
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0;
        0,0,0,0,0;
        0,0,0,0,0;];
    direction = l;
    location = [1,4];
    
    
end


[r,c] = size(partialAssembly);

if direction == 'l'
    color = partColored(loc(1,1),loc(1,2));
    location = loc;
    tmpAssembly = partialAssembly.*partColored;   
    
elseif direction == 'r'
    color = partColored(loc(1,1),loc(1,2));
    location = [loc(1,1),c-loc(1,2)+1];  
    partialAssembly = fliplr(partialAssembly);
    partColored = fliplr(partColored);
    tmpAssembly = partialAssembly.*partColored;
elseif direction == 'u'
    color = partColored(loc(1,1),loc(1,2));
    location = [c-loc(1,2)+1,loc(1,1)];  
    partialAssembly = rot90(partialAssembly);
    partColored = rot90(partColored);
    tmpAssembly = partialAssembly.*partColored;
elseif direction == 'd'
    color = partColored(loc(1,1),loc(1,2));
    location = [loc(1,2),r-loc(1,1)+1];  
    partialAssembly = rot90(partialAssembly,3);
    partColored = rot90(partColored,3);
    tmpAssembly = partialAssembly.*partColored;
end


[~,c] = size(partialAssembly);

temp = partialAssembly(location(:,1),location(:,2):c);
if sum(temp) >=1 %check #1
    moveValid = 'false';
    return;
else
    tmpAssembly_pad = padarray(tmpAssembly,[1 1]);
    temp2 = tmpAssembly_pad((location(1,1)-1+1):(location(1,1)+1+1),location(1,2)+1+1:c+1);
    if sum(sum(temp2 == 3-color)) >0 %check #2
        moveValid = 'false';
        return;
    else
       
        if tmpAssembly_pad(location(1,1)+1+1,location(1,2)+1) ~=color...
            && tmpAssembly_pad(location(1,1)-1+1,location(1,2)+1)~=color ...
               && tmpAssembly_pad(location(1,1)+1,location(1,2)-1+1)~=color
            moveValid = 'true';
            return;
        else
            moveValid = 'false';
        end
    end          
end
        
end