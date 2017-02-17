function [hopper, hopper_size] = HopperWithDelays(tileColor, numCopies,cols,pos)
% HOPPERWITHDELAYS builds hopper and delays
% Inputs: Color of tiles in the hopper, Number of copies of part, width of hopper, and position of the sub-assembly 
% Outputs: hopper with delays and hopper size
% Authors: Sheryl Manzoor <smanzoor2@uh.edu> and Aaron T. Becker, atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obs = 3; %Define Obstacle
 
if nargin<1
   tileColor = 1;
   numCopies = 12; 
   cols = 2;
   pos=3;
end


%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
rows = ceil(numCopies/cols);
hopper = obs*ones(rows+2,cols+1) ; % build boundary for hopper
hopper(2:1+rows,1:end-1) = tileColor; %fillhopper with components
hopper(2,end) = 0; %connect output shoot to tiles
if mod(numCopies,cols)~=0
    hopper(end-1,2:cols-mod(numCopies,cols)+1) = 0;  %  replace some tiles with 0s to match numCopies    
end   

%%%%%%%%%Add Delays%%%%%%%%%%%%
%delays have reptitive sequences.
%x1 is the 2D repetitive matrix that is used to create the top loops
%x2 is the 2D repetitive matrix that is used to create the bottom loops
x1 = [0 0; ...
        0 obs; ...
        0 0; ...
        0 0];
    x2 = [0 0; ...
        0 0; ...
        obs 0; ...
        0 0];

if mod(pos,2) ==0 %if even position of the hopper than it needs odd delays
    %which means top delays are one more than bottom delays.
    tot = ceil((pos-1)/2); %total number of top loops (delays) required
    
    dy = 2; %each delay is displaced by 2 positions in y direction
    dx = 2; %each delay is displaced by 2 positions in x direction
    starty = 1;
    rowss = 2+(tot*2)+3; %total number of rows required in complete delay structure
    colss = 3+ (tot+1)*2; %total number of columns required in complete delay structure
    delay_h = obs*ones(rowss,colss); %2D array that eventually contains all the delays
    for i=1:tot %placing top delays
        numy = 4 + (i-1)*dy;
        numx = 1 + (i-1)*dx;    
        delay_h(end-starty-numy:end-starty-numy+3,numx:1+numx) = x1; %filling in the top loops
    end
    dy = 2;
    dx = 2;
    for j=1:tot-1   %placing bottom delays
        numy = 3 + (j-1)*dy;
        numx = 5 + (j-1)*dx;    
        delay_h(end-numy:end-numy+3,numx:1+numx) = x2; %filling in the bottom loops
    end
    delay_h(2,end-4:end-1)=0;
    delay_h(2:7,end-1)=0;
    delay_h(7,end-2)=0;
    
    if pos>2
        %this sequence of code is to create the output shaft
        delay_h = horzcat(delay_h,obs*ones(size(delay_h,1),2));
        delay_h(end-2:end,end-1)=0;
        delay_h(end-3,5:6)=obs;
        delay_h(end-1:end,5:6)=obs;
        delay_h(end-2,7:end-1)=0;
    else
        %if the postion is 2 then output shaft is created differently.
        delay_h(end,end-2)=obs;
        delay_h(:,end-3:end-2)=[];        
    end
else
    %if the position of the hopper is odd it requires even delays which
    %means same number of top and bottom delays. But we create one more in
    %the top delays and fill in one of the bottom delay. This way we are
    %able to reuse the code for even position hopper written above.
    pos=pos+1;
    tot = ceil((pos-1)/2); 
    
    dy = 2;
    dx = 2;
    starty = 1;
    rowss = 2+(tot*2)+3;
    colss = 3+ (tot+1)*2; 
    delay_h = obs*ones(rowss,colss);
    for i=1:tot
        numy = 4 + (i-1)*dy;
        numx = 1 + (i-1)*dx;    
        delay_h(end-starty-numy:end-starty-numy+3,numx:1+numx) = x1; 
    end
    dy = 2;
    dx = 2;
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
        delay_h(3:7,end-3)=obs;
        delay_h(7,end-4)=obs;
        delay_h(end-3:end,5:1+5) = obs*(1-x2); 
        delay_h(end-1,5)=obs;
        delay_h(1,end-1)=obs;
        delay_h(:,end-5:end-2)=[];
    end
end

%the sequence of code given below combines the hopper with delay_h that
%contains the delays.
%while combining arrays they have to be matched for size. In order to match
%their size the arrays are appended with 1's on top and/or bottom depending on the requirement. 
[rd, ~] = size(delay_h);

if rd-5 >0
    hopper = vertcat(obs*ones(rd-5,size(hopper,2)),hopper);
end
[rh , ~] = size(hopper);

if rh>rd
    copy = delay_h(size(delay_h,1),1:size(delay_h,2));
    copyn = repmat(copy,rh-rd,1);
    delay_h = vertcat(delay_h,copyn);
end

hopper = horzcat(hopper,delay_h);

hopper_size = size(hopper,1);

end
%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%