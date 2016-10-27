%function [IsPossible, factoryLayoutArray]=BuildFactory(partXY,numCopies)
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
clear all
clc


%if nargin <1
%  partXY=[5,2;6,2;7,2;8,2;9,2;10,2;5,3;5,4;6,4;7,4;8,4;9,4;10,4;5,5;10,5;5,6;7,6;8,6;10,6;5,7;7,7;10,7;5,8;7,8;
%          8,8;9,8;10,8;10,9;10,10;10,11;10,12;9,10;9,12;8,10;8,12;7,10;7,12;6,10;6,12;5,10;5,11;5,12];
    partXY = [5 3;4 3;4 2;3 2;2 2;1 2];
    %partXY = [3 4; 2 4; 1 4];
%      partXY=[4 2;
%       5 2; % Spiral part inner node [5 5]
%       6 2
%       7 2;
%       8 2;
%       8 3;
%       8 4;
%       8 5;
%       8 6;
%       8 7;
%       7 7;
%       6 7;
%       5 7;
%       4 7;
%       4 3;
%       4 4;
%       4 5;
%       5 5];
    numCopies = 10;
%end

factoryLayoutArray = [];
align_prev = 0;
%  1.) check for a valid build path.  If impossible, return false
[IsPossible, sequenceXY, dirs, partColoredArray]=FindBuildPath_ver2(partXY);
if false == IsPossible
    display('No build path found by assembly one-tile-at-a-time, returning')
    return
end

%  2.)  iteratively construct the factory
%partXYbuild = []; % the part has no tiles
partXYbuild = sequenceXY(1,:); % the part has first tiles
numCopies = 10;
for i = 2:size(sequenceXY,1)
    %2a, construct part of the factory that adds tile i
    
    XYcoord = sequenceXY(i,:);
    [partXYbuild, factoryObstacleAdditionArray, align_new] = factoryAddTile(partXYbuild,  XYcoord, dirs(i-1), partColoredArray(XYcoord(1,1),XYcoord(1,2)),numCopies); 
    %2b, concatenate factory to existing factory
    %TODO:  this will cause errors if either has a different number of
    %rows, to fix, add empty rows to the smaller one.  (zero padd the
    %arrays).
    
    if i==2
        tileColor = partColoredArray(sequenceXY(1,1),sequenceXY(1,2));
        %hopper2 = define_hopper(tileColor, numCopies);
        hopper2 = hopper(tileColor, numCopies,4)
        %%%%%%%%%%%%ends%%%%%%%%%%%%%%%%%%%%%%%%
        tileXY = [1+sequenceXY(1,1) 1+sequenceXY(1,2)];
        [partXYupdated, factoryLayoutArray] = first_fac(hopper2,sequenceXY(1,:),  tileXY);
        %factoryLayoutArray = factoryObstacleAdditionArray;
        
    end
    
    %factoryLayoutArray = [factoryLayoutArray, factoryObstacleAdditionArray];
    factoryLayoutArray = concat_factories(factoryLayoutArray,factoryObstacleAdditionArray, align_prev,ceil(numCopies/4));
    hopper_size = ceil(numCopies/4);
    if align_prev ==0
        num =0 ;
    else
        num = align_prev - (hopper_size+2)-1;
    end
    align_prev = num + align_new;
    %2c, draw this stage of the factory
    

end

for i=1:size(factoryLayoutArray,1)
   for j=1:size(factoryLayoutArray,2)
       if factoryLayoutArray(i,j) == 1
            factoryLayoutArray_m(i,j) = 3;
       elseif factoryLayoutArray(i,j) == 3
           factoryLayoutArray_m(i,j) = 1;
       else
           factoryLayoutArray_m(i,j) = factoryLayoutArray(i,j);
       end
   end
end

dlmwrite('factory.txt',factoryLayoutArray_m);

partFactory_test('factory.txt');

%  3.) draw the factory


% 4.) enable control of the factory
