function [seq] = DFS_v2(part)
%  gives a possible build sequence to assemble a part
%
% A DFS expansion, checks d,r, u, l
% each check marks the node as visited
% assumes: part is an array (x,y,color), the xy position where color
% determines if the partciels will stick together (identically labelled
% parts do not connect)
format compact
clear all
clc

%Part contains the item positions and color: (y,x,color)
%part = [3 2 3;4 3 3;5 3 3;4 2 3]; %
part = ([7,6, 3;  % poind sign "#"
    9,6,3;
   6,7,3;
   7,7,3;
   8,7,3;
   9,7,3;
   10,7,3;
   7,8,3;
   9,8,3;
   6,9,3;
   7,9,3;
   8,9,3
   9,9,3;
   10,9,3;
   7,10,3;
   9,10,3;
    ]);
%part = [3 2 3;4 2 3;4 3 3]; %contains the item positions for the Part
pos = part(:,1:2);
seq = [];
visualizePart(part,seq)


%tmp_part = zeros(max(pos(:,1)),max(pos(:,2)),3); %create 3D space for 
                                                %[yx,label,visitorflag]

tmp_part = zeros(10,10,3); % take min and max of the part (columns)
                                                
for i=1:size(pos,1)
   tmp_part(pos(i,1),pos(i,2),1) = 1; %save y,x positions of items
   tmp_part(pos(i,1),pos(i,2),2) = i; %save 'label' at y,x positions of items
end


start = part(1,1:2);
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

for i=1:100  % this loop searches for ....
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
visualizePart(part,seq)

function visualizePart(part,seq)
    figure(1)
    h = plot(-part(:,2),part(:,1),'s');
    set(h, 'markersize', 20,'MarkerFaceColor','b')
    for k = 1:numel(seq)
        s = seq(k);
        ht = text(-part(k,2),part(k,1),num2str(s));
        set(ht, 'color','w')
    end
    axis([-10,10,-10,15])
    axis equal
end

end



