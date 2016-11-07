function [partXYupdated, factoryObstacleAdditionArray, align] = left_dir(hopper,partXY,  tileXY)
 
%Function for the tile added through left move
%%Authors: Sheryl Manzoor and Aaron T. Becker, Oct 19, 2016

obs = 3;
if nargin<1
   
   partXY = [5 5; 5 4; 5 3; 5 2; 5 1];
   tileXY = [5 6];
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
height_obs = abs(max(partXY(:,1) - tileXY(:,1))); %row position of the tile w.r.t part
add_width = (2*part_width)+3+1+height_obs;
hopper = vertcat(hopper, zeros(add_width,size(hopper,2)));


%%%%%%%%%%Add Main Obstacle%%%%%%%%%%%%%%%%%%
height_obs = abs(max(partXY(:,1) - tileXY(:,1))); %row position of the tile w.r.t part
hopper(end-height_obs-2+1:end,end-2:end) = obs; %obstacle added
                        
                        
%%%%%%%%%%Add Right stop Obstacle%%%%%%%%%%%%%
hopper(init_hop_width+1:init_hop_width+part_width,end-2) = obs; 
                        %obstacle to stop the right motion
                        %Obstacle height is same as width of the part

%%%%add zeros to the left of hopper 
if (2*part_length)+1 >= size(hopper,2)-3 
    cols2add =  (2*part_length)+1  - (size(hopper,2)-3);
    hopper = horzcat(zeros(size(hopper,1),cols2add),hopper);
end

%%%%%%%%%%Add Bottom stop Obstacle%%%%%%%%%%%%%
hopper(end-1:end, 1:end) = obs; %define the bottom 
                        %obstacle to stop the "downward" motion of the part
                        
%%%%%%%%%Add Left Obstacle%%%%%%%%%
hopper(size(hopper,1)-part_width-1-2-height_obs:size(hopper,1)-2,1) = obs; 
%obstacle added to stop the 'Left' motion of the part        

hopper(size(hopper,1)-part_width-1-2-height_obs,1:part_length+1) = obs; 
%obstacle added to stop the 'Upward' motion of the part

align=size(hopper,1)-part_width-1-2-height_obs;


factoryObstacleAdditionArray = hopper;
partXYupdated =0;

end