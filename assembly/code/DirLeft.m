function [factoryObstacleAdditionArray, align] = DirLeft(hopper,partXY,  tileXY)
% DIRLEFT function for the tile added through left move
% [factoryObstacleAdditionArray, align] = DirLeft(hopper,partXY,  tileXY)
% Inputs: hopper with delays (hopper), partXY and tile to be added tileXY.
% Outputs: align and sub-assembly layout (factoryObstacleAdditionArray)
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu
obs = 3;
if nargin<1
   %Test inputs if no arguments are provided
   partXY = [5 5; 5 4; 5 3; 5 2; 5 1];
   tileXY = [5 6];
   hopper = [3 3 3 3 3 3 3 3; ...
            3 0 0 0 0 0 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 0 0 3 0 3; ...
            3 3 3 3 3 3 0 3];   
end
hopper_width = size(hopper,1);
part_length = abs(max(partXY(:,2) - min(partXY(:,2))))+1; %length of part
part_width = abs(max(partXY(:,1)) - min(partXY(:,1)))+1; %width of part
partXYt = [partXY;tileXY];
part_lengtht = abs(max(partXYt(:,2) - min(partXYt(:,2))))+1; %length of part
part_widtht = abs(max(partXYt(:,1)) - min(partXYt(:,1)))+1; %width of part
%%%%%%%%%%%Add White space to finalize the width of the hopper%%%%%
height_obs = abs(max(partXY(:,1) - tileXY(:,1))); %row position of the tile w.r.t part
add_width = (part_width+part_widtht)+3+height_obs;
hopper = vertcat(hopper, zeros(add_width,size(hopper,2)));
%%%%%%%%%%Add Main Obstacle%%%%%%%%%%%%%%%%%%
height_obs = abs(max(partXY(:,1) - tileXY(:,1))); %row position of the tile w.r.t part
hopper(end-height_obs-2+1:end,end-2:end) = obs; %obstacle added                                               
%%%%%%%%%%Add Right stop Obstacle%%%%%%%%%%%%%
hopper(hopper_width+1:hopper_width+part_width+1,end-2) = obs; 
                        %obstacle to stop the right motion
                        %Obstacle height is same as width of the part                        
hopper(hopper_width+1:hopper_width+part_width+1,end) = obs; %to make a corridor next to the
                                                                %mouth of
                                                                %hopper
%%%%add zeros to the left of hopper 
if (part_lengtht+part_length)+1 >= size(hopper,2)-4 
    cols2add =  (part_lengtht+part_length)+1  - (size(hopper,2)-4);
    hopper = horzcat(zeros(size(hopper,1),cols2add),hopper);
    hopper(1:hopper_width,1:cols2add) = obs*ones(hopper_width,cols2add);
end
%%%%%%%%%%Add Bottom stop Obstacle%%%%%%%%%%%%%
hopper(end-1:end, 1:end) = obs; %define the bottom 
                        %obstacle to stop the "downward" motion of the part                        
%%%%%%%%%Add Left Obstacle%%%%%%%%%
d = Mold(partXY,tileXY);
hopper(size(hopper,1)-part_widtht-2-height_obs:size(hopper,1)-2,1:size(hopper,2)-(part_length+part_lengtht)-3) = obs; 
for i=1:size(d,1)
 hopper(size(hopper,1)-2-(i-1),1:size(hopper,2)-(part_length+part_lengtht)-3+d(i,1)) = obs;    
end
%obstacle added to stop the 'Left' motion of the part        
hopper(size(hopper,1)-part_widtht-2-height_obs,size(hopper,2)-(part_length+part_lengtht)-3:size(hopper,2)-part_length-3) = obs; 
%obstacle added to stop the 'Upward' motion of the part
align=size(hopper,1)-part_widtht-2-height_obs;
factoryObstacleAdditionArray = hopper;
end