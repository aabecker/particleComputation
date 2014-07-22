function binaryCounter
% a binary counter with 3 bits
%  Aaron Becker
%
% TODO: 1.) reverse b0 on the rebound
%   2.) wrap the inputs to left (we need a right move to initialize the fan
%   out gates.
%   3.) take a picture
%

global G MAKE_MOVIE RobotPts
%close all; clc;
clear all
clc
format compact
MAKE_MOVIE = false;
G.fig = figure(1);
set(G.fig,'position',[22 49 788 948]);
G.numCommands = 0;
G.totalMoves = 0;
if MAKE_MOVIE
    set(G.fig ,'Name','Massive Control','color',[1,1,1]); %#ok<UNRCH>
else
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Massive Control');
end


G.w = 15;
G.h = 11;
G.gapH = 17;
woff = 15+8;

b2 = G.w*0-3+woff;
b1 = G.w*1+woff;
b0 = G.w*2+woff;
yoff = -6;

G.obstacle_pos = ones((G.h+ G.gapH)*4+4,G.w*3+woff+0);
half = floor(G.w/2);

%place blocks:
h1 = G.h*3 + G.gapH*4+yoff;
h2 = G.h*2+ G.gapH*3+yoff;
h3 = G.h*1+ G.gapH*2+yoff;
h4 = G.h*0+ G.gapH*1+yoff;
% LEVEL 1
f0w = G.w*2+woff;
G.obstacle_pos( h1+(1:G.h),f0w +(1:G.w)) =  resizen(unSAFEddFANOUT());

p1i = [f0w+[2,4,7]];

% LEVEL 2
f1w = G.w*0+half+woff;
f2w = G.w*1+half+woff;
G.obstacle_pos( h2+(1:G.h),f1w +(1:G.w)) = resizen(unSAFEddFANOUT());
G.obstacle_pos( h2+(1:G.h),f2w +(1:G.w)) = resizen(unSAFEddFANOUT());

b0Lev1 = f2w+G.w+2;
d2s = [b2,b2+3,b0Lev1, b0Lev1+3];
d2e = [b2,b2+3, b0Lev1, b0Lev1+3];
G.obstacle_pos = insertDelay(G.obstacle_pos,d2s,d2e,h2+ G.h,h2);

p2i = [f1w+8,f2w+8,f1w+3,f1w+5,         f2w+3, f2w+5]; %[f1w+[2,4,7],f2w+[2,4,7]];
p2o = [f1w+[3,8,10,12],f2w+[3,8,10,12]];
%      b1,b1,b1',b1'      b0,b0,b0',b0'

% LEVEL 3
c0w = G.w*0 +half+woff;
s0w = G.w*1 +half+woff;
G.obstacle_pos( h3+(1:G.h),c0w+(1:G.w)) = resizen(unSAFEddCarry());% Carry (an AND gate)
G.obstacle_pos( h3+(1:G.h),s0w+(1:G.w)) = resizen(ddXORgate );% Summer

d3s = [b0Lev1, b0Lev1+3];
d3e = [b0Lev1, b0Lev1+3];
G.obstacle_pos = insertDelay(G.obstacle_pos,[b2,b2+3,d3s],[b2,b2+3,d3e],h3+ G.h,h3);

p3i = [c0w+4, s0w+5, c0w+6, s0w+7, c0w+8,s0w+9,c0w+10,s0w+11 ]; %[f1w+[2,4,7],f2w+[2,4,7]];
p3o = [b2,b2+3,c0w+[4,6,8], s0w+[7,9,10]];

% LEVEL 4

s1w = G.w*0+woff;
%ones used as supply
o0 = s1w+13;
o1 = c0w+15;
o2 = s0w+14;

p1o = [o0-1,o1,b1,b1+3, f0w+[3,10]];

G.obstacle_pos( h4+(1:G.h),s1w +(1:G.w)) = resizen(ddXORgate );% Summer

d4s = [o1, o2, b1,b1+3, b0Lev1, b0Lev1+3];
d4e = [o1, o2, b1,b1+3, b0Lev1, b0Lev1+3];
G.obstacle_pos = insertDelay(G.obstacle_pos,d4s,d4e,h4+ G.h,h4);


