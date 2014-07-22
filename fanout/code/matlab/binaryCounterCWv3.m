function binaryCounterCWv3
% a binary counter with 3 bits.  This relies on a sequence of <d,l,u,r>
% inputs.
%  This version requires just three levels so it should be more compact.
%  Aaron Becker
%
% WORKING.
% TODO: 1.)  Start from the bottom with the short connectors (when E>S)
% 
%%

global G MAKE_MOVIE RobotPts
%close all; clc;
%clear all
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
G.gapH = 23;
woff = 15+13;
yoff = -12;

% allocate a blank canvas
G.obstacle_pos = ones((G.h+ G.gapH)*3-2,G.w*3+woff+1);
half = floor(G.w/2);

%gate heights:
h1 = G.h*2+ G.gapH*3+yoff;
h2 = G.h*1+ G.gapH*2+yoff;
h3 = G.h*0+ G.gapH*1+yoff;
G.h3 = h3;

% LEVEL 1
f1w = G.w*0+woff+2;
f0w = G.w*1+half+woff-6;
G.obstacle_pos( h1+(1:G.h),f1w +(1:G.w)) = resizen(ddFANOUTcw());
G.obstacle_pos( h1+(1:G.h),f0w +(1:G.w)) =  resizen(ddFANOUTcw());

% LEVEL 2
c0w = G.w*0 +half+woff-0;
f2w = G.w*1+half+woff+5;
G.obstacle_pos( h2+(1:G.h),c0w+(1:G.w)) = resizen(ddCarrycw());% Carry (an AND gate)
G.obstacle_pos( h2+(1:G.h),f2w +(1:G.w)) = resizen(ddFANOUTcw());

% LEVEL 3
s0w = G.w*1+half+woff-10;
s1w = G.w*0+woff-1;
G.obstacle_pos( h3+(1:G.h),s0w+(1:G.w)) = resizen(ddXORgate );% Summer
G.obstacle_pos( h3+(1:G.h),s1w +(1:G.w)) = resizen(ddXORgate );% Summer

%bits
b2 = s1w+11;
b1 = s0w+11;
b0 = G.w*2+12+woff;
%ones used as supply
o2 = s1w+15;
o1 = s0w+15;
o0 = b0+4;


L31 = [1,2,4,3,5,6,7,9,8];
L1i = [ f0w+[0,2]+17, f1w+[3,5,11],    f0w+23, f0w+[3,5,11] ];
L1o = [ f0w+[0,2]+18, f1w+[6,8,10,12], f0w+24, f0w+[6,8,10,12]  ];
%      1,2,3,4,5,6,7,8,9,10
L12 = [1,2,3,7,4,8,10,5,9,6,11];
L2i = [ b2+[0,2]-15, c0w+[8,10,12,14],  b2+[0,2]-11,  f2w+[3,5,11] ];
L2o = [ b2+[0,2]-14, c0w+[3,6,8],       b2+[0,2]-10,  f2w+[6,12,10,8] ];

L23 = [1,2,3,11,4,5,6,7,9,8,10];
L3i = [ s1w+[4,6,8,10], s0w+[4,6,8,10], b0+[0,2]-1, o0-1]; 
L3o = [ s1w+[11,13,15], s0w+[11,13,15], b0+[0,2], o0 ];


%delay blocks
L1di = L1i([1,2,6]);
L1do = L1o([1,2,7]);
L2di = L2i([1,2,7,8]);
L2do = L2o([1,2,6,7]);
L3di = L3i([9,10,11]);
L3do = L3o([7,8,9]); 

%%% Connections (obps,ptsS,ptsE,hS, hE)
G.obstacle_pos = insertCompactDelaycw(G.obstacle_pos,L1di, L1do,         h1+G.h,h1); %GATE DELAY
G.obstacle_pos = makeConnectors(G.obstacle_pos,L1o,L2i(L12),           h1,h2+G.h);
G.obstacle_pos = insertCompactDelaycw(G.obstacle_pos,L2di, L2do,         h2+G.h,h2);%GATE DELAY
G.obstacle_pos = makeConnectors(G.obstacle_pos,L2o,L3i(L23),           h2,h3+G.h);
G.obstacle_pos = insertCompactDelaycw(G.obstacle_pos,L3di, L3do,         h3+G.h,h3);%GATE DELAY
%Loop output to top

