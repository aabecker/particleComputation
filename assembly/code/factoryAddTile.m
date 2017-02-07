function [partXYupdated, factoryObstacleAdditionArray, align, hopper_size] = factoryAddTile(partXY,  tileXY, dir, tileColor,numCopies,pos,cols) 
% Constructs a part of the
% factory that slides a tile of color tileColor in direction dir to
% location tileXY of partXY, by sliding the tile out of a part-hopper (and
% perhaps redirected by obstacles).
% 
% The part partXY is indexed according to some external reference frame
% (y-values may be positive or negative).  partXY is in the middle of a
% ?right? move and has exited the factory obstacles for the previous tile
% tileColor is in  [1,2];  Assume that the move in direction dir to end at
% tileXY is a valid move.
%
%  This code is called iteratively to build a factory.  This function is
%  called for each 1x1 tile in a valid build sequence.
% 
% Output:
% 
% partXYupdated is the new xy positions of every tile in the part (that has
% added tileXY).  The positions are measured after the part has exited
% factoryObstacleAddition during a move in the right direction.
% 
% factoryObstacleAdditionArray a 2D matrix with all the obstacles and the part hopper required to
% add one tile to  partXY. Each factoryObstacleAdditionArray is a
% non-overlapping vertical strip
% This is ensured by the following constraints.
% 
% Min(factoryObstacleAddition(:,1) >= min(partXY(:,1)) and
% Max(factoryObstacleAddition(:,1) < max(partXYupdated (:,1))
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Sheryl Manzoor and Aaron T. Becker, atbecker@uh.edu
% Begun: Oct 10, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%cols = 5;

%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
%hopper2 = hopper_ml(tileColor, numCopies,4,pos);
[hopper2, hopper_size] = hopper_dl(tileColor, numCopies,cols,pos);
%%%%%%%%%%%%ends%%%%%%%%%%%%%%%%%%%%%%%%
if dir == 'd'
    max_partx = max(partXY(:,2));   %If the new tile is to be added after last column of the part then direction is changed to left ;tile added from right to left
    if  tileXY(1,2) <= max_partx    %column of the tile to be added is compared to the last column of the assembled part
        [~, factoryObstacleAdditionArray, align] = down_dir(hopper2,partXY,tileXY);
    else
        [~, factoryObstacleAdditionArray, align] = left_dir(hopper2,partXY,tileXY);
    end
end

if dir == 'l'
    max_party = max(partXY(:,1));  %If the new tile is to be added after last row of the part then direction is changed to up
    if tileXY(1,1) <= max_party
        [~, factoryObstacleAdditionArray, align] = left_dir(hopper2,partXY,tileXY);
    else
        [~, factoryObstacleAdditionArray, align] = up_dir(hopper2,partXY,tileXY);
    end
end

if dir == 'u'
    min_partx = min(partXY(:,2));  %If the new tile is to be added before first column of the part then direction is changed to right 
    if  tileXY(1,2) >= min_partx
        [~, factoryObstacleAdditionArray, align] = up_dir(hopper2,partXY,tileXY);
    else
        [~, factoryObstacleAdditionArray, align] = right_dir(hopper2,partXY,tileXY);
    end
end

if dir == 'r'
    min_party = min(partXY(:,1)); %If the new tile is to be added before first row of the part then direction is changed to down
    if  tileXY(1,1) >= min_party
        [~, factoryObstacleAdditionArray, align] = right_dir(hopper2,partXY,tileXY);
    else
        [~, factoryObstacleAdditionArray, align] = down_dir(hopper2,partXY,tileXY);
    end
end

partXYupdated = [partXY;tileXY];



end