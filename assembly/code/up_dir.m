function [partXYupdated, factoryObstacleAdditionArray, align] = up_dir(hopper,partXY,  tileXY)
 %Function for the tile added through up move
%%Authors: Sheryl Manzoor and Aaron T. Becker, Oct 19, 2016

obs = 3;
if nargin<1
   
   partXY = [2 1; 2 2; 2 3; 2 4; 2 5; ...
        3 1; 3 2; 3 3; 3 4; 3 5];
   tileXY = [4 5];
   hopper = [3 3 3 3 3 3 3 3; ...
            3 0 0 0 0 0 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 0 0 3 0 3; ...
            3 3 3 3 3 3 0 3];
   
end

init_hop_width = size(hopper,1);
% init_hop_length = size(hopper,2);

part_length = abs(max(partXY(:,2) - min(partXY(:,2))))+1; %length of part
part_width = abs(max(partXY(:,1)) - min(partXY(:,1)))+1; %width of part

%%%%%%%%%%%Add White space to finalize the width of the hopper%%%%%
% height_obs = abs(max(partXY(:,1) - tileXY(:,1))); %row position of the tile w.r.t part
add_width = (2*part_width)+3+1+3;
hopper = vertcat(hopper, zeros(add_width,size(hopper,2)));
                        
                        
%%%%%%%%%%Add Right stop Obstacle%%%%%%%%%%%%%
hopper(init_hop_width+1:init_hop_width+part_width,end-2) = obs; 
                        %obstacle to stop the right motion
                        %Obstacle height is same as width of the part

%%%%add zeros to the left of hopper 
if (2*part_length)+1 >= size(hopper,2)-3 
    cols2add =  (2*part_length)+1  - (size(hopper,2)-3);
    hopper = horzcat(zeros(size(hopper,1),cols2add),hopper);
end

%%%%%%%%%%Add Bottom stop Obstacle for Tile%%%%%%%%%%%%%
hopper(end-1:end, 1:end) = obs; %define the bottom 
                        %obstacle to stop the "downward" motion of the tile
                        
%%%%%%%%%%Add Bottom stop Obstacle for Part%%%%%%%%%%%%%
hopper(end-3, 1:end-2) = obs; %define the bottom 
                        %obstacle to stop the "downward" motion of the part
open1 = abs(min(partXY(:,2)) - tileXY(:,2)); 
hopper(end-3,open1+1+1) = 0;
hopper(end-2,open1+1) = obs;
                        
%%%%%%%%%Add Left Obstacle for Part%%%%%%%%%
hopper(size(hopper,1)-part_width-1-2-3:size(hopper,1)-2,1) = obs; 
%obstacle added to stop the 'Left' motion of the part        

hopper(size(hopper,1)-part_width-1-2-3,1:part_length+1) = obs; 
%obstacle added to stop the 'Upward' motion of the part

align=size(hopper,1)-part_width-1-2-3;

factoryObstacleAdditionArray = hopper;
partXYupdated =0;

end