G.obstacle_pos = wrapInputsToTop(G.obstacle_pos,L3o,L1i(L31),h3, h1+G.h);


RobotPts= [
    b2+2,         h3,1,1,1,1  %b2
    b1+2,           h3,2,2,1,1 %b1
    b0+2,           h3,3,3,1,1 %b0
    o0,             h3,4,4,1,1  %o2
    o1,             h3,5,5,1,1 %o1
    o2,             h3,6,6,1,1 %o0
    f0w+9,          h1+4,7,7,2,1 %Fan-out slider
    f1w+9,          h1+4,8,7,2,1  %Fan-out slider
    f2w+9,          h2+4,9,7,2,1]; %Fan-out slider

%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.
G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);
numRobots = size(RobotPts,1);

clf

G.wiringColor = [0.5,0.5,0.5];

G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    G.wiringColor;
    ];

colormap(G.colormap(1:numel(unique(G.obstacle_pos)),:));
G.axis=imagesc(G.obstacle_pos);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');

% Add annotations
txtop = {'color','r','Interpreter','latex','fontsize',14};
txth = 9;
G.texts = zeros(9);
G.texts(1)=text(o2-5,txth,'$\boldmath{\boldmath{\rm{b}}_2}$',txtop{:});
G.texts(2)=text(o2-2.6,txth,'$\boldmath{\overline{\boldmath{\rm{b}}}_2}$',txtop{:});
G.texts(3)=text(o2-1/3,txth,'\bf{1}',txtop{:});

G.texts(4)=text(o1-5,txth,'$\boldmath{\boldmath{\rm{b}}_1}$',txtop{:});
G.texts(5)=text(o1-2.6,txth,'$\boldmath{\overline{\boldmath{\rm{b}}}_1}$',txtop{:});
G.texts(6)=text(o1-1/3,txth,'\bf{1}',txtop{:});

G.texts(7)=text(o0-5,txth,'$\boldmath{\boldmath{\rm{b}}_0}$',txtop{:});
G.texts(8)=text(o0-2.6,txth,'$\boldmath{\overline{\boldmath{\rm{b}}}_0}$',txtop{:});
G.texts(9)=text(o0-1/3,txth,'\bf{1}',txtop{:});

G.state2 = sum(ismember(RobotPts(:,1),b2));
G.state1 = sum(ismember(RobotPts(:,1),b1));
G.state0 = sum(ismember(RobotPts(:,1),b0));
txtop2 = {'color','w','Interpreter','latex','fontsize',20};
G.textsState = text(55,3,['\bf{State = [',num2str(G.state2),',',num2str(G.state1),',',num2str(G.state0),']}'],txtop2{:});

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
    G.hRobotsPast7(hi) =  createRobotPath( RobotPts(hi,:), 0.45);
    G.hRobotsPast6(hi) =  createRobotPath( RobotPts(hi,:), 0.5);
    G.hRobotsPast5(hi) =  createRobotPath( RobotPts(hi,:), 0.55);
    G.hRobotsPast4(hi) =  createRobotPath( RobotPts(hi,:), 0.6);
    G.hRobotsPast3(hi) =  createRobotPath( RobotPts(hi,:), 0.7);
    G.hRobotsPast2(hi) =  createRobotPath( RobotPts(hi,:), 0.8);
    G.hRobotsPast(hi) =  createRobotPath( RobotPts(hi,:), 0.9);
    
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
        
        r = min(ptsS)+numel(ptsS)-46;
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
        % insert a delay block <d,l,u,r>
        pts = sortrows([ptsS',ptsE']);
        pts = flipud(pts);
        ptsS = pts(:,1);
        ptsE = pts(:,2);
        %mid = round((hS+hE)/2);
        skips = round((hS-hE)/2);
        count=0;
        for i = 1:numel(ptsS)
            if  ptsS(i) ==ptsE(i)
                display('bad input in delay -- cannot have inputs and outs lineup')
            end
            if ptsS(i) < ptsE(i)
                %d = hS-skips;
                if i>1 && ptsS(i)+4<ptsS(i-1)
                    count = 1;
                else
                    count = count+1;
                end
                d = hS-2*(count-1)-1;
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

