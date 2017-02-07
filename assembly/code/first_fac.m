function [partXYupdated, factoryObstacleAdditionArray] = first_fac(hopper)
% Function builds first factory for the part
%Authors: Sheryl Manzoor and Aaron T. Becker, Oct 19, 2016 
obs = 3;
if nargin<1
   
   hopper = [3 3 3 3 3 3 3 3; ...
            3 0 0 0 0 0 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 0 0 3 0 3; ...
            3 3 3 3 3 3 0 3];
   
end

hopper = vertcat(hopper, zeros(2,size(hopper,2))); %free space in the first factory; 2rows and columns equal to hopper columns 

             
                        
hopper = vertcat(hopper, obs*ones(2,size(hopper,2))); %define the bottom 
                        %obstacle to stop the "downward" motion of the part

hopper(end-3:end-2,1:end-3) = obs; 
%obstacle added to stop the 'Left' motion of the part
hopper(end-2,1:end) = obs; 

factoryObstacleAdditionArray = hopper; %Array with hopper, freespace and obstacles
partXYupdated =0;

end