p4i = [s1w+5,s1w+7, s1w+9,s1w+11, o1, b1,b1+3, o2 ];


d1s = [b2,b2+3,o0-1,o1,b1,b1+3];
d1e = [b2,b2+3,o0-1,o1,b1,b1+3];
G.obstacle_pos = insertDelay(G.obstacle_pos,d1s,d1e,h1+ G.h,h1);

% outs: b2,b2',o0,

%%% Connections (obps,ptsS,ptsE,hS, hE)
 
G.obstacle_pos = makeConnectors(G.obstacle_pos,p1o,p2i,h1,h2+G.h);
G.obstacle_pos = makeConnectors(G.obstacle_pos,[f0w+8,f0w+12],[b0Lev1+3,b0Lev1],h1,h2+G.h);
G.obstacle_pos = insertDelay(G.obstacle_pos,[b2,b2+3],[b2,b2+3],h1,h2+G.h);
G.obstacle_pos = makeConnectors(G.obstacle_pos,p2o,p3i,h2,h3+G.h);
G.obstacle_pos = insertDelay(G.obstacle_pos,[d2s],[d2e],h2,h3+G.h);
G.obstacle_pos = makeConnectors(G.obstacle_pos,p3o,p4i,h3,h4+G.h);
G.obstacle_pos = insertDelay(G.obstacle_pos,[d3s],[d3e],h3,h4+G.h);
%Loop output to top
ptsS = [s1w+7,s1w+9,s1w+10,  o1, o2,    b1,b1+3, b0Lev1, b0Lev1+3];
%[b2,b2+3,o0-1,o1,b1,b1+3]
%f0w+[2,4,7]                                       %Invert b0
ptsE = [b2,    b2+3, o0-1,     o1, f0w+8, b1,b1+3, f0w+3,  f0w+5];
G.obstacle_pos = wrapInputsToTop(G.obstacle_pos,ptsS,ptsE,h4, h1+G.h);



    

RobotPts= [
    s1w+9,              h4,1,1,1,1  %b2
    b1+3,               h4,2,2,1,1 %b1
    b0Lev1+3,           h4,3,3,1,1 %b0
    o0-3,               h4,4,4,1,1  %o2
    o1,                 h4,5,5,1,1 %o1
    o2,                 h4,6,6,1,1 %o0
    woff+G.w*2+13,      h1+7,7,7,2,1 %Fan-out slider
    woff+G.w*1+13+half, h2+7,8,7,2,1  %Fan-out slider
    woff+G.w*0+13+half, h2+7,9,7,2,1]; %Fan-out slider

%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.
G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);
numRobots = size(RobotPts,1);

clf

G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    0.3,0.3,0.3;
    ];

colormap(G.colormap(1:numel(unique(G.obstacle_pos)),:));
G.axis=imagesc(G.obstacle_pos);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');

% Add annotations
txtop = {'color','r','Interpreter','latex','fontsize',12};
txth = 8;
text(29,txth,'$\rm{b}_2$',txtop{:})
text(31,txth,'$\overline{\rm{b}}_2$',txtop{:})
text(32.5,txth,'1',txtop{:})

text(37.5,txth,'$\rm{b}_1$',txtop{:})
text(40.5,txth,'$\overline{\rm{b}}_1$',txtop{:})
text(44.5,txth,'1',txtop{:})

text(58.5,txth-1.5,'1',txtop{:})
text(61,txth-1.5,'$\rm{b}_0$',txtop{:})
text(64,txth-1.5,'$\overline{\rm{b}}_0$',txtop{:})


%set(G.axis,'edgealpha',.08)
axis equal
 set(gca,'Position',[0 0 1 1])
%axis tight
hold on

%end
G.hRobotsPast11 = zeros(1, numRobots);
G.hRobotsPast10 = zeros(1, numRobots);
G.hRobotsPast9 = zeros(1, numRobots);
G.hRobotsPast8 = zeros(1, numRobots);
G.hRobotsPast7 = zeros(1, numRobots);
G.hRobotsPast6 = zeros(1, numRobots);
G.hRobotsPast5 = zeros(1, numRobots);
G.hRobotsPast4 = zeros(1, numRobots);
G.hRobotsPast3 = zeros(1, numRobots);
G.hRobotsPast2 = zeros(1, numRobots);
G.hRobotsPast = zeros(1, numRobots);
G.hRobots = zeros(1, numRobots);
colors = jet(numel(unique(RobotPts(:,4)))+1);
%colors = [1,0,0;0,0,1; 1,.5,1; .5,0,.5;];


