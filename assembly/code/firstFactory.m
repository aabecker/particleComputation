function factoryObstacleAdditionArray = firstFactory(hopper)
% FIRSTFACTORY function builds first factory for the part
% Takes hopper as an input and concatenates freespace and obstacles with it
%Authors: Sheryl Manzoor, smanzoor2@uh.edu and Aaron T. Becker, atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obs = 3; %define obstacle
if nargin<1
   
   hopper = [3 3 3 3 3 3 3 3; ...
            3 0 0 0 0 0 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 1 1 3 0 3; ...
            3 1 1 0 0 3 0 3; ...
            3 3 3 3 3 3 0 3];
   
end

hopper = vertcat(hopper, zeros(1,size(hopper,2))); %free space in the first factory                                     
hopper = vertcat(hopper, obs*ones(1,size(hopper,2))); %define the bottom 
                        %obstacle to stop the "downward" motion of the part
hopper(end-1,1:end-3) = obs; 
%obstacle added to stop the 'Left' motion of the part 
factoryObstacleAdditionArray = hopper; %Array with hopper, freespace and obstacles

end