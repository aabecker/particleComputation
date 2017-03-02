function [d] = Mold(partXY, tileXY)
% MOULD function to build the mould of the left face of partXY.
% [d] = Mold(partXY, tileXY)
% Input: Array of part's XY coordinate (partXY) and new tile to be added (tileXY)
% Output: a column vector (d) that contains distances of each row of the part from the left most tile
% in partXY, and this informaiton is used to build the mold of the left
% face of partXY
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu
if nargin < 1
   %Test inputs if no arguments are provided
   tileXY = [1 3];
   partXY=[2 2;2 3;2 4]; 
end
partXYt = [partXY;tileXY]; %complete part with tile
part_width = abs(max(partXYt(:,1)) - min(partXYt(:,1)))+1; %width of part
min_col = min(partXYt(:,2)); %minimum x-position of the partXY
d = 10000*ones(part_width,1); %containes distances
cnt = 1;
for i=max(partXYt(:,1)):-1:min(partXYt(:,1)) %run for loop from last row of the partXY to its
                                            %minimum row 
    for j=1:size(partXYt(:,1)) %for loop to go through all tile positions
        if partXYt(j,1) == i %if ith-row position equals y-coordinate of the tile 
          
              t =  partXYt(j,2) - min_col; %calculate the x-distance between the left most tile
                                %and the current tile position
              if t< d(cnt,1) %if distance is less than previously stored d-value then replace
                            %with the least d-value, which is the distance
                            %of the left most tile in that row of partXY.
                 d(cnt,1) = t; 
              end        
        end    
    end
    cnt = cnt + 1;
end
end