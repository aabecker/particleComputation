function a = findnextnode(curr, tmp_part)
%Input: Current Node coordinates and tmp_part array
%Output: Next Node coordinates 'a'
%next node is selected based on whether there is a valid 'a' node available
%at DOWN, Right, UP or Left location and it has not been visited 
% Authors: Sheryl Manzoor and Aaron T. Becker, Oct 5, 2016
  
    tmp_part_pad(:,:,1) = padarray(tmp_part(:,:,1),[1 1]);
    tmp_part_pad(:,:,2) = padarray(tmp_part(:,:,2),[1 1]);
    tmp_part_pad(:,:,3) = padarray(tmp_part(:,:,3),[1 1]);
    
    if tmp_part_pad(curr(1,1)+1+1,curr(1,2)+1,1)==1 && tmp_part_pad(curr(1,1)+1+1,curr(1,2)+1,3)==0  %Checks if there's a node connected at the bottom of current
        a =[curr(1,1)+1  curr(1,2)];                                       %location and which has not beeen visited

    elseif tmp_part_pad(curr(1,1)+1,curr(1,2)+1+1,1)==1 && tmp_part_pad(curr(1,1)+1,curr(1,2)+1+1,3)==0 %Checks for connected node at right
        a =[curr(1,1)  curr(1,2)+1];

    elseif tmp_part_pad(curr(1,1)-1+1,curr(1,2)+1,1)==1 && tmp_part_pad(curr(1,1)-1+1,curr(1,2)+1,3)==0 %Checks for connected node at top
        a =[curr(1,1)-1  curr(1,2)];

    elseif tmp_part_pad(curr(1,1)+1,curr(1,2)-1+1,1)==1 && tmp_part_pad(curr(1,1)+1,curr(1,2)-1+1,3)==0  %Checks for connected node at left
        a =[curr(1,1)  curr(1,2)-1];
    else
        a=[0 0];
    end   
end
