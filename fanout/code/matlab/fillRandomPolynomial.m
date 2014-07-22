function fillRandomPolynomial
%(1) We are pretty convinced that every point of a given connected
%    polyomino (with or without holes) is reachable.
% (2) We also believe that there should be some result on a minimum filling
%    of 1/2+eps.
% If you have some time, it would be interesting to do some experiments on
% (1) and (2). Starting from some kind of randomly generated connected
% polyomino shape, with a single pixel just outside marked a "source" (of
% infinite bots), randomly tilt and see how much density you get. There are
% really two versions: bots can or cannot fall back out through the source.
% Then measure reached positions and final density (stopping if these don't
% change for a while). If there's a counterexample to (1) or (2), this may
% find it. If there isn't, hopefully it will give us some intuition.

%WLOG: the source will be a cell that drains downward

global G MAKE_MOVIE RobotPts Source
%close all; clc;
clear all
clc
format compact
MAKE_MOVIE = true;
FrameCount = 1;
MOVIE_NAME = 'FillBottle2';
G.fig = figure(1);
G.numCommands = 0;
G.totalMoves = 0;
if MAKE_MOVIE
    set(G.fig ,'Name',MOVIE_NAME,'color',[1,1,1]); %#ok<UNRCH>
    set(G.fig,'Units','normalized','outerposition',[0 0 1 1],'NumberTitle','off');%'MenuBar','none',
     writerObj = VideoWriter(MOVIE_NAME,'MPEG-4');%http://www.mathworks.com/help/matlab/ref/videowriterclass.html
    set(writerObj,'Quality',100)
    %set(writerObj, 'CompressionRatio', 2);
    open(writerObj);
else
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Massive Control');
end

%create obstacle map and draw it
%G.obstacle_pos = flipud(NOTGate());


G.EMPTY = 0;
G.OBST = 1;
%assignCorrespondencies(A,B);
setupObstacles();

G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);

numRobots = size(RobotPts,1);
clf

G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
  %  1,0,0;
    ];

colormap(G.colormap);
G.axis=imagesc(G.obstacle_pos);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');
%set(G.axis,'edgealpha',.08)
axis equal
axis tight
G.title = title('press arrows keys to move');

G.hRobotsPast = zeros(1, numRobots);
G.hRobots = zeros(1, numRobots);
colors = hsv(numel(unique(RobotPts(:,4)))+1);

for hi = 1: numRobots
    G.hRobotsPast(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.7);
    G.hRobots(RobotPts(hi,3)) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(hi,4),:));
end

if MAKE_MOVIE
%%%%%% MAKE MOVIE!
updateDrawing;
mvs = ['-y';'-x';'-y';'-x'; '-y';'-x';'-y';'-x';'-y';'-x';'+x';'-y';];
for myc = 1:size(mvs,1)
   moveto(mvs(myc,:) )

