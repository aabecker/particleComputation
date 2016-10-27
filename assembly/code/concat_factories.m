function [factoryLayoutArray] = concat_factories(all_prev, new, align, hopper_size)

        [rp cp] = size(all_prev);
        [rn cn] = size(new);
        
        num = align - (hopper_size+2)-1;
        
        temp_new = vertcat(zeros(num,cn),new);
        [rn cn] = size(temp_new);
        
        temp_prev = vertcat(all_prev,zeros(rn-rp,cp));
        
        factoryLayoutArray = horzcat(temp_prev,temp_new);

%{
    %if all_prev == 0 && align==0
    if align==0
        %all_prev = new;
           factoryLayoutArray = horzcat(all_prev,new);
    
    %elseif all_prev ~= 0 && align==0
     %   factoryLayoutArray = horzcat(all_prev,new);
    else
        [rp cp] = size(all_prev);
        [rn cn] = size(new);
        
        num = align - (hopper_size+2)-1;
        
        temp_new = vertcat(zeros(num,cn),new);
        [rn cn] = size(temp_new);
        
        temp_prev = vertcat(all_prev,zeros(rn-rp,cp));
        
        factoryLayoutArray = horzcat(temp_prev,temp_new);
        
    end
    
%}
end