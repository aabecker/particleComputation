function NextNode = FindNextNode(Curr, TmpPart)
%Input: Current Node coordinates and TmpPart array
%Output: Next Node coordinates
%next node is selected based on whether there is a valid node available
%at DOWN, Right, UP or Left location and it has not been visited 
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu, Oct 5, 2016


if nargin==0  
    Curr=[2,2];
    TmpPart(:,:,1) = [... 
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0;
        1,1,1,1,1;
        0,1,0,1,0];
    
    TmpPart(:,:,2) = [...
        0,0,0,0,0;
        0,0,0,0,0;
        0,0,0,0,0;
        0,0,0,0,0;
        0,0,0,0,0];
    
    TmpPart(:,:,3) = [...
        0,0,0,0,0;
        0,0,0,0,0;
        0,0,0,0,0;
        0,0,0,0,0;
        0,1,0,0,0];
end
  
    TmpPartPad(:,:,1) = padarray(TmpPart(:,:,1),[1 1]);
    TmpPartPad(:,:,2) = padarray(TmpPart(:,:,2),[1 1]); 
    TmpPartPad(:,:,3) = padarray(TmpPart(:,:,3),[1 1]); 
    
    if TmpPartPad(Curr(1,1)+1+1,Curr(1,2)+1,1)==1 && TmpPartPad(Curr(1,1)+1+1,Curr(1,2)+1,3)==0  %Checks if there's a node connected at the bottom of current
        NextNode =[Curr(1,1)+1  Curr(1,2)];                                       %location and which has not beeen visited

    elseif TmpPartPad(Curr(1,1)+1,Curr(1,2)+1+1,1)==1 && TmpPartPad(Curr(1,1)+1,Curr(1,2)+1+1,3)==0 %Checks for connected node at right
        NextNode =[Curr(1,1)  Curr(1,2)+1];

    elseif TmpPartPad(Curr(1,1)-1+1,Curr(1,2)+1,1)==1 && TmpPartPad(Curr(1,1)-1+1,Curr(1,2)+1,3)==0 %Checks for connected node at top
        NextNode =[Curr(1,1)-1  Curr(1,2)];

    elseif TmpPartPad(Curr(1,1)+1,Curr(1,2)-1+1,1)==1 && TmpPartPad(Curr(1,1)+1,Curr(1,2)-1+1,3)==0  %Checks for connected node at left
        NextNode =[Curr(1,1)  Curr(1,2)-1];
    else
        NextNode=[0 0];
    end   
end
