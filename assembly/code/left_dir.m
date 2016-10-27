function [partXYupdated, factoryObstacleAdditionArray, align] = left_dir(hopper,partXY,  tileXY)
 
%Note to self: still-to-do - tile that is to be added at the bottom
%edge of the part from left is not yet catered in the code

obs = 3;
ws = 6; %6 times the width of the part
l_obs = 4; %left obstacle size = 4 times the width of the part
if nargin<1
   
   partXY = [2 1; 2 2; 2 3; 2 4; 2 5; ...
        3 1; 3 2; 3 3; 3 4; 3 5; ...
        4 1; 4 2; 4 3; 4 4; 4 5];
   tileXY = [1 2];
   hopper = [3 3 3 3 3 3 3 3; ...
            3 0 0 0 0 0 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 0 0 3 0 3; ...
            3 3 3 3 3 3 0 3];
   
end

part_length = abs(max(partXY(:,2) - min(partXY(:,2))))+1; %length of part
part_width = abs(max(partXY(:,1)) - min(partXY(:,1)))+1; %width of part

hopper = vertcat(hopper, zeros(part_width,size(hopper,2)));
hopper(end-part_width+1:end,end-2) = obs; %obstacle to stop the right motion
                        %Obstacle height is same as width of the part

hopper = vertcat(hopper, zeros(part_width*ws,size(hopper,2))); %define white space 
                        %beneath the hopper for motion of the part
                        
%%%%add zeros to the left of hopper                       
if (3*part_length - size(hopper,2))>0
   cols2add = ceil(3*part_length - size(hopper,2));
   hopper = horzcat(zeros(size(hopper,1),cols2add),hopper); 
end

hopper = vertcat(hopper, obs*ones(2,size(hopper,2))); %define the bottom 
                        %obstacle to stop the "downward" motion of the part

hopper(size(hopper,1)-(l_obs*part_width)-1:size(hopper,1)-2,1) = obs; 
%obstacle added to stop the 'Left' motion of the part, Obstacle height is
%three times the width of the part

hopper(size(hopper,1)-(l_obs*part_width)-1,1:part_length+1) = obs; 
%obstacle added to stop the 'Upward' motion of the part, Obstacle height is
%the same as the width of the part
align = size(hopper,1)-(l_obs*part_width)-1;

posy_obs = abs(max(partXY(:,1) - tileXY(:,1))); %row position of the obstacle

hopper(end-posy_obs-2+1:end,end-1) = obs; %obstacle added
                        %to stop the 'Right' motion of the part and add the
                        %tile. Obstacle height is same as width of the part

factoryObstacleAdditionArray = hopper;
partXYupdated =0;

end