function [partXYupdated, factoryObstacleAdditionArray, align] = right_dir(hopper,partXY,  tileXY)
 
%Note to self: still-to-do - tile that is to be added at the right most
%edge from top of the part is not yet catered in the code

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

part_length = abs(max(partXY(:,2) - min(partXY(:,2))))+1;
part_width = abs(max(partXY(:,1)) - min(partXY(:,1)))+1; %width of part

hopper = vertcat(hopper, zeros(part_width,size(hopper,2)));
hopper(end-part_width+1:end,end-2) = obs; %obstacle to stop the right motion
                        %Obstacle height is same as width of the part


hopper = vertcat(hopper, zeros(part_width*5,size(hopper,2))); %define white space 
                        %beneath the hopper for motion of the part

%%%%add zeros to the left of hopper                       
if (2.5*part_length - size(hopper,2))>0
   cols2add = ceil(2.5*part_length - size(hopper,2));
   hopper = horzcat(zeros(size(hopper,1),cols2add),hopper); 
end                        
                        
hopper = vertcat(hopper, obs*ones(2,size(hopper,2))); %define the bottom 
                        %obstacle to stop the "downward" motion of tile

%%%%define bottom obstacle for the part%%%start%%%%
hopper(end-3,3:end-2) = obs; %bottom row
hopper(end-3-part_width:end-4,3) = obs; %vertical column to stop left motion
%%%%%define bottom obstacle for the part%%%ends%%%%%

hopper(end-5-(2*part_width),3:part_length+3) = obs; %stop upward motion of the part
align = size(hopper,1)-5-(2*part_width);

% hopper(end-3-(3*part_width),1:part_length) = obs; 
% %obstacle added to stop the 'Upward' motion of the part, Obstacle height is
% %the same as the width of the part


open1 = abs(min(partXY(:,1)) - tileXY(:,1)); 
hopper(end-5-(2*part_width)+open1,2) = obs; %stop upward motion of the tile
% align = size(hopper,1)-5-(2*part_width)+open1;


hopper(end-5-(2*part_width)+open1:end-2,1) = obs; 
%obstacle added to stop the 'Left' motion of the tile, Obstacle height is
%three times the width of the part

%hopper(end-3-(3*part_width),1:part_length) = obs; 
%obstacle added to stop the 'Upward' motion of the tile, Obstacle height is
%the same as the width of the tile

factoryObstacleAdditionArray = hopper;
partXYupdated =0;

end