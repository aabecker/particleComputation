function [hopper] = Hopper(tileColor, numCopies,cols)
% HOPPER function builds hopper in a sub-assembly
% [hopper] = Hopper(tileColor, numCopies,cols)
% Inputs: Color of tiles in the hopper (tileColor), Number of copies of
% part (numCopies), width of hopper (cols)
% Outputs: hopper with tiles (hopper)
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu
obs = 3; %Define Obstacle
if nargin<1
   %Test inputs if no arguments are provided
   tileColor = 1;
   numCopies = 10; 
   cols = 4;
end
%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
rows = ceil(numCopies/cols); % Find rows of the hopper
hopper = obs*ones(rows+2,cols+4) ; % build boundary for hopper
hopper(2:1+rows,2:1+cols) = tileColor; %fillhopper with components
hopper(2:end,end-1) = 0; % build output shoot for hopper
hopper(2,end-2) = 0; %connect output shoot to tiles
if mod(numCopies,cols)~=0
    hopper(end-1,2:cols-mod(numCopies,cols)+1) = 0; 
end
    %  replace some tiles with 0s to match numCopies    

end