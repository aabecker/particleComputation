function  [Output,seq,tmpPart] = DepthFirstSearch(part,start)

%  gives a possible build sequence to assemble a part
%
% A DFS expansion, checks d, r, u, l
% each check marks the node as visited
% assumes: part is an array (x,y)
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu, Sep 30, 2016
if nargin==0
    part=[5,2;6,2;7,2;8,2;9,2;10,2;5,3;5,4;6,4;7,4;8,4;9,4;10,4;5,5;10,5;5,6;7,6;8,6;10,6;5,7;7,7;10,7;5,8;7,8;
        8,8;9,8;10,8;10,9;10,10;10,11;10,12;9,10;9,12;8,10;8,12;7,10;7,12;6,10;6,12;5,10;5,11;5,12];
    start=[5,2];
end

    

    pos = part(:,1:2);
    tmpPart = zeros(max(pos(:,1)),max(pos(:,2)),3); %create 3D space for 
                                                    %[yx,label,visitorflag]
    for i=1:size(pos,1)
       tmpPart(pos(i,1),pos(i,2),1) = 1; %save y,x positions of items 
    end

    curr = start;
    stack = start; %push in stack
    countStack = 1;   %update stack counter
    Output = curr; %output current position to output
    countOutput = 1; %increment output counter
    tmpPart(Output(countOutput,1),Output(countOutput,2),2) = countOutput;
    tmpPart(curr(:,1),curr(:,2),3) = 1; %mark visited
     
    
    
    for i=1:400 % running for 400 iterations to find the sequence
        validNN = FindNextNode(curr, tmpPart(:,:,:)); %next node that has not been visited
        if validNN(1,1)==0 && countOutput==size(part,1)
            seq=[];
            for j=1:size(Output,1)
                seq(j,:) = tmpPart(Output(j,1),Output(j,2),2);
            end
            break;
        elseif validNN(1,1)==0 && countOutput~=size(part,1)  % reached the end e.g B; it needs to go back to A to reach S

            countStack = countStack - 1;
            curr = stack(countStack,:);
        else
            curr = validNN;
            stack(countStack+1,:) = curr;
            countStack = countStack + 1;
            Output(end+1,:) = curr;
            countOutput = countOutput + 1;
            tmpPart(Output(countOutput,1),Output(countOutput,2),2) = countOutput;
            tmpPart(curr(:,1),curr(:,2),3) = 1; %mark visited
        end
    end
    


end

