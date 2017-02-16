function [partXYupdated, factoryObstacleAdditionArray, align] = right_dir(hopper,partXY,tileXY)
 %Function for the tile added through right move
%%Authors: Sheryl Manzoor and Aaron T. Becker, Oct 19, 2016


obs = 3;
if nargin<1
   
   partXY = [2 1; 2 2; 2 3; 2 4; 2 5; ...
        3 1; 3 2; 3 3; 3 4; 3 5; ...
        4 1; 4 2; 4 3; 4 4; 4 5];
   tileXY = [4 0];
   hopper = [3 3 3 3 3 3 3 3; ...
            3 0 0 0 0 0 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 0 0 3 0 3; ...
            3 3 3 3 3 3 0 3];
   
end

init_hop_width = size(hopper,1);


part_length = abs(max(partXY(:,2) - min(partXY(:,2))))+1; %length of part
part_width = abs(max(partXY(:,1)) - min(partXY(:,1)))+1; %width of part

partXYt = [partXY;tileXY];
part_lengtht = abs(max(partXYt(:,2) - min(partXYt(:,2))))+1; %length of part
part_widtht = abs(max(partXYt(:,1)) - min(partXYt(:,1)))+1; %width of part

%%%%%%%%%%%Add White space to finalize the width of the hopper%%%%%
% add_width = (3*part_width)+3+1+3;
% hopper = vertcat(hopper, zeros(add_width,size(hopper,2)));
add_width = (part_widtht+part_width)+2+3;
hopper = vertcat(hopper, zeros(add_width,size(hopper,2)));
                        
%%%%%%%%%%Add Right stop Obstacle%%%%%%%%%%%%%
hopper(init_hop_width+1:init_hop_width+part_width+1,end-2) = obs; 
                        %obstacle to stop the right motion
                        %Obstacle height is same as width of the part
                        
hopper(init_hop_width+1:init_hop_width+part_width+1,end) = obs; 

%%%%add zeros to the left of hopper 
if (2*part_length)+1 >= size(hopper,2)-6 
    cols2add =  (2*part_length)+1  - (size(hopper,2)-6);
    hopper = horzcat(zeros(size(hopper,1),cols2add),hopper);
    hopper(1:init_hop_width,1:cols2add) = obs*ones(init_hop_width,cols2add);
end

%%%%%%%%%%Add Bottom stop Obstacle for Tile%%%%%%%%%%%%%
hopper(end-1:end, 1:end) = obs; %define the bottom 
                        %obstacle to stop the "downward" motion of the tile
                        
%%%%%%%%%%Add Bottom stop Obstacle for Part%%%%%%%%%%%%%
hopper(end-3, 3:end-2) = obs; %define the bottom 
                        %obstacle to stop the "downward" motion of the part
                       
                        

                        
%%%%%%%%%Add Left Obstacle for Part%%%%%%%%%
%hopper(end-3-part_width:end-4,3) = obs; %vertical column to stop left motion 
hopper(size(hopper,1)-part_widtht-2-2:size(hopper,1)-2,1:size(hopper,2)-(2*part_lengtht)-3) = obs;
hopper(size(hopper,1)-part_widtht-2-2:size(hopper,1)-2, size(hopper,2)-(2*part_lengtht)-2) = 0;
hopper(size(hopper,1)-part_widtht-2-2:size(hopper,1)-2-2, size(hopper,2)-(2*part_lengtht)-1) = obs;

%%%%%%%%%Stop Upward Motion of Part%%%%%%%%%
%hopper(size(hopper,1)-(2*part_width)-1-1-3,3:3+part_length) = obs; 
%hopper(size(hopper,1)-part_widtht-2-2,size(hopper,2)-(2*part_lengtht)-3:size(hopper,2)-part_lengtht-3) = obs;
hopper(size(hopper,1)-part_widtht-2-2,size(hopper,2)-(2*part_lengtht)-3:size(hopper,2)-part_lengtht-2) = obs;
%obstacle added to stop the 'Upward' motion of the part


%%%%%%%%%Add Left Obstacle for Tile%%%%%%%%%
%hopper(size(hopper,1)-(2*part_width)-1-1-3:size(hopper,1)-2,1) = obs; 
%obstacle added to stop the 'Left' motion of the tile        

%%%%%%%%%Stop Upward motion of Tile%%%%%%%%%
open1 = abs(min(partXY(:,1)) - tileXY(:,1)); 
hopper(size(hopper,1)-(part_widtht)-2-2+open1,size(hopper,2)-(2*part_lengtht)-2) = obs; %stop upward motion of the tile
hopper(size(hopper,1)-(part_widtht)-2-2+open1+1,size(hopper,2)-(2*part_lengtht)-1) = 0; %define opening in the next column

%align=size(hopper,1)-(2*part_width)-1-1-3;
align = size(hopper,1)-part_widtht-2-2;

factoryObstacleAdditionArray = hopper;
partXYupdated =0;

end