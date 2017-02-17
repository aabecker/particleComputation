function [partXYupdated, factoryObstacleAdditionArray, align, hopper_size] = factoryAddTile(partXY,  tileXY, dir, tileColor,numCopies,pos,cols) 
% FACTORYADDTILE function adds new tile to a partially assembled part.
% Inputs: Color of new tile (tileColor), Number of copies of part (numCopies), width of hopper (cols), position of the sub-assembly (pos), 
%         partially assembled part(partXY) and direction of new tile (dir)
% Outputs: hopper with delays size (hopper_size), row position of the
% obstacle which stops the upward motion of part(align), partXY with new
% tile added (partXYupdated) and factoryObstacleAdditionArray (contains hopper, delays and assembly area)
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format compact
if nargin< 1

        partXY = [2 1; 2 2; 2 3; 2 4; 2 5; ...
        3 1; 3 2; 3 3; 3 4; 3 5];
        tileXY = [1 3];
        tileColor = 2;
        numCopies = 10;
        dir = 'd';
        pos=5;
        cols=4;
       
end


%%%%%%%%%%%%define a hopper and delays%%%%%%%%%%%%%
[hopper, hopper_size] = HopperWithDelays(tileColor, numCopies,cols,pos);

%%%%%%%%%%%%Add assembly area (free space + obstacles)%%%%%%%%%%%%%%%%%%%%%%%%
if dir == 'd'
    max_partx = max(partXY(:,2));   %If the new tile is to be added after last column of the part then direction is changed to left
    if  tileXY(1,2) <= max_partx  
        [factoryObstacleAdditionArray, align] = down_dir(hopper,partXY,tileXY);
    else
        [factoryObstacleAdditionArray, align] = left_dir(hopper,partXY,tileXY);
    end
end

if dir == 'l'
    max_party = max(partXY(:,1));  %If the new tile is to be added after last row of the part then direction is changed to up
    if tileXY(1,1) <= max_party
        [factoryObstacleAdditionArray, align] = left_dir(hopper,partXY,tileXY);
    else
        [factoryObstacleAdditionArray, align] = up_dir(hopper,partXY,tileXY);
    end
end

if dir == 'u'
    min_partx = min(partXY(:,2));  %If the new tile is to be added before first column of the part then direction is changed to right 
    if  tileXY(1,2) >= min_partx
        [factoryObstacleAdditionArray, align] = up_dir(hopper,partXY,tileXY);
    else
        [factoryObstacleAdditionArray, align] = right_dir(hopper,partXY,tileXY);
    end
end

if dir == 'r'
    min_party = min(partXY(:,1)); %If the new tile is to be added before first row of the part then direction is changed to down
    if  tileXY(1,1) >= min_party
        [factoryObstacleAdditionArray, align] = right_dir(hopper,partXY,tileXY);
    else
        [factoryObstacleAdditionArray, align] = down_dir(hopper,partXY,tileXY);
    end
end

partXYupdated = [partXY;tileXY];



end