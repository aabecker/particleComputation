function partColored = labelColor(part)
% labelColor
%   Input: a binary, 2D array part  (0= empty, 1 = filled)
% Output: a 2D array with each filled cell labeled 1 or 2 (0=empty, 1= red, 2 = blue)
%
% Authors: Sheryl Manzoor and Aaron T. Becker, Sep 27, 2016

if nargin==0  
    part = [...
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0];
end

% this needs to be replaced with something that labels the cells
partColored = part;

end
