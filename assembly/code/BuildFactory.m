function [IsPossible, factoryLayoutArray]=BuildFactory(partXY,numCopies)
% BUILDFACTORY given a polyomino part, constructs a tile factory
% that contains part hoppers for each part, and a factory floor layout so
% that a repeated sequence of r,u,l,d constructs a new partXY each
% iteration until supplies run out
% [IsPossible, factoryLayoutArray]=BuildFactory(partXY,numCopies)
% partXY:2D array of the coordinates (rows and columns) of the tiles
% numCopies:Number of copies of the partXY to be produced.
% Returned variables
% IsPossible, true if part can be constructed, false else
% factoryLayoutArray: If 'IsPossible' 2D array of obstacles and part hoppers filled with
% colored tiles.  The factory produces partXY
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu
if nargin <1
    %Test inputs if no arguments are provided
     % partXY = [1,1;1,2;1,3;1,4]; %row 
     % partXY = [1,1;2,1;3,1;4,1];%column
%    partXY = [5 3;4 3;4 2;3 2;2 2;1 2;1 3]; %figure 1 image (7 tiles)
%     partXY = [5 3;4 3;4 4;5 4];
%     partXY = [5 3;4 3;4 2;3 2];
%     partXY=[7 6;9 6;6 7;7 7;8 7;9 7;10 7;10 8;11 8]; %simulates
%     partXY = [5 5;5 4;5 3;5 2;5 1;4 3]; %for down, down, down....
%     partXY=[7 5;5 7;9 5;11 7;11 9;9 11;7 11;5 9;7 6;9 6;6 7;7 7;8 7;9 7;10 7;7 8;9 8;6 9;7 9;8 9;9 9;10 9;7 10;9 10]; % # part, 24 tiles
%    partXY=[7 6;9 6;6 7;7 7;8 7;9 7;10 7;7 8;9 8;6 9;7 9;8 9;9 9;10 9;7 10;9 10]; % # part
%     partXY = [1 2;2 2;3 2;4 3;5 3;4 2]; %contains the item positions for the zigzag Part 
     partXY=[5 5;6 5;6 6;6 7;5 7;4 7;3 7;3 6;3 5;3 4;3 3;4 3;5 3;6 3;7 3;8 3;8 4;8 5;8 6;8 7;8 8];%spiral inner node
    numCopies = 8;  %TODO: errors if < 9
    cols = 2;       %TODO: define this variable
    obs=3;          %TODO: define this variable
end
factoryLayoutArray = [];
align_prev = 0;
[IsPossible, sequenceXY, dirs, partColoredArray]=FindBuildPathErodeAndDecompose(partXY); %Checks for a valid path
if false == IsPossible   %If path is not found then return
    disp('No build path found by assembly one-tile-at-a-time, returning')
    return
end
partXYbuild = sequenceXY(1,:); % the part has first tile
for i = 2:size(sequenceXY,1) %Build one sub-assembly each iteration 
    XYcoord = sequenceXY(i,:); 
    [partXYbuild, factoryObstacleAdditionArray, align_new, hopper_size] = FactoryAddTile(partXYbuild,  XYcoord, dirs(i-1), partColoredArray(XYcoord(1,1),XYcoord(1,2)),numCopies,i,cols); 
    hopper_size = hopper_size-2;       
    if i==2 %Builds the first sub-assembly layout
        tileColor = partColoredArray(sequenceXY(1,1),sequenceXY(1,2));
        hopper2 = Hopper(tileColor, numCopies,cols);        
        %%%%%%%%%%%%ends%%%%%%%%%%%%%%%%%%%%%%%%
        factoryLayoutArray = FirstFactory(hopper2);    
    end    
    if i==2
        factoryLayoutArray = vertcat(obs*ones(2,size(factoryLayoutArray,2)),factoryLayoutArray); %#ok<AGROW>
    end
    factoryLayoutArray = ConcatenateFactories(factoryLayoutArray,factoryObstacleAdditionArray, align_prev,hopper_size); %Concatenates previous sub-assemblies with new one
    if align_prev ==0
        num =0 ;
    else
        num = align_prev - (hopper_size+2)-1;
    end
    align_prev = num + align_new+1;    %calculates the alignment factor (align_prev) that serves as
                    %input to concaternateFactories. Align_prev maintains
                    %total movement down with respect to the top of the
                    %first sub factory of the current factory to align it to partial
                    %assembled factory.
end
Num_cols2add = 5; %Columns added at the end of factory to make exit path
cols2add_end = factoryLayoutArray(:,end);
cols2add_end = repmat(cols2add_end,1,Num_cols2add);
factoryLayoutArray = horzcat(factoryLayoutArray,cols2add_end);
factoryLayoutArray_m=zeros(size(factoryLayoutArray));
for i=1:size(factoryLayoutArray,1) % labels of 1 and 2 are changed to 2 and 3; obstacles represented by 3 are changed to 1  for the function partFactory_test
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
DisplayFactory(factoryLayoutArray_m) %Display Factory
end