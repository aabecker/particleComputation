function  [output,seq,tmp_part] = Depth_firstsearch(part,start)

%  gives a possible build sequence to assemble a part
%
% A DFS expansion, checks d,r, u, l
% each check marks the node as visited
% assumes: part is an array (x,y)
% Authors: Sheryl Manzoor and Aaron T. Becker, Sep 30, 2016

    
    chk = 0;
    for i=1:size(part,1)
       if start(1,1)==part(i,1) && start(1,2)==part(i,2)
            chk=1;
       end 
    end
    
    if chk==0
       start = [part(1,1) part(1,2)]; %if 'start' node is not correctly defined take first
                           %item in part as 'start'
    end

    pos = part(:,1:2);
    %start = [7 6]; %its important to mention the starting node or code gives error
    tmp_part = zeros(max(pos(:,1)),max(pos(:,2)),3); %create 3D space for 
                                                    %[yx,label,visitorflag]
    for i=1:size(pos,1)
       tmp_part(pos(i,1),pos(i,2),1) = 1; %save y,x positions of items
    end

    curr = start;
    stack = start; %push in stack
    cnt_stk = 1;   %update stack counter
    output = curr; %output current position to output
    cnt_output = 1; %increment output counter
    tmp_part(output(cnt_output,1),output(cnt_output,2),2) = cnt_output;
    tmp_part(curr(:,1),curr(:,2),3) = 1; %mark visited
     
    
    
    for i=1:400 % running for 400 iterations to find the sequence
        valid_nn = findnextnode(curr, tmp_part(:,:,:)); %next node that has not been visited
        if valid_nn(1,1)==0 && cnt_output==size(part,1)
            seq=[];
            for j=1:size(output,1)
                seq(j,:) = tmp_part(output(j,1),output(j,2),2);
            end
            break;
        elseif valid_nn(1,1)==0 && cnt_output~=size(part,1)  % reached the end e.g B; it needs to go back to A to reach S

            cnt_stk = cnt_stk - 1;
            curr = stack(cnt_stk,:);
        else
            curr = valid_nn;
            stack(cnt_stk+1,:) = curr;
            cnt_stk = cnt_stk + 1;
            output(end+1,:) = curr;
            cnt_output = cnt_output + 1;
            tmp_part(output(cnt_output,1),output(cnt_output,2),2) = cnt_output;
            tmp_part(curr(:,1),curr(:,2),3) = 1; %mark visited
        end
    end
    

%     figure(1)
%        
%         h = plot(output(:,2),-output(:,1),'s');
%         set(h, 'markersize', 30,'MarkerFaceColor','b')
%         for k = 1:numel(seq)
%             s = seq(k);
%             ht = text(output(k,2),-output(k,1),num2str(s));
%             set(ht, 'color','w')
%         end
%         axis([0,10,-15,0])
%         axis equal


end

