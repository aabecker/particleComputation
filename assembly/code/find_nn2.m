function a = find_nn2(curr, tmp_part)
   
    a=[];
    if tmp_part(curr(1,1)+1,curr(1,2),1)==1 && tmp_part(curr(1,1)+1,curr(1,2),3)==0
        a =[curr(1,1)+1  curr(1,2)];
        
    elseif tmp_part(curr(1,1),curr(1,2)+1,1)==1 && tmp_part(curr(1,1),curr(1,2)+1,3)==0
        a =[curr(1,1)  curr(1,2)+1];
        
    elseif tmp_part(curr(1,1)-1,curr(1,2),1)==1 && tmp_part(curr(1,1)-1,curr(1,2),3)==0
        a =[curr(1,1)-1  curr(1,2)];
        
    elseif tmp_part(curr(1,1),curr(1,2)-1,1)==1 && tmp_part(curr(1,1),curr(1,2)-1,3)==0
        a =[curr(1,1)  curr(1,2)-1];
    else
        a=[0 0];
    end
end
%{
y2 = curr(1,1);
    y1 = curr(1,1) - 1;
    y3 = curr(1,1) + 1;
    
    x2 = curr(1,2);
    x1 = curr(1,2) - 1;
    x3 = curr(1,2) + 1;
    
    %b = [y1 x1; y1 x2; y1 x3; y2 x1; y2 x3; y3 x1; y3 x2; y3 x3];
    b = [y1 x2; y2 x1; y2 x3; y3 x2];
    a=[];
    tmp=[];
    for i=1:size(b,1)
        if tmp_part(b(i,1),b(i,2),1) == 1 && tmp_part(b(i,1),b(i,2),3) == 0
           tmp(end+1,:) = b(i,:);
        end
    end
    
    if size(tmp,1) == 0
        a = [0 0];
    
    elseif size(tmp,1) == 1
        a = tmp;
        
    else
        
        if 
               
        end        
    end 
end

%}