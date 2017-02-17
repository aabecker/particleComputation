function [factoryLayoutArray] = concatenateFactories(all_prev, newassembly, align, hopper_size)
% CONCATENATEFACTORIES function concatenates all the sub-assembly layouts
% Inputs: 2D array of previous sub-assemblies (all-prev), 2D array of new assembly (newassembly), align and hopper size 
% Outputs: 2D array containing new and previous sub-assemblies
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        obs = 3;
        [rp, cp] = size(all_prev); %size of previous sub-assemblies
        [~, cn] = size(newassembly); %size of new sub-assembly
        
        if align ==0
            temp_new = newassembly;
        else
            num = align - (hopper_size+2)-1; %rows to be added to new subassembly 
            temp_new = vertcat(obs*ones(num,cn),newassembly);
        end
        
        [rn, ~] = size(temp_new);
        temp_prev = all_prev;
        if rn >= rp
            temp_prev = vertcat(all_prev,obs*ones(rn-rp,cp));
        else
            temp_new = vertcat(temp_new,obs*ones(rp-rn,cn));
        end
        
        factoryLayoutArray = horzcat(temp_prev,temp_new);  %All the rows are concatenated together
end