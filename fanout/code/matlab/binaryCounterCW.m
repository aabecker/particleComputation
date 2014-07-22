function binaryCounterCW
% a binary counter with 3 bits.  This relies on a sequence of <d,l,u,r>
% inputs.
%  Aaron Becker
%
% TODO: 1.)
% 
%%

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


G.w = 16;
G.h = 8;
G.gapH = 22;
woff = 15+20;

yoff = -6;

% allocate a blank canvas
G.obstacle_pos = ones((G.h+ G.gapH)*4+4,G.w*3+woff+12);
half = floor(G.w/2);

%gate heights:
h1 = G.h*3+ G.gapH*4+yoff;
h2 = G.h*2+ G.gapH*3+yoff;
h3 = G.h*1+ G.gapH*2+yoff;
h4 = G.h*0+ G.gapH*1+yoff;

% LEVEL 1
f0w = G.w*1+woff+0;
G.obstacle_pos( h1+(1:G.h),f0w +(1:G.w)) =  resizen(ddFANOUTcw());

% LEVEL 2
f1w = G.w*0+half+woff-6;
f2w = G.w*1+half+woff+5;
G.obstacle_pos( h2+(1:G.h),f1w +(1:G.w)) = resizen(ddFANOUTcw());
G.obstacle_pos( h2+(1:G.h),f2w +(1:G.w)) = resizen(ddFANOUTcw());

% LEVEL 3
c0w = G.w*0 +half+woff-0;
s0w = G.w*1 +half+woff-1;
G.obstacle_pos( h3+(1:G.h),c0w+(1:G.w)) = resizen(ddCarrycw());% Carry (an AND gate)
G.obstacle_pos( h3+(1:G.h),s0w+(1:G.w)) = resizen(ddXORgate );% Summer

% LEVEL 4
s1w = G.w*0+woff-1;
%bits
b2 = G.w*0-3+woff;
b1 = G.w*1+8+woff;
b0 = G.w*2+17+woff;
%ones used as supply
o2 = s1w+15;
o1 = b1+8;
o0 = b0+8;

G.obstacle_pos( h4+(1:G.h),s1w +(1:G.w)) = resizen(ddXORgate );% Summer
L41 = [1,2,4,6,3,5,8,7,9];
L1i = [ [b2+[0,4], o2, b1+[0,4]+22,  o1+10]-5,  f0w+[3,5,11] ];
L1o = [ [b2+[0,4], o2, b1+[0,4]+22,  o1+10]-4,  f0w+[6,8,10,12]  ];
%      1,2,3,4,5,6,7,8,9,10
L12 = [ 1,2,3,4,5,7,6,10,8,9];
L2i = [ b2+[0,4]-3, f1w+[3,5,11],    f2w+[3,5,11],     b0+[0,4]-5 ];
L2o = [ b2+[0,4]-2, f1w+[6,8,10,12], f2w+[6,8,10,12], b0+[0,4]-4 ];
L23 = [1,2,3,7,4,8,5,9,6,10,11,12];
L3i = [ b2+[0,4]-1, c0w+[8,10,12,14], s0w+[4,6,8,10], b0+[0,4]-3 ]; 
L3o = [ b2+[0,4], c0w+[3,6,8], s0w+[11,13,15],      b0+[0,4]-2 ];
L34 = [ 1,2,3,5,4,6,7,8,9,10];
L4i = [ s1w+[4,6,8,10], [o1,b1+[0,4],            o0,b0+[0,4]]-1 ];
L4o = [ s1w+[11,13,15],  o1,b1+[0,4],            o0,b0+[0,4] ];

%delay blocks
L1di = L1i([1:6]);
L1do = L1o([1:6]);
L2di = L2i([1,2,9,10]);
L2do = L2o([1,2,11,12]);
L3di = L3i([1,2,11,12]);
L3do = L3o([1,2,9,10]);
L4di = L4i([5:10]);
L4do = L4o([4:9]);
%%% Connections (obps,ptsS,ptsE,hS, hE)
G.obstacle_pos = insertDelaycw(G.obstacle_pos,L1di, L1do,         h1+G.h,h1); %GATE DELAY
G.obstacle_pos = makeConnectors(G.obstacle_pos,L1o,L2i(L12),           h1,h2+G.h);
G.obstacle_pos = insertDelaycw(G.obstacle_pos,L2di, L2do,         h2+G.h,h2);%GATE DELAY
G.obstacle_pos = makeConnectors(G.obstacle_pos,L2o,L3i(L23),           h2,h3+G.h);
G.obstacle_pos = insertDelaycw(G.obstacle_pos,L3di, L3do,         h3+G.h,h3);%GATE DELAY
G.obstacle_pos = makeConnectors(G.obstacle_pos,L3o,L4i(L34),           h3,h4+G.h);
G.obstacle_pos = insertDelaycw(G.obstacle_pos,L4di, L4do,         h4+G.h,h4);%GATE DELAY
%Loop output to top


G.obstacle_pos = wrapInputsToTop(G.obstacle_pos,L4o,L1i(L41),h4, h1+G.h);


