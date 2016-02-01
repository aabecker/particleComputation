function solveCollectionWithOverlap
% Given a planar workspace consisting of 
%
% Authors: STUDENT_FIRSTNAME LASTNAME and Aaron T. Becker, atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global G MAKE_MOVIE RobotPts
%close all; clc;
clear all
clc
format compact
MAKE_MOVIE = false;
G.fig = figure(1);
G.numCommands = 0;
G.totalMoves = 0;
if MAKE_MOVIE
    set(G.fig ,'Name','Massive Control','color',[1,1,1]); %#ok<UNRCH>
else
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Massive Control');
end

[G.obstacle_pos,RobotPts] = SetupWorld();

G.EMPTY = 0;
G.OBST = 1;

G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);

%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.

numRobots = size(RobotPts,1);
initP = RobotPts;
figure(1)
clf

G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    0.5,0.5,0.5;
    ];
colormap(G.colormap(1:numel(unique(G.obstacle_pos)),:));
G.axis=imagesc(G.obstacle_pos);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');

%set(G.axis,'edgealpha',.08)
axis equal
%axis tight
hold on
%set(G.fig,'Units','normalized','outerposition',[0 0 1 1]);%'MenuBar','none',

%end
G.hRobots = zeros(1, numRobots);
colors = jet(numel(unique(RobotPts(:,4)))+1);


for hi = 1: numRobots
    G.hRobots(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(hi,3),:));
end

%%%%%%%automatic code  (TODO)
mvs = ['w','d','d','d','x','a'];
for myc = 1:numel(mvs)
    pause(.25)
    %   moveto(mvs(myc))
end
%%%%%%%%

    function keyhandler(src,evnt) %#ok<INUSL>
        if strcmp(evnt.Key,'s')
            imwrite(flipud(get(G.axis,'CData')+1), G.colormap, '../../pictures/png/MatrixPermutePic.png');
        else
            moveto(evnt.Key)
        end
    end

    function moveto(key)
        % Maps keypresses to moving pixels
        step = [0,0];
        if strcmp(key,'r')  %RESET
            RobotPts = initP;
            for ni = 1:size(RobotPts,1)
                set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
                uistack(G.hRobots(RobotPts(ni,3)),'top');
            end
            return
        end
        
        if strcmp(key,'leftarrow') || strcmp(key,'a') %-x
            RobotPts = sortrows(RobotPts,1);
            step = -[1,0];
        elseif strcmp(key,'rightarrow')|| strcmp(key,'d') %+x
            RobotPts = sortrows(RobotPts,-1);
            step = [1,0];
        elseif strcmp(key,'uparrow')|| strcmp(key,'w') %+y
            RobotPts = sortrows(RobotPts,-2);
            step = [0,1];
        elseif strcmp(key,'downarrow')|| strcmp(key,'x') %-y
            RobotPts = sortrows(RobotPts,2);
            step = -[0,1];
        end
        
        % implement the move on every robot
        for ni = 1:size(RobotPts,1)
            stVal = RobotPts(ni,1:2);
            desVal = RobotPts(ni,1:2)+step;
            
            % move there if space is free
            if  G.obstacle_pos( desVal(2),desVal(1) )~=1; %check we are not hitting the obstacle
                RobotPts(ni,1:2) = desVal;
            end
            %redraw the robot
            if ~isequal( stVal, RobotPts(ni,1:2) )
                if numel( RobotPts(hi,:))>5
                    set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,RobotPts(ni,5),RobotPts(ni,6)]);
                else
                    set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
                end
            end
        end
    end

    function [blk,RobotPts] = SetupWorld()
        
        blk=[1,1,1,1,1,1,1,1,1,1,1
            1,0,1,0,1,1,0,0,0,0,1
            1,0,0,0,0,0,0,0,0,0,1
            1,1,0,1,0,1,0,0,0,0,1
            1,1,0,0,0,1,0,0,0,0,1
            1,1,1,0,1,0,0,0,0,1,1
            1,1,0,0,0,0,0,0,0,0,1
            1,0,0,0,0,1,1,1,0,0,1
            1,1,0,0,0,0,0,0,0,0,1
            1,0,0,0,0,0,0,0,1,0,1
            1,1,1,1,1,1,1,1,1,1,1];
        blk = flipud(blk);
        
        %randomly place robots not on obstacles and not overlapping
        [r,c] = find(blk==0);
        numrobots = length(r);
        RobotPts = [c,r,(1:numrobots)',(1:numrobots)'];
    end
end