for hi = 1: numRobots
    G.hRobotsPast11(hi) =  createRobotPath( RobotPts(hi,:), 0.20);
    G.hRobotsPast10(hi) =  createRobotPath( RobotPts(hi,:), 0.25);
    G.hRobotsPast9(hi) =  createRobotPath( RobotPts(hi,:), 0.3);
    G.hRobotsPast8(hi) =  createRobotPath( RobotPts(hi,:), 0.35);
    G.hRobotsPast7(hi) =  createRobotPath( RobotPts(hi,:), 0.4);
    G.hRobotsPast6(hi) =  createRobotPath( RobotPts(hi,:), 0.45);
    G.hRobotsPast5(hi) =  createRobotPath( RobotPts(hi,:), 0.5);
    G.hRobotsPast4(hi) =  createRobotPath( RobotPts(hi,:), 0.55);
    G.hRobotsPast3(hi) =  createRobotPath( RobotPts(hi,:), 0.6);
    G.hRobotsPast2(hi) =  createRobotPath( RobotPts(hi,:), 0.7);
    G.hRobotsPast(hi) =  createRobotPath( RobotPts(hi,:), 0.8);
    
    %G.hRobotsPast4(hi) =  BLUEcreateRobotPath( RobotPts(hi,:), 0.6);
    %     G.hRobotsPast10(hi) =  createRobotPath( RobotPts(hi,:), 0.03);
    %     G.hRobotsPast9(hi) =  createRobotPath( RobotPts(hi,:), 0.05);
    %     G.hRobotsPast8(hi) =  createRobotPath( RobotPts(hi,:), 0.10);
    %     G.hRobotsPast7(hi) =  createRobotPath( RobotPts(hi,:), 0.15);
    %     G.hRobotsPast6(hi) =  createRobotPath( RobotPts(hi,:), 0.2);
    %     G.hRobotsPast5(hi) =  createRobotPath( RobotPts(hi,:), 0.3);
    %     G.hRobotsPast4(hi) =  createRobotPath( RobotPts(hi,:), 0.4);
    %     G.hRobotsPast3(hi) =  createRobotPath( RobotPts(hi,:), 0.5);
    %     G.hRobotsPast2(hi) =  createRobotPath( RobotPts(hi,:), 0.6);
    %     G.hRobotsPast(hi) =  createRobotPath( RobotPts(hi,:), 0.7);
    if numel( RobotPts(hi,:))>5
        G.hRobots(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,RobotPts(hi,5),RobotPts(hi,6)],'Curvature',[1/RobotPts(hi,5),1/RobotPts(hi,6)],'FaceColor',colors(RobotPts(hi,4),:));
    else
        G.hRobots(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(hi,4),:));
    end
end

    function obps = wrapInputsToTop(obps,ptsS,ptsE,hS, hE)
    %return inputs to top!
        pts = sortrows([ptsS',ptsE']);
        pts = flipud(pts);
    ptsS = pts(:,1);
    ptsE = pts(:,2);
    
    r = min(ptsS)+numel(ptsS)-38;
    for i = 1:numel(ptsS)
       % down line
       obps(hS-i:hS,ptsS(i)) = 2;
       % left line
       obps(hS-i,r+i:ptsS(i)) = 2;
       % up line
       obps(hS-i:hE+i,r+i) = 2;
       % right line
       obps(hE+i,r+i:ptsE(i)) = 2;
       %down line
       obps(hE+1:hE+i,ptsE(i)) = 2; 
    
    end
    end



    function obps = insertDelay(obps,ptsS,ptsE,hS, hE)
    % insert a delay block
    mid = round((hS+hE)/2);
    for i = 1:numel(ptsS)
       % down line
       obps(mid+1:hS,ptsS(i)) = 2;
       % left line
       l=ptsS(i)-1;
       obps(mid+1,l:ptsS(i)) = 2;
       % down line
       obps(mid-1:mid+1,l) = 2;
       % right line
       obps(mid-1,l:ptsE(i)) = 2;
       %down line
       obps(hE+1:mid-1,ptsE(i)) = 2; 
    
    end
    end
        
    function obps = makeConnectors(obps,ptsS,ptsE,hS, hE)
    % makes {d,l,d,r} connectors between ptsS and ptsE
    % TODO: something smart: arrange all points by ptsS index, see which
    % sets are seperable by a vertical line ptsS(i) such that all ptsE(j>i)
    % are to the right.
    
    pts = sortrows([ptsS',ptsE']);
    ptsS = pts(:,1);
    ptsE = pts(:,2);
    
    mid = round((hS+hE)/2+0.5);