RobotPts= [
    s1w+13,              h4,1,1,1,1  %b2
    b1+4,               h4,2,2,1,1 %b1
    b0+4,           h4,3,3,1,1 %b0
    o0,               h4,4,4,1,1  %o2
    o1,                 h4,5,5,1,1 %o1
    o2,                 h4,6,6,1,1 %o0
    f0w+9,      h1+4,7,7,2,1 %Fan-out slider
    f1w+9, h2+4,8,7,2,1  %Fan-out slider
    f2w+9, h2+4,9,7,2,1]; %Fan-out slider

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
text(o2-8,txth,'$\rm{b}_2$',txtop{:})
text(o2-4,txth,'$\overline{\rm{b}}_2$',txtop{:})
text(o2,txth,'1',txtop{:})

text(b1,txth,'$\rm{b}_1$',txtop{:})
text(b1+4,txth,'$\overline{\rm{b}}_1$',txtop{:})
text(o1,txth,'1',txtop{:})

text(b0,txth-1.5,'$\rm{b}_0$',txtop{:})
text(b0+4,txth-1.5,'$\overline{\rm{b}}_0$',txtop{:})
text(o0,txth-1.5,'1',txtop{:})


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
        
        r = min(ptsS)+numel(ptsS)-48;
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

    function obps = insertDelaycw(obps,ptsS,ptsE,hS, hE)
        % insert a delay block <d,l,u,r
        %mid = round((hS+hE)/2);
        skips = round((hS-hE)/2);
        for i = 1:numel(ptsS)
            if  ptsS(i) ==ptsE(i)
                display('bad input in delay -- cannot have inputs and outs lineup')
            end
            if ptsS(i) < ptsE(i)
                d = hS-skips;%hS-2*i+1;
                obps(d:hS,ptsS(i)) = 2;% down line
                obps(d,ptsS(i)-1:ptsE(i)) = 2; %horz line
                obps(hE+1:d,ptsE(i)) = 2; % down line
                %skips = skips+2;
            else
                obps(hS-skips-2:hS,ptsS(i)) = 2;% down line
                obps(hS-skips-2,ptsE(i):ptsS(i)) = 2; %horz line
                obps(hE+1:hS-skips-1,ptsE(i)) = 2; % down line
                %skips = skips+2;
            end
            
            
            
        end
    end

    function obps = makeConnectors(obps,ptsS,ptsE,hS, hE)
        % makes {d,l,u,r} connectors between ptsS and ptsE
        pts = sortrows([ptsS',ptsE']);
        ptsS = pts(:,1);
        ptsE = pts(:,2);
        
        for i = 1:numel(ptsS)
            % down line
            obps(hE+i:hS,ptsS(i)) = 2;
            % left line
            l = min(min(ptsS),min(ptsE))-i;
            t = hE+2*numel(ptsS)-i+1;
            obps(hE+i,l:ptsS(i)) = 2;
            % up line
            obps(hE+i:t,l) = 2;
            % right line
            obps(t,l:ptsE(i)) = 2;
            %down line
            obps(hE+1:t,ptsE(i)) = 2;
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


    function [blk,RobotPts] = ddFANOUTcw
        % this is a  dual-rail logic gate that implements a FanOur
        %       x   1           x'
        blk=[1 1 0 1 0 1 1 1 1 1 0 1 1
            1 1 0 1 0 1 1 1 1 0 0 0 1
            1 1 0 1 0 1 1 1 1 0 0 0 1
            1 1 0 1 0 1 1 1 1 1 1 0 1
            1 0 0 0 0 0 0 0 0 0 1 0 1
            1 1 1 0 0 0 1 0 1 0 1 0 1
            1 1 1 1 1 0 1 0 1 0 1 0 1
            ];%       x   x   x'  x'
        
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
        %              A   A'  B   B'
        blk=[1 1 1 0 1 0 1 0 1 0 1 1 1 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1;
            1 0 0 1 1 0 1 0 1 1 0 1 0 1 0 1;
            1 0 0 0 0 0 0 0 1 1 0 1 0 1 0 1;
            1 1 1 1 1 1 1 1 1 1 0 1 0 1 0 1;
            ];%                     XOR, XNOR,1
        %         %            A   B   A'  B'
        %         blk=[1 1 1 1 0 1 0 1 0 1 0 1 1 1 1;
        %              1 1 0 1 0 1 0 1 0 1 0 1 1 1 1;
        %              1 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 0 1 0 1;
        %              1 0 0 1 1 1 0 1 0 1 1 0 1 0 1;
        %              1 0 0 0 0 0 0 0 0 1 1 0 1 0 1;
        %              1 1 0 1 1 1 1 1 1 1 1 0 1 0 1;
        %             ];% XOR,             XNOR, 1
        
        blk = flipud(blk);
    end
    function [blk,RobotPts] = ddCarrycw()
        % this is a  dual-rail logic gate that implements Carry (AND
        %                  A   A'  B   B'
        blk=[1 1 1 1 1 1 1 0 1 0 1 0 1 0 1;
            1 1 0 1 1 1 1 0 1 0 1 0 1 0 1;
            1 0 0 0 0 0 1 0 1 0 1 0 1 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 0 1 1 0 1 1 1 0 1 1 1 0 1;
            1 1 0 1 0 0 0 0 1 0 1 1 1 0 1;
            1 1 0 1 0 0 0 0 0 0 0 0 0 0 1;
            1 1 0 1 1 0 1 0 1 1 1 1 1 1 1;
            %    AND,   1,  NAND
            ];
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