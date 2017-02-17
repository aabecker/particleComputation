function [factoryObstacleAdditionArray, align] = down_dir(hopper,partXY,  tileXY)
% DOWN_DIR function for the tile added through down move
% Inputs: hopper with delays, partXY and tile to be added tileXY.
% Outputs: align and sub-assembly layout
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obs = 3;
if nargin<1
   partXY = [5 5; 5 4; 5 3; 5 2; 5 1];
   tileXY = [4 2];
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
posx_obs = abs(max(partXY(:,2) - tileXY(:,2))); %Colummn position of first obstacle

partXYt = [partXY;tileXY];
part_lengtht = abs(max(partXYt(:,2) - min(partXYt(:,2))))+1; %length of part after addition of tile
part_widtht = abs(max(partXYt(:,1)) - min(partXYt(:,1)))+1; %width of part after addition of tile
hopper = horzcat(hopper, obs*ones(size(hopper,1),posx_obs));


%%%%%%%%%%%Add White space to finalize the width of the hopper%%%%%
add_width = (part_width+part_widtht)+3;
hopper = vertcat(hopper, zeros(add_width,size(hopper,2)));

                     
%%%%%%%%%%Add Right stop Obstacle%%%%%%%%%%%%%
hopper(hopper_width+1:hopper_width+part_width+1,end) = obs; %obstacle added
                        %to stop the 'Right' motion of the part and add the
                        %tile. Obstacle height is same as width of the part
                      
%%%%add zeros to the left of hopper 
if (2*part_length)+1 >= size(hopper,2)-1 
    cols2add =  (2*part_length)+1  - (size(hopper,2)-1);
    hopper = horzcat(zeros(size(hopper,1),cols2add),hopper);
    hopper(1:hopper_width,1:cols2add) = obs*ones(hopper_width,cols2add);
end

%%%%%%%%%%Add Bottom stop Obstacle%%%%%%%%%%%%%
hopper(end-1:end, 1:end) = obs; %define the bottom 
                        %obstacle to stop the "downward" motion of the part                       

%%%%%%%%%Add Left Obstacle%%%%%%%%%
d = mould(partXY,tileXY);                                   
hopper(size(hopper,1)-part_widtht-2:size(hopper,1)-2,1:size(hopper,2)-(2*part_lengtht)-1) = obs; 
for i=1:size(d,1)
 hopper(size(hopper,1)-2-(i-1),1:size(hopper,2)-(2*part_lengtht)-1+d(i,1)) = obs;    
end

hopper(size(hopper,1)-part_widtht-2,size(hopper,2)-(2*part_lengtht)-1:size(hopper,2)-part_lengtht-1) = obs; 
align=size(hopper,1)-part_widtht-2;
factoryObstacleAdditionArray = hopper;

end