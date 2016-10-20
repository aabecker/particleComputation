function [partXY]=TestDepthFirstSearch()
%Test cases for FindBuildPath
%%Authors: Sheryl Manzoor, smanzoor2@uh.edu and Aaron T. Becker, atbecker@uh.edu, Oct 19, 2016


% partXY = [1 2;2 2;3 2;4 3;5 3;4 2]; %contains the item positions for the Part
% partXY=[7 6;9 6;6 7;7 7;8 7;9 7;10 7;7 8;9 8;6 9;7 9;8 9;9 9;10 9;7 10;9 10];
 
% partXY=[4 2;5 2;6 2;7 2; 8 2; 8 3; 8 4; 8 5; 8 6; 8 7; 7 7; 6 7; 5 7; 4 7; 4 3; 4 4;4 5;5 5];    % Spiral part inner node [5 5]
  
partXY=[5,2;6,2;7,2;8,2;9,2;10,2;5,3;5,4;6,4;7,4;8,4;9,4;10,4;5,5;10,5;5,6;7,6;8,6;10,6;5,7;7,7;10,7;5,8;7,8;
        8,8;9,8;10,8;10,9;10,10;10,11;10,12;9,10;9,12;8,10;8,12;7,10;7,12;6,10;6,12;5,10;5,11;5,12];
%         part in BS thesis

% partXY=[5 2;6 2;7 2;8 2;9 2;10 2;5 3;5 4;5 5;5 6;6 6;7 6;8 6;8 5;8 4;7 4;10 3;10 4; 10 5;10 6;10 7;10 8;10 9;10 10;10 11;10 12;9 12;8 12;
%         7 12;6 12;5 12;5 11;5 10;5 9;5 8;6 8;7 8;8 8;8 9;8 10;7 10];  %Two spirals case: returns moveValid 'false'

end