%     for i = 1:numel(ptsS)
%        % down line
%        obps(mid+1:hS,ptsS(i)) = 2;
%        % left line
%        l=min(ptsS(i),ptsE(i))-1;
%        obps(mid+1,l:ptsS(i)) = 2;
%        % down line
%        obps(mid:mid,l) = 2;
%        % right line
%        obps(mid,l:ptsE(i)) = 2;
%        %down line
%        obps(hE+1:mid,ptsE(i)) = 2; 
%     end
    

    for i = 1:numel(ptsS)
       % down line
       obps(mid+i:hS,ptsS(i)) = 2;
       % left line
       l=min(min(ptsS),min(ptsE))+i-numel(ptsS)-1;
       obps(mid+i,l:ptsS(i)) = 2;
       % down line
       obps(mid-i:mid+i,l) = 2;
       % right line
       obps(mid-i,l:ptsE(i)) = 2;
       %down line
       obps(hE+1:mid-i,ptsE(i)) = 2; 
    end
        
        
    end

    function block = resizen(op)
        % Makes each block a common size
        block = ones(G.h,G.w);
        block(end-size(op,1)+1:end,1:size(op,2)) = op;
        reps = size(block,1)-size(op,1)+1;
        block(1:reps,1:size(op,2)) = repmat(op(1,:), reps,1);
        
    end

    function handleRobotPath = createRobotPath( robotInfo, fractionColor)
        % creates a robot path variable
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(robotInfo(4),:))*fractionColor,'LineStyle','none');
    end




    function keyhandler(src,evnt) %#ok<INUSL>
        if strcmp(evnt.Key,'s')
            %imwrite(flipud(get(G.axis,'CData')+1), G.colormap, '../../pictures/png/MatrixPermutePic.png');
            
            %tfig = myaa(4);
          %  F = getframe_nosteal_focus; %
            F = getframe;
            imwrite(F.cdata,['BinCounter',datestr(now,'yy-mm-dd-HH-MM-SS'),'.png']);
            %close(tfig)
            
        else
            moveto(evnt.Key)
        end
    end

    function updatePastPath( hOldPath, hOlderPath)
        for ni = 1:size(RobotPts,1)
            set(hOlderPath(ni),'Position', get(hOldPath(ni),'Position'), ...
                'Curvature', get(hOldPath(ni),'Curvature'));
            uistack(hOlderPath(RobotPts(ni,3)),'top');
        end
    end

    function retVal = spaceFreeWithNoRobot(desVal, RobotPts, G)
        % move there if no robot in the way and space is free
        retVal =  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
            && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
            && G.obstacle_pos( desVal(2),desVal(1) )~=1;
    end

    function moveto(key)
        updatePastPath(G.hRobotsPast10,G.hRobotsPast11);
        updatePastPath(G.hRobotsPast9,G.hRobotsPast10);
        updatePastPath(G.hRobotsPast8,G.hRobotsPast9);
        updatePastPath(G.hRobotsPast7,G.hRobotsPast8);
        updatePastPath(G.hRobotsPast6,G.hRobotsPast7);
        updatePastPath(G.hRobotsPast5,G.hRobotsPast6);
        updatePastPath(G.hRobotsPast4,G.hRobotsPast5);
        updatePastPath(G.hRobotsPast3,G.hRobotsPast4);
        updatePastPath(G.hRobotsPast2,G.hRobotsPast3);
        updatePastPath(G.hRobotsPast,G.hRobotsPast2);
        % Maps keypresses to moving pixels
        step = [0,0];
        if strcmp(key,'leftarrow') || strcmp(key,'-x') %-x
            RobotPts = sortrows(RobotPts,1);
            step = -[1,0];
        elseif strcmp(key,'rightarrow')|| strcmp(key,'+x') %+x
            RobotPts = sortrows(RobotPts,-1);
            step = [1,0];
        elseif strcmp(key,'uparrow')|| strcmp(key,'+y') %+y
            RobotPts = sortrows(RobotPts,-2);
            step = [0,1];
        elseif strcmp(key,'downarrow')|| strcmp(key,'-y') %-y
            RobotPts = sortrows(RobotPts,2);
            step = -[0,1];
        end
        % implement the move on every robot
        for ni = 1:size(RobotPts,1)
            stVal = RobotPts(ni,1:2);
            desVal = RobotPts(ni,1:2)+step;
            % move there if no robot in the way and space is free
            if numel( RobotPts(ni,:))>5
                %1 augment RobotPts to include all additional blocks except
                %this moving block
                sRobotPts =  [];
                for i1 = [1:ni-1,ni+1:numel(RobotPts(:,1))]
                    for i2 = 1:RobotPts(i1,5)
                        for i3 = 1:RobotPts(i1,6)
                            sRobotPts(end+1,:) = [RobotPts(i1,1)+i2-1, RobotPts(i1,2)+i3-1]; %#ok<AGROW>
                        end
                    end
                end
                moveOk = true;
                while moveOk
                    %2.) create a list of coordinates for each section of the
                    %moved block
                    for i2 = 1:RobotPts(ni,5)
                        for i3 = 1:RobotPts(ni,6)
                            %3.) do any of the moving block hit?
                            moveOk = moveOk & spaceFreeWithNoRobot([RobotPts(ni,1)+i2-1+step(1), RobotPts(ni,2)+i3-1+step(2)], sRobotPts, G);
                        end
                    end
                    if moveOk
                        RobotPts(ni,1:2) = desVal;
                        desVal = RobotPts(ni,1:2)+step;
                    end
                end
            else
                while spaceFreeWithNoRobot(desVal, RobotPts, G)
                    RobotPts(ni,1:2) = desVal;
                    desVal = RobotPts(ni,1:2)+step;
                end
            end
            if ~isequal( stVal, RobotPts(ni,1:2) )
                x = min(stVal(1), RobotPts(ni,1));
                y = min(stVal(2), RobotPts(ni,2));
                xd = abs(stVal(1)- RobotPts(ni,1));
                yd = abs(stVal(2)- RobotPts(ni,2));
                
                if numel( RobotPts(ni,:))>5
                    xd = xd + RobotPts(ni,5)-1;
                    yd = yd + RobotPts(ni,6)-1;
                end
                set(G.hRobotsPast(RobotPts(ni,3)),'Position',[x-1/2,y-1/2,xd+1,yd+1],'Curvature',[1/(1+xd),1/(1+yd)]);
                
                uistack(G.hRobotsPast(RobotPts(ni,3)),'top');
                if numel( RobotPts(hi,:))>5
                    set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,RobotPts(ni,5),RobotPts(ni,6)]);
                else
                    set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
                end
            else
                set(G.hRobotsPast(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1],'Curvature',[1,1]);
            end
        end
        for ni = 1:size(RobotPts,1)
            uistack(G.hRobots(RobotPts(ni,3)),'top');
        end
        
    end


    function [blk,RobotPts] = unSAFEddFANOUT
        % this is a  dual-rail logic gate that implements a FanOur
        %       x   x'     1
        blk=[1 1 0 1 0 1 1 0 1 1 1 1 1 1 1  %allows 1 -> 11, 01,
            1 0 0 1 0 1 0 0 1 1 1 1 1 1 1  %allows 0 -> 00
            1 0 1 1 0 1 0 1 1 1 1 1 1 1 1
            1 0 0 1 0 1 0 0 0 0 1 1 1 1 1
            1 1 0 1 0 0 0 0 0 0 0 0 0 0 1
            1 1 0 1 1 1 0 1 1 0 1 0 1 1 1
            1 1 0 1 1 1 0 0 1 0 1 0 1 1 1
            1 1 0 1 1 1 1 0 1 0 1 0 1 1 1 ];
        %       x       x   x'  x'
        
        % blk = flipud(blk);
        h = size(blk,1);
        RobotPts= [3,h,1,1,1,1  %A
            8,h,2,2,1,1 %supply
            13,4,3,3,2,1]; %slider
        
        blk = flipud(blk);
    end

    function [blk,RobotPts] = SAFEddNOTgate() %#ok<DEFNU>
        % this is a reversible cross-over switch that is also a NOT gate for
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            5,11,1,1;
            %6,11,2,1;
            7,11,2,2;
            ];
        %            x   x'
        blk=[1 1 1 1 0 1 0 1 1 1 1;
            1 1 1 1 0 1 0 1 1 1 1;
            1 0 0 0 0 0 0 1 1 1 1;
            1 0 1 1 0 1 1 1 1 1 1;
            1 0 1 0 0 1 1 1 1 1 1;
            1 0 1 0 1 1 1 1 1 1 1;
            1 0 1 0 0 0 0 1 1 1 1;
            1 0 1 1 1 1 0 1 1 1 1;
            1 0 0 0 0 1 0 1 1 1 1;
            1 1 1 1 0 1 0 1 1 1 1;
            1 1 1 1 0 1 0 1 1 1 1];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = ddXORgate()
        % sum bit for dual-rail full adder   d,l,d,r,d,l,d
        RobotPts = [];
        %            A   B   A'  B'
        blk=[1 1 1 1 0 1 0 1 0 1 0 1
            1 0 0 0 0 0 0 0 0 0 0 1
            1 0 0 1 1 1 0 1 0 1 1 1
            1 0 0 1 0 0 0 0 0 1 1 1
            1 0 0 1 0 0 1 1 1 1 1 1
            1 0 0 0 0 0 0 0 0 0 1 1
            1 1 0 1 1 0 1 1 0 0 1 1
            1 1 0 0 0 0 0 1 0 0 1 1
            1 1 1 1 1 1 0 1 0 0 1 1
            %
            ];
        %         w = size(blk,2);
        %         h = size(blk,1);
        %         ins = 2;
        %         for c =1:2^ins
        %             str = dec2bin(c-1,ins);
        %             if str(1) == '1'
        %                 RobotPts(end+1,:) = [w*(c-1)+5,h,1+(c-1)*ins,1];  %A
        %             else
        %                 RobotPts(end+1,:) = [w*(c-1)+7,h,1+(c-1)*ins,1]; %A'
        %             end
        %             if str(2) == '1'
        %                 RobotPts(end+1,:) = [w*(c-1)+9,h,2+(c-1)*ins,2];  %B
        %             else
        %                 RobotPts(end+1,:) = [w*(c-1)+11,h,2+(c-1)*ins,2]; %B'
        %             end
        %         end
        %         blk = flipud(repmat(blk,1,2^ins));
        blk = flipud(blk);
    end
    function [blk,RobotPts] = unSAFEddCarry() 
        % this is a  dual-rail logic gate that implements AND/NOR/OR/NAND
        %         x   x'  y   y'
        blk=[1 1 1 0 1 0 1 0 1 0 1 ;
            1 0 0 0 0 0 0 0 1 0 1 ;
            1 0 0 1 1 0 1 1 1 0 1 ;
            1 0 0 0 0 0 0 0 1 0 1 ;
            1 1 0 0 1 0 1 0 1 0 1 ;
            1 1 1 0 1 0 1 0 1 0 1 ;
            1 0 0 0 0 0 0 0 0 0 1 ;
            1 0 0 0 1 1 1 0 1 1 1 ;
            1 0 0 0 0 0 1 0 1 1 1 ;
            1 1 0 0 0 0 0 0 1 1 1 ;
            1 1 1 0 1 0 1 0 1 1 1 ;
            ];
        %      x&y, (x&y)',1
        h = size(blk,1);
        
        RobotPts = [
            4,h,1,1; % x
            %6,h,2,2; % x'
            8,h,2,2;  %y
            %10,h,4,4;  %y'
            ];
        blk = flipud(blk);
        
    end
    function [blk,RobotPts] = SAFEddCNTgate() %#ok<DEFNU>
        % this is a reversible CONNECTOR (PIPLINE)
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            5,11,1,1;
            %6,11,2,1;
            7,11,2,2;
            ];
        %               x     x'
        blk=[1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1];
        blk = flipud(blk);
    end


end