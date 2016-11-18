function [factoryLayoutArray] = concat_factories(all_prev, new, align, hopper_size)
%Function concatenates all the factory layouts
%Authors: Sheryl Manzoor and Aaron T. Becker, Oct 19, 2016
        obs = 3;
        [rp, cp] = size(all_prev); %size of previous factories
        [~, cn] = size(new); %size of new factory
        
        if align ==0
            temp_new = new;
        else
            num = align - (hopper_size+2)-1; %rows to be added to new factory
            %temp_new = vertcat(zeros(num,cn),new);
            temp_new = vertcat(obs*ones(num,cn),new);
        end
        
        [rn, ~] = size(temp_new);
        temp_prev = all_prev;
        if rn >= rp
            %temp_prev = vertcat(all_prev,zeros(rn-rp,cp));
            temp_prev = vertcat(all_prev,obs*ones(rn-rp,cp));
        else
            %temp_new = vertcat(temp_new,zeros(rp-rn,cn));
            temp_new = vertcat(temp_new,obs*ones(rp-rn,cn));
        end
        
        factoryLayoutArray = horzcat(temp_prev,temp_new);
end