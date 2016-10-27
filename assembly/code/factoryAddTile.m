function [partXYupdated, factoryObstacleAdditionArray, align] = factoryAddTile(partXY,  tileXY, dir, tileColor,numCopies) 
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
    %test case
%     partXY = [1,1];
%     dir = 'd';
%     tileXY = [1,2];
%     tileColor = 2;

        partXY = [2 1; 2 2; 2 3; 2 4; 2 5; ...
        3 1; 3 2; 3 3; 3 4; 3 5];
        tileXY = [1 3];
        tileColor = 2;
        numCopies = 10;
        cols = 4;
        dir = 'd';
         hopper2 = [3 3 3 3 3 3 3 3; ...
            3 0 0 0 0 0 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 0 0 3 0 3; ...
            3 3 3 3 3 3 0 3];
end

display('stub code: not implemented yet');
display(dir);
display(tileColor);

%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
%hopper2 = define_hopper(tileColor, numCopies);
hopper2 = hopper(tileColor, numCopies,4)
%%%%%%%%%%%%ends%%%%%%%%%%%%%%%%%%%%%%%%
if dir == 'd'
    [partXYupdated, factoryObstacleAdditionArray, align] = down_dir(hopper2,partXY,  tileXY);
end

if dir == 'l'
    [partXYupdated, factoryObstacleAdditionArray, align] = left_dir(hopper2,partXY,  tileXY);
end

if dir == 'u'
    [partXYupdated, factoryObstacleAdditionArray, align] = up_dir(hopper2,partXY,  tileXY);
end

if dir == 'r'
    [partXYupdated, factoryObstacleAdditionArray, align] = right_dir(hopper2,partXY,  tileXY);
end


%stub code
partXYupdated = [partXY;tileXY];
%factoryObstacleAdditionArray = [3,3];

%suggestions: design this code for 'd' moves first, then do other
%directions.  First draw pictures.  We want to have an algorithm we can
%place into our paper.


end