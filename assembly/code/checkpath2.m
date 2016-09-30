function moveValid = checkpath2(partialAssembly, location, direction, partColored)
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

color = partColored(location(1,1),location(1,2));
tmpAssembly = partialAssembly.*partColored;
[r,c] = size(partialAssembly);

if direction == 'l'
    if sum(partialAssembly(location(:,1),location(:,2):c)) >0 %add together all particles in this row to the right of the desired location
        moveValid = 'false';
        return;
    else % potential problem about boundary 2 solutions are possible
        temp2 = tmpAssembly((location(:,1)-1):(location(:,1)+1),location(:,2)+1:c);
        [u,v] = size(temp2);
        flag = 1; %flag for third check;
        for i=1:u
            for j=1:v
                if abs(temp2(i,j) - color) == 1 && temp2(i,j)~=0
                    moveValid = 'false';
                    flag=0;
                    break;
                end
            end
        end
        if flag==1
            score=0;
            top = [];
            bottom=[];
            right=[];
            left=[];
            top = [location(1,1)-1 location(1,2)];
            bottom = [location(1,1)+1 location(1,2)];
            right = [location(1,1) location(1,2)+1];
            left = [location(1,1) location(1,2)-1];
            
            if tmpAssembly(top(1,1),top(1,2))~=color
                if tmpAssembly(bottom(1,1),bottom(1,2))~=color
                    if tmpAssembly(right(1,1),right(1,2))~=color
                        if tmpAssembly(left(1,1),left(1,2))~=color
                            moveValid = 'true';
                        else
                            moveValid = 'false';
                            return;
                        end
                    else
                        moveValid = 'false';
                        return;
                    end
                else
                    moveValid = 'false';
                    return;
                end
            else
                moveValid = 'false';
                return;
            end
        end
    end
    
elseif direction == 'r'
    temp = partialAssembly(location(:,1),1:location(:,2));
    if sum(temp) >=1
        moveValid = 'false';
        return;
    else
        temp2 = tmpAssembly((location(:,1)-1):(location(:,1)+1),1:location(:,2)-1);
        [u,v] = size(temp2);
        flag = 1; %flag for third check;
        for i=1:u
            for j=1:v
                if abs(temp2(i,j) - color) == 1 && temp2(i,j)~=0
                    moveValid = 'false';
                    flag=0;
                    break;
                end
            end
        end
        if flag==1
            score=0;
            top = [];
            bottom=[];
            right=[];
            left=[];
            top = [location(1,1)-1 location(1,2)];
            bottom = [location(1,1)+1 location(1,2)];
            right = [location(1,1) location(1,2)+1];
            left = [location(1,1) location(1,2)-1];
            
            if tmpAssembly(top(1,1),top(1,2))~=color
                if tmpAssembly(bottom(1,1),bottom(1,2))~=color
                    if tmpAssembly(right(1,1),right(1,2))~=color
                        if tmpAssembly(left(1,1),left(1,2))~=color
                            moveValid = 'true';
                        else
                            moveValid = 'false';
                            return;
                        end
                    else
                        moveValid = 'false';
                        return;
                    end
                else
                    moveValid = 'false';
                    return;
                end
            else
                moveValid = 'false';
                return;
            end
            
        end
        
    end
    
elseif direction == 'u'
    temp = partialAssembly(location(:,1):r,location(:,2));
    if sum(temp) >=1
        moveValid = 'false';
        return;
    end
    
elseif direction == 'd'
    temp = partialAssembly(1:location(:,1),location(:,2));
    if sum(temp) >=1
        moveValid = 'false';
        return;
    end
    
end


% this needs to be replaced with a check
%moveValid = false;

end