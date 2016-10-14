function [IsPossible, factoryLayoutArray]=BuildFactory(partXY,numCopies)
% Given a polyomino part, constructs a tile factory
% that contains part hoppers for each part, and a fctory floow layout so
% that a repeated sequence of l,r,u,d constructs a new partXY each
% iteration until supplies run out
%
% Returned variables
%   IsPossible, true if part can be constructed, false else
%   factoryLayoutArray: If 'IsPossible' 2D array of obstacles and part hoppers filled with
%   colored tiles.  The factory produces partXY
%
%Authors: Sheryl Manzoor and Aaron T. Becker, Sep 27, 2016
clc

if nargin <1
 partXY=[5,2;6,2;7,2;8,2;9,2;10,2;5,3;5,4;6,4;7,4;8,4;9,4;10,4;5,5;10,5;5,6;7,6;8,6;10,6;5,7;7,7;10,7;5,8;7,8;
         8,8;9,8;10,8;10,9;10,10;10,11;10,12;9,10;9,12;8,10;8,12;7,10;7,12;6,10;6,12;5,10;5,11;5,12];
     numCopies = 10;
end

factoryLayoutArray = [];
%  1.) check for a valid build path.  If impossible, return false
[IsPossible, sequenceXY, dirs, partColoredArray]=FindBuildPath(partXY);
if false == IsPossible
    display('No build path found by assembly one-tile-at-a-time, returning')
    return
end

%  2.)  iteratively construct the factory
partXYbuild = []; % the part has no tiles
for i = 1:size(sequenceXY,1)
    %2a, construct part of the factory that adds tile i
    XYcoord = sequenceXY(i,:);
    [partXYbuild, factoryObstacleAdditionArray] = factoryAddTile(partXYbuild,  XYcoord, dirs(i), partColoredArray(XYcoord),numCopies); 
    %2b, concatenate factory to existing factory
    %TODO:  this will cause errors if either has a different number of
    %rows, to fix, add empty rows to the smaller one.  (zero padd the
    %arrays).
    factoryLayoutArray = [factoryLayoutArray; factoryObstacleAdditionArray];
    %2c, draw this stage of the factory
    
end



%  3.) draw the factory


% 4.) enable control of the factory