function obps = insertCompactDelaycw(obps,ptsS,ptsE,hS, hE)
        % insert a delay block <d,l,u,r>
        pts = sortrows([ptsS',ptsE']);
        pts = flipud(pts);
        ptsS = pts(:,1);
        ptsE = pts(:,2);
        %mid = round((hS+hE)/2);
        skips = round((hS-hE)/2);
        count=0;
        for i = 1:numel(ptsS)
            if  ptsS(i) ==ptsE(i)
                display('bad input in delay -- cannot have inputs and outs lineup')
            end
                %d = hS-skips;
                if i>1 && ptsS(i)+4<ptsS(i-1)
                    count = 1;
                else
                    count = count+1;
                end
                d = hS-2*(count-1)-1;
                obps(d:hS,ptsS(i)) = 2;% down line
                obps(d,min(ptsS)-1:ptsE(i)) = 2; %horz line
                obps(hE+1:d,ptsE(i)) = 2; % down line
                %skips = skips+2;
                
        end
    end


    function obps = makeConnectors(obps,ptsS,ptsE,hS, hE)
        % makes {d,l,u,r} connectors between ptsS and ptsE
        pts = sortrows([ptsS',ptsE']);
 %       pts = flipud(pts);
        ptsS = pts(:,1);
        ptsE = pts(:,2);
        
        sp = 1;
        if ptsS(1)<ptsE(1)
            sp = 1;
        end
%         count=0;
%         lastcount = 1;
%         n=numel(ptsS);
        for i = 1:numel(ptsS)
%             if ptsS(c) < ptsE(c)
%                 
%                 if c>1 && ptsS(c)+4<ptsS(lastcount)
%                     count = 1;
%                 else
%                     count = count+1;
%                     lastcount=c;
%                 end
%                 d = hS-2*(count-1)-1;
%                 obps(d:hS,ptsS(c)) = 2;% down line
%                 obps(d,ptsS(c)-1:ptsE(c)) = 2; %horz line
%                 obps(hE+1:d,ptsE(c)) = 2; % down line
%             
%             else
%                i = n-c;
                d = hE+i;
                % down line
                obps(d:hS,ptsS(i)) = 2;
                % left line
                l = min(min(ptsS),min(ptsE))-i;
                t = hE+2*numel(ptsS)-i+sp;
                obps(d,l:ptsS(i)) = 2;
                % up line
                obps(d:t,l) = 2;
                % right line
                obps(t,l:ptsE(i)) = 2;
                %down line
                obps(hE+1:t,ptsE(i)) = 2;
     %       end
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
        %handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(robotInfo(4),:))*fractionColor,'LineStyle','none');
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(robotInfo(4),:)*fractionColor+(1-fractionColor)*G.wiringColor,'LineStyle','none');
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
        for ni = 1:size(G.texts )
             uistack(G.texts(ni),'top');
        end
        
        if min(RobotPts(:,2))< G.h3 && min(RobotPts(:,1))> woff %only update state if robots below last gate and to right of wiring
            
        
        G.state2 = sum(ismember(RobotPts(:,1),b2));
        G.state1 = sum(ismember(RobotPts(:,1),b1));
        G.state0 = sum(ismember(RobotPts(:,1),b0));
        set(G.textsState,'string',['\bf{State = [',num2str(G.state2),',',num2str(G.state1),',',num2str(G.state0),']}'],txtop2{:});
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



end