function a = find_nn3(curr, tmp_part)
   
%next node is selected based on whether there is a valid a node available
%at DOWN, Right, UP or Left location and it has not been visited 
    a=[];
    [r c] = size(tmp_part(:,:,1));
    
    %{
    valyp = curr(1,1)+1;
    valxp = curr(1,2)+1;
    if (curr(1,1)+1) < r
        valyp = curr(1,1)+1;
    else
        valyp = curr(1,1);
    end
    %}
        
    
    if curr(1,1) < r && curr(1,1) > 1 && curr(1,2) < c && curr(1,2) > 1 
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
        
    elseif curr(1,1) == 1 && curr(1,2) ~= 1 && curr(1,2) ~= c
        if tmp_part(curr(1,1)+1,curr(1,2),1)==1 && tmp_part(curr(1,1)+1,curr(1,2),3)==0
            a =[curr(1,1)+1  curr(1,2)];

        elseif tmp_part(curr(1,1),curr(1,2)+1,1)==1 && tmp_part(curr(1,1),curr(1,2)+1,3)==0
            a =[curr(1,1)  curr(1,2)+1];

%         elseif tmp_part(curr(1,1)-1,curr(1,2),1)==1 && tmp_part(curr(1,1)-1,curr(1,2),3)==0
%             a =[curr(1,1)-1  curr(1,2)];

        elseif tmp_part(curr(1,1),curr(1,2)-1,1)==1 && tmp_part(curr(1,1),curr(1,2)-1,3)==0
            a =[curr(1,1)  curr(1,2)-1];
        else
            a=[0 0];
        end
        
    elseif curr(1,1) == r && curr(1,2) ~= 1 && curr(1,2) ~= c
%         if tmp_part(curr(1,1)+1,curr(1,2),1)==1 && tmp_part(curr(1,1)+1,curr(1,2),3)==0
%             a =[curr(1,1)+1  curr(1,2)];

        if tmp_part(curr(1,1),curr(1,2)+1,1)==1 && tmp_part(curr(1,1),curr(1,2)+1,3)==0
            a =[curr(1,1)  curr(1,2)+1];

        elseif tmp_part(curr(1,1)-1,curr(1,2),1)==1 && tmp_part(curr(1,1)-1,curr(1,2),3)==0
            a =[curr(1,1)-1  curr(1,2)];

        elseif tmp_part(curr(1,1),curr(1,2)-1,1)==1 && tmp_part(curr(1,1),curr(1,2)-1,3)==0
            a =[curr(1,1)  curr(1,2)-1];
        else
            a=[0 0];
        end
        
    elseif curr(1,2) == 1 && curr(1,1) ~= 1 && curr(1,1) ~= r
        if tmp_part(curr(1,1)+1,curr(1,2),1)==1 && tmp_part(curr(1,1)+1,curr(1,2),3)==0
            a =[curr(1,1)+1  curr(1,2)];

        elseif tmp_part(curr(1,1),curr(1,2)+1,1)==1 && tmp_part(curr(1,1),curr(1,2)+1,3)==0
            a =[curr(1,1)  curr(1,2)+1];

        elseif tmp_part(curr(1,1)-1,curr(1,2),1)==1 && tmp_part(curr(1,1)-1,curr(1,2),3)==0
            a =[curr(1,1)-1  curr(1,2)];

%         elseif tmp_part(curr(1,1),curr(1,2)-1,1)==1 && tmp_part(curr(1,1),curr(1,2)-1,3)==0
%             a =[curr(1,1)  curr(1,2)-1];
        else
            a=[0 0];
        end
    
    elseif curr(1,2) == c && curr(1,1) ~= 1 && curr(1,1) ~= r
        if tmp_part(curr(1,1)+1,curr(1,2),1)==1 && tmp_part(curr(1,1)+1,curr(1,2),3)==0
            a =[curr(1,1)+1  curr(1,2)];

%         elseif tmp_part(curr(1,1),curr(1,2)+1,1)==1 && tmp_part(curr(1,1),curr(1,2)+1,3)==0
%             a =[curr(1,1)  curr(1,2)+1];

        elseif tmp_part(curr(1,1)-1,curr(1,2),1)==1 && tmp_part(curr(1,1)-1,curr(1,2),3)==0
            a =[curr(1,1)-1  curr(1,2)];

        elseif tmp_part(curr(1,1),curr(1,2)-1,1)==1 && tmp_part(curr(1,1),curr(1,2)-1,3)==0
            a =[curr(1,1)  curr(1,2)-1];
        else
            a=[0 0];
        end
        
    
    elseif curr(1,1) == 1 && curr(1,2) == 1
        if tmp_part(curr(1,1)+1,curr(1,2),1)==1 && tmp_part(curr(1,1)+1,curr(1,2),3)==0
            a =[curr(1,1)+1  curr(1,2)];

        elseif tmp_part(curr(1,1),curr(1,2)+1,1)==1 && tmp_part(curr(1,1),curr(1,2)+1,3)==0
            a =[curr(1,1)  curr(1,2)+1];

        else
            a=[0 0];
        end
        
    elseif curr(1,1) == 1 && curr(1,2) == c
        if tmp_part(curr(1,1)+1,curr(1,2),1)==1 && tmp_part(curr(1,1)+1,curr(1,2),3)==0
            a =[curr(1,1)+1  curr(1,2)];

        elseif tmp_part(curr(1,1),curr(1,2)-1,1)==1 && tmp_part(curr(1,1),curr(1,2)-1,3)==0
            a =[curr(1,1)  curr(1,2)-1];
        else
            a=[0 0];
        end
    elseif curr(1,1) == r && curr(1,2) == 1
        
        if tmp_part(curr(1,1),curr(1,2)+1,1)==1 && tmp_part(curr(1,1),curr(1,2)+1,3)==0
            a =[curr(1,1)  curr(1,2)+1];

        elseif tmp_part(curr(1,1)-1,curr(1,2),1)==1 && tmp_part(curr(1,1)-1,curr(1,2),3)==0
            a =[curr(1,1)-1  curr(1,2)];

        else
            a=[0 0];
        end
    elseif curr(1,1) == r && curr(1,2) == c

        if tmp_part(curr(1,1)-1,curr(1,2),1)==1 && tmp_part(curr(1,1)-1,curr(1,2),3)==0
            a =[curr(1,1)-1  curr(1,2)];

        elseif tmp_part(curr(1,1),curr(1,2)-1,1)==1 && tmp_part(curr(1,1),curr(1,2)-1,3)==0
            a =[curr(1,1)  curr(1,2)-1];
        else
            a=[0 0];
        end
    end
end
