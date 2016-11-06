function [IsPossible, factoryLayoutArray]=BuildFactory(partXY,numCopies)
% Given a polyomino part, constructs a tile factory
% that contains part hoppers for each part, and a factory floor layout so
% that a repeated sequence of l,r,u,d constructs a new partXY each
% iteration until supplies run out
%
% Returned variables
%   IsPossible, true if part can be constructed, false else
%   factoryLayoutArray: If 'IsPossible' 2D array of obstacles and part hoppers filled with
%   colored tiles.  The factory produces partXY
%
%Authors: Sheryl Manzoor and Aaron T. Becker, Oct 19, 2016


if nargin <1
    partXY = [5 3;4 3;4 2;3 2;2 2;1 2];
    %partXY = [5 5;5 4;5 3;5 2;5 1;4 3]; %for down, down, down....
    %partXY = [5 1;5 2;5 3;5 4;5 5]; %for left, left, left....
    %partXY = [1 1;2 1;3 1;4 1;5 1]; %for up, up, up....
    %partXY = [5 5;5 4;5 3;5 2;5 1]; %for right, right, right....
    %partXY = [5 5;4 5;3 5;2 5;1 5]; %for test1
    %partXY = [5 5;5 4;5 3]; %for test2
    %partXY=[7 6;9 6;6 7;7 7;8 7;9 7;10 7;7 8;9 8;6 9;7 9;8 9;9 9;10 9;7 10;9 10];
    numCopies = 20;
end

factoryLayoutArray = [];
align_prev = 0;
%  1.) check for a valid build path.  If impossible, return false
[IsPossible, sequenceXY, dirs, partColoredArray]=FindBuildPath(partXY);
if false == IsPossible
    display('No build path found by assembly one-tile-at-a-time, returning')
    return
end


partXYbuild = sequenceXY(1,:); % the part has first tiles
for i = 2:size(sequenceXY,1)
    
    XYcoord = sequenceXY(i,:);
    [partXYbuild, factoryObstacleAdditionArray, align_new] = factoryAddTile(partXYbuild,  XYcoord, dirs(i-1), partColoredArray(XYcoord(1,1),XYcoord(1,2)),numCopies); 
 %partXYbuild=part built before adding a tile
 %XYcoord = coordinates of the new tile to be added to the part
 %dirs(i-1)=direction of the new tile
 %partColoredArray(XYcoord)= color of new tile
 %numCopies=number of tiles in the hopper
 %Outputs: partXYbuild = part after addition of new tile
 %facoryObstacleAdditionArray = array of part hopper, obstacles and free
 %space
 %align_new = ?
    
    if i==2 %Builds the first factory's layout
        tileColor = partColoredArray(sequenceXY(1,1),sequenceXY(1,2));   %Color of the first tile in the sequence array
        hopper2 = hopper(tileColor, numCopies,4); %Returns the hopper arrray
        %%%%%%%%%%%%ends%%%%%%%%%%%%%%%%%%%%%%%%
          [~, factoryLayoutArray] = first_fac(hopper2);
        
    end
    
    factoryLayoutArray = concat_factories(factoryLayoutArray,factoryObstacleAdditionArray, align_prev,ceil(numCopies/4));
    hopper_size = ceil(numCopies/4);
    if align_prev ==0
        num =0 ;
    else
        num = align_prev - (hopper_size+2)-1;
    end
    align_prev = num + align_new+1;
    

end

for i=1:size(factoryLayoutArray,1)   % labels of 1 and 2 are changed to 2 and 3; obstacles represented by 3 are changed to 1  for the function partFactory_test
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

dlmwrite('factory.txt',factoryLayoutArray_m); %Writes numeric data in array factoryLayoutArray_m to n ASCII format file

partFactory_test('factory.txt'); %Path is passed to this function to visualize factory layout at each move

end