clear all
clc


part = [3 2 3;4 3 3;5 3 3;4 2 3]; %contains the item positions for the Part
%part = [3 2 3;4 2 3;4 3 3]; %contains the item positions for the Part
pos = part(:,1:2);

%tmp_part = zeros(max(pos(:,1)),max(pos(:,2)),3); %create 3D space for 
                                                %[yx,label,visitorflag]

tmp_part = zeros(10,10,3);
                                                
for i=1:size(pos,1)
   tmp_part(pos(i,1),pos(i,2),1) = 1; %save y,x positions of items
   tmp_part(pos(i,1),pos(i,2),2) = i; %save 'label' at y,x positions of items
end


start = [4 2];
%tmp_part(3,2,3)=1;
%{
for i=1:size(part,1)
   part2(i,:) = horzcat(part(i,:),i,0); % [y,x,color,num,label,visitorflag]
end
%}
curr = start;

stack = start; %push in stack
cnt_stk = 1;   %update stack counter
output = curr; %output current position to output
cnt_output = 1; %increment output counter

tmp_part(curr(:,1),curr(:,2),3) = 1; %mark visited


for i=1:100
    valid_nn = find_nn2(curr, tmp_part(:,:,:)); %next node that has not been visited
    if valid_nn(1,1)==0 && cnt_output==size(part,1)
        seq=[];
        for j=1:size(output,1)
            seq(j,:) = tmp_part(output(j,1),output(j,2),2);
        end
        break;
    elseif valid_nn(1,1)==0 && cnt_output~=size(part,1)
        
        cnt_stk = cnt_stk - 1;
        curr = stack(cnt_stk,:);
        
    else
        curr = valid_nn;
        stack(cnt_stk+1,:) = curr;
        cnt_stk = cnt_stk + 1;
        output(end+1,:) = curr;
        cnt_output = cnt_output + 1;
        tmp_part(curr(:,1),curr(:,2),3) = 1; %mark visited
    end
    

end






