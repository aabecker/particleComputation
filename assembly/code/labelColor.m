function [partColored]=labelColor(partArray)
% labelColor
% Input: a binary, 2D array part  (0= empty, 1 = filled)
% Output: a 2D array with each filled cell labeled 1 or 2 (0=empty, 1= red, 2 = blue)
%
% Authors: Sheryl Manzoor and Aaron T. Becker, Sep 27, 2016

if nargin==0  
    partArray = [...
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0];
end

% Thanks to:...
part_size=size(partArray); %Part Size
A=mod(1:part_size(1,1),2); % Array for row of the part
B=mod(1:part_size(1,2),2); % Array for coulumn of the part
C=+bsxfun(@eq, B, A.'); % Matrix of zeros and ones
partColored=(1+C).*partArray; % Final Part with labels

end