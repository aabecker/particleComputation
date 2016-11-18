function [hopper, hopper_size] = hopper_dl(tileColor, numCopies,cols,pos)
% 
% %This function defines hopper
% 
 obs = 3;
% 
if nargin<1
   tileColor = 1;
   numCopies = 12; 
   cols = 4;
   pos=3;
end



%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
rows = ceil(numCopies/cols);
hopper = obs*ones(rows+2,cols+2) ; % build boundary for hopper
hopper(2:1+rows,2:1+cols) = tileColor; %fillhopper with components
%hopper(2:end,end-1) = 0; % build output shoot for hopper
hopper(2,end) = 0; %connect output shoot to tiles
if mod(numCopies,cols)~=0
    hopper(end-1,2:cols-mod(numCopies,cols)+1) = 0;
end
%  replace some tiles with 0s to match numCopies    

x1 = [0 0; ...
        0 obs; ...
        0 0; ...
        0 0];
    x2 = [0 0; ...
        0 0; ...
        obs 0; ...
        0 0];

if mod(pos,2) ==0
    tot = ceil((pos-1)/2);
    
    dy = 2;
    dx = 2;
    starty = 1;
    rows = 2+(tot*2)+3;
    cols = 3+ (tot+1)*2; 
    delay_h = obs*ones(rows,cols);
    for i=1:tot
        numy = 4 + (i-1)*dy;
        numx = 1 + (i-1)*dx;    
        delay_h(end-starty-numy:end-starty-numy+3,numx:1+numx) = x1; 
    end
    dy = 2;
    dx = 2;
%     starty = 0;
    for j=1:tot-1
        numy = 3 + (j-1)*dy;
        numx = 5 + (j-1)*dx;    
        delay_h(end-numy:end-numy+3,numx:1+numx) = x2; 
    end
    delay_h(2,end-4:end-1)=0;
    delay_h(2:7,end-1)=0;
    delay_h(7,end-2)=0;
    
    if pos>2
        delay_h = horzcat(delay_h,obs*ones(size(delay_h,1),2));
        %delay_h(1:end,end-1)=0;
        delay_h(end-2:end,end-1)=0;
        delay_h(end-3,5:6)=obs;
        delay_h(end-1:end,5:6)=obs;
        delay_h(end-2,7:end-1)=0;
    else
        delay_h(end,end-2)=obs;
    end
else
    pos=pos+1;
    tot = ceil((pos-1)/2);
    
    dy = 2;
    dx = 2;
    starty = 1;
    rows = 2+(tot*2)+3;
    cols = 3+ (tot+1)*2; 
    delay_h = obs*ones(rows,cols);
    for i=1:tot
        numy = 4 + (i-1)*dy;
        numx = 1 + (i-1)*dx;    
        delay_h(end-starty-numy:end-starty-numy+3,numx:1+numx) = x1; 
    end
    dy = 2;
    dx = 2;
%     starty = 0;
    for j=1:tot-1
        numy = 3 + (j-1)*dy;
        numx = 5 + (j-1)*dx;    
        delay_h(end-numy:end-numy+3,numx:1+numx) = x2; 
    end
    delay_h(2,end-4:end-1)=0;
    delay_h(2:7,end-1)=0;
    delay_h(7,end-2)=0;
    delay_h = horzcat(delay_h,obs*ones(size(delay_h,1),2));
    delay_h(1:end,end-1)=0;
    
    if pos>4
        
        delay_h(end-3,5:6)=obs;
        delay_h(end-1:end,5:6)=obs;
        delay_h(end-2,5:end-2)=obs;
        delay_h(end-5,7:8)=obs;
        delay_h(end-4,7:end-1)=0;
        delay_h(end-3,7:end-2)=obs;
        delay_h(1:end-5,end-1)=obs;
    else
        delay_h(2,end-2)=0;
        %delay_h(2,end-4:end-1)=obs;
        delay_h(3:7,end-3)=obs;
        delay_h(7,end-4)=obs;
        delay_h(end-3:end,5:1+5) = obs*(1-x2); 
        delay_h(end-1,5)=obs;
        delay_h(1,end-1)=obs;
    end
end

[rh , ~] = size(hopper);
[rd , ~] = size(delay_h);

if rd-5 >0
    hopper = vertcat(obs*ones(rd-5,size(hopper,2)),hopper);
end
if rh-5 >0
    delay_h = vertcat(delay_h,obs*ones(rh-5,size(delay_h,2)));
end

hopper = horzcat(hopper,delay_h);
%hopper(1:end,end-1) = 0;

hopper_size = size(hopper,1);

end
%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%