function moveValid = checkpath(partialAssembly, location, direction)
% labelColor
%   Input: 
%   - partialAssemblya binary, 2D array partialAssembly of the current state of the part  (0= empty, 1 = filled)
%   - location  (x,y) location of the next component
%   - direction:  direction the new particle is moving
%   ('u','d','l','r')
%
% Output: moveValid = true if the first mating particle the new particle
% touches as it moves in the direction 'direction' is when it reaches
% location
%           otherwise, moveValid = false
%
% Authors: Sheryl Manzoor and Aaron T. Becker, Sep 27, 2016

if nargin<2  
    % an initial condition that should be false
    partialAssembly = [...
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0;
        0,0,0,0,0;
        0,0,0,0,0;];
    direction = l;
    location = [1,4];
    
end

% this needs to be replaced with a check
moveValid = false;


end
