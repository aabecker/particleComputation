function [partColored]=labelColor(partArray)
% labelColor
% Input: a binary, 2D array part  (0= empty, 1 = filled)
% Output: a 2D array with each filled cell labeled 1 or 2 (0=empty, 1= red, 2 = blue)
%
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu, Sep 27, 2016

if nargin==0  
    partArray = [...
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0];
end

% % Thanks to Matlab Central - How to create matrix of alternating 1's and
% 0's
partSize=size(partArray); %Part Size
ArrayR=mod(1:partSize(1,1),2); % Array for row of the part
ArrayC=mod(1:partSize(1,2),2); % Array for coulumn of the part
ArrayRC=+bsxfun(@eq, ArrayC, ArrayR.'); % Matrix of zeros and ones
partColored=(1+ArrayRC).*partArray; % Final Part with labels

end