end
close(writerObj);
title('finished!')
set(G.fig ,'Name',['Finished:',MOVIE_NAME],'color',[1,0,1]);
end


    function handleRobotPath = createRobotPath( robotInfo, fractionColor)
        % creates a robot path variable
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(robotInfo(4),:))*fractionColor,'LineStyle','none');
    end

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
        
        if ~MAKE_MOVIE
        % implement the move on every robot
        for ni = 1:size(RobotPts,1)
            stVal = RobotPts(ni,1:2);
            desVal = RobotPts(ni,1:2)+step;
            
            % move there if no robot in the way and space is free
            while  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
                    && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
                    && G.obstacle_pos( desVal(2),desVal(1) )==0
                
                RobotPts(ni,1:2) = desVal;
                desVal = RobotPts(ni,1:2)+step;
            end
            if ~isequal( stVal, RobotPts(ni,1:2) )
                x = min(stVal(1), RobotPts(ni,1));
                y = min(stVal(2), RobotPts(ni,2));
                xd = abs(stVal(1)- RobotPts(ni,1));
                yd = abs(stVal(2)- RobotPts(ni,2));
                set(G.hRobotsPast(RobotPts(ni,3)),'Position',[x-1/2,y-1/2,xd+1,yd+1],'Curvature',[1/(1+xd),1/(1+yd)]);
                uistack(G.hRobotsPast(RobotPts(ni,3)),'top');
                set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
            else
                set(G.hRobotsPast(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1],'Curvature',[1,1]);
            end
            
        end
        
        %implement fill operation
        if isequal(step, -[0,1])
           %is there a robot in the souce row
             %RobotPts = [ Source(2), Source(1),  1, 1]; %
             desVal = [Source(2), Source(1)];
            while  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
                    && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
                    && G.obstacle_pos( desVal(2),desVal(1) )==0
                nl = size(RobotPts,1)+1;
                RobotPts(nl,:) = [desVal,nl,1];
                G.hRobotsPast(RobotPts(nl,3)) =  createRobotPath( RobotPts(nl,:), 0.7);
                G.hRobots(RobotPts(nl,3)) =  rectangle('Position',[RobotPts(nl,1)-1/2,RobotPts(nl,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(nl,4),:));

                desVal = desVal+step;
            end
             
        end
        
        for ni = 1:size(RobotPts,1)
            uistack(G.hRobots(RobotPts(ni,3)),'top');
        end
        end
        
        if MAKE_MOVIE
             % implement the move on every robot
            keepMoving = true;
            stValG = RobotPts(:,1:2);
            while keepMoving == true
                keepMoving = false;
                for ni = 1:size(RobotPts,1)
                    stVal = stValG(ni,1:2);
                    desVal = RobotPts(ni,1:2)+step;

                    % move there if no robot in the way and space is free
                    if  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
                            && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
                            && G.obstacle_pos( desVal(2),desVal(1) )==0

                        RobotPts(ni,1:2) = desVal;
                        desVal = RobotPts(ni,1:2)+step;
                        keepMoving = true;
                    end
                    if ~isequal( stVal, RobotPts(ni,1:2) )
                        x = min(stVal(1), RobotPts(ni,1));
                        y = min(stVal(2), RobotPts(ni,2));
                        xd = abs(stVal(1)- RobotPts(ni,1));
                        yd = abs(stVal(2)- RobotPts(ni,2));
                        set(G.hRobotsPast(RobotPts(ni,3)),'Position',[x-1/2,y-1/2,xd+1,yd+1],'Curvature',[1/(1+xd),1/(1+yd)]);
                        uistack(G.hRobotsPast(RobotPts(ni,3)),'top');
                        set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
                    else
                        set(G.hRobotsPast(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1],'Curvature',[1,1]);
                    end


                end
                        %implement fill operation
                if isequal(step, -[0,1])
                   %is there a robot in the souce row
                     %RobotPts = [ Source(2), Source(1),  1, 1]; %
                     desVal = [Source(2), Source(1)];
                    while  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
                            && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
                            && G.obstacle_pos( desVal(2),desVal(1) )==0
                        nl = size(RobotPts,1)+1;
                        RobotPts(nl,:) = [desVal,nl,1];
                        G.hRobotsPast(RobotPts(nl,3)) =  createRobotPath( RobotPts(nl,:), 0.7);
                        G.hRobots(RobotPts(nl,3)) =  rectangle('Position',[RobotPts(nl,1)-1/2,RobotPts(nl,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(nl,4),:));
                        stValG(nl,:) = RobotPts(nl,1:2);
                        desVal = desVal+step;
                    end

                end

                for ni = 1:size(RobotPts,1)
                        uistack(G.hRobots(RobotPts(ni,3)),'top');
                end
                updateDrawing;  % update movie frame here
                %drawnow
                %title('moving')
            end
            for ctr = 1:10
                updateDrawing;  % update movie frame here
                %drawnow
                %title('finished move')
            end
        end
    end

    function setupObstacles()


        %robot_pos=G.EMPTY*ones(G.r,G.c); %initialize grid to be empty
        bottleWidth = 9;
        bottleHeight= 5;
        G.obstacle_pos=G.OBST*ones(bottleHeight+5,bottleWidth+2);
        
        % A Bottle:
        %bottle void
        G.obstacle_pos(1+(1:bottleHeight), 1+(1:bottleWidth))=G.EMPTY;
        %bottle neck
        Source = [bottleHeight+5,1+round(bottleWidth/2) ];
        G.obstacle_pos(Source(1)+[-5:0], Source(2))=G.EMPTY;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% place the robots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        RobotPts = [ Source(2), Source(1),  1, 1];
            % Source(2), Source(1)-1,  2, 1]; %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
        function updateDrawing
        drawnow
        if(MAKE_MOVIE)
            FrameCount=FrameCount+1;
            F = getframe_nosteal_focus; %getframe;
            writeVideo(writerObj,F.cdata);
            while(FrameCount < 10)
                updateDrawing
            end
            
        end
    end

end