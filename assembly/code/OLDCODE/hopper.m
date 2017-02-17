function [hopper] = hopper(tileColor, numCopies,cols)
%This function defines hopper
% Output:hopper is the array of tiles, boundary of the hopper and the free
% space inside the hopper
%Authors: Sheryl Manzoor and Aaron T. Becker, October 19, 2016


obs = 3;

if nargin<1
   tileColor = 1;
   numCopies = 10; 
   cols = 4;
end



%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
rows = ceil(numCopies/cols);
hopper = obs*ones(rows+2,cols+4) ; % build boundary for hopper
hopper(2:1+rows,2:1+cols) = tileColor; %fillhopper with components
hopper(2:end,end-1) = 0; % build output shoot for hopper
hopper(2,end-2) = 0; %connect output shoot to tiles
hopper(end-1,2:cols-mod(numCopies,cols)+1) = 0;
%  replace some tiles with 0s to match numCopies    
end
%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%