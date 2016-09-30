function [partColored]=labelColor()
% labelColor
% Input: a binary, 2D array part  (0= empty, 1 = filled)
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
partColored = size(part);
for r=1:size(part,1)
    for c=1:size(part,2)
        if(mod(r,2)==0&&mod(c,2)==0)
            partColored(r,c)=part(r,c)*2; %blue color
        elseif(mod(r,2)~=0&&mod(c,2)~=0)
            partColored(r,c)=part(r,c)*2;  %blue color
        else
            partColored(r,c)=part(r,c); %red color
        end
        
    end
end

end