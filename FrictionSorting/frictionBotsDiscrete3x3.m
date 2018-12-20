
%SPACE REQUIRED: 2X THE NUMBER OF ROWS +3, 1*NUMBER OF COLUMNS + 3

function totalMoves = frictionBotsDiscrete3x3(User_PosGoal,User_PosObstacles)


saveMovie = false;
manual = true;
totalMoves=0;
close all; clc;
pauseTs = 0.01;
clc
format compact
global G
G.fig = figure(1);
clf
if saveMovie
    MOVIE_NAME = 'Friction_bots'; %to make a movie 'Friction_bots.mp4'
    writerObj = VideoWriter(MOVIE_NAME,'MPEG-4');%http://www.mathworks.com/help/matlab/ref/videowriterclass.html
    set(writerObj,'Quality',100);
    writerObj.FrameRate=30;
    open(writerObj);
end
    function makemymovie()% each frame has to be added. So a function is made and called whenever an image needs to be added
        if  saveMovie
            figure(G.fig)
            F = getframe;
            writeVideo(writerObj,F.cdata);
            %  writeVideo(writerObj,F.cdata);
        else
            drawnow
            pause(.2)
        end
    end
switch nargin
    case 2
        [PosGoal,G.PosObstacles,PosCurrent] = SetupWorld(User_PosGoal,User_PosObstacles,3);
    otherwise
        [PosGoal,G.PosObstacles,PosCurrent] = SetupWorld();
end
G.EMPTY = 0;
G.OBST = 1;
G.maxX = size(G. PosObstacles,2);
G.maxY = size(G. PosObstacles,1);
%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.
numRobots = size(PosCurrent,1);
figure(1)
clf
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    0.5,0.5,0.5;
    ];
colormap(G.colormap(1:numel(unique(G. PosObstacles)),:));
G.axis=imagesc(G. PosObstacles);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');
axis equal
hold on
G.hRobots = zeros(1, numRobots);
G.hRobotsN = zeros(1, numRobots);
colors = jet(numel(unique(PosCurrent(:,4)))+1);
for hi = 1: numRobots
    G.hRobots(hi) =  rectangle('Position',[PosCurrent(hi,1)-1/2,PosCurrent(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(PosCurrent(hi,4),:));
    G.hRobotsN(hi) =  text(PosCurrent(hi,1),PosCurrent(hi,2),num2str(hi),'Color','w','fontsize',20,'HorizontalAlignment','center');
end
%%%%%%%automatic code
%moveto('a');moveto('d'); %Null moves to ensure the first frame is drawn
count=1; %index of k'th robot
extramove=0;% used to execute the step 1 and 5 for robots placed in different heights.
Flag3=0 ;%Signals the completion of the algorithm

if manual
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','press arrows keys to move');
end

while Flag3~=1
    if manual
        pause(.2)
    else

        for j=1:size(PosCurrent(1,:))
            %step 1, move left and down
            makemymovie()
            moveto('a')
            moveto('x')
            moveto('x')
            PosCurrent=sortrows(PosCurrent,3);
            for i3=1:PosCurrent(count,2)-2 %additional down movement untill desired robot touches the bottom boundary
                moveto('x')
                if PosCurrent(count,2)~=2
                    extramove=extramove+1; %counting the number of extra down movement
                elseif PosCurrent(count,2)==2
                    break
                end
            end
            %end of step 1
            Flag1=0 ;%step 2, Left drift move
            while Flag1~=1
                moveto('w');
                moveto('a');
                moveto('x');
                moveto('d');
                wq=PosCurrent(:,:);
                wq=sortrows(wq,3); %has current position of robots
                if  wq(count,1)==3
                    Flag1=1;
                end
            end
            % end of step 2 ,left drift move
            % moving the robots a point up so that only k'th robot is allowed to drift move up.
            moveto('w');
            % moving the robots left to put k'th robot on left wall
            moveto('a');
            %step 3 starts. the up drift of k'th robot starts
            Flag2=0;
            while Flag2~=1
                moveto('d');
                moveto('w');
                wq=PosCurrent(:,:);
                wq=sortrows(wq,3);
                if  wq(count,2)== PosGoal(count,2)-extramove %checking if robot has reached required relative position
                    Flag2=1;
                    continue
                end
                moveto('a');
                moveto('x');
            end
            %updrift ends
            %Step 4 :start of movement of all robots to relative x position wrt k'th robot
            for ic=1:PosGoal(count,1)-3
                moveto('a')
            end
            %moving to k'th robot's final position
            for ic=1:PosGoal(count,1)-2
                moveto('d')
            end
        end
        b=size(PosGoal);
        if count==b(1)
            Flag3=1;
        end
        count=count+1;
        moveto('a')
        for ic2=1:extramove
            moveto('w') % step 5:applying the correction motion of up movement by the same unit of extra move that was done in step 1
            extramove=0;
        end
        moveto('d')
        for iin=1:20
            makemymovie()
        end
        pause(pauseTs);
    end
end %end while
if Flag3==1
    for im=1:20
        makemymovie()
    end
end
    function retVal = frictionOK(stVal, step, G)
        frictionBad = (stVal(2)==2 && step(2) <1 ) ... %friction if on bottom row and not trying to move up
            || (stVal(1) == G.maxX-1 && step(1) >-1)...%friction if on right wall and not trying to move left
            ||(stVal(2)==G.maxY-1 && step(2) >-1 )...%friction if on top wall and not trying to move down
            ||(stVal(1)==2 && step(1) <1 ); %friction if on left wall and not trying to move right
        retVal = ~frictionBad;
    end
    function retVal = spaceFreeWithNoRobot(desVal, PosCurrent, G)
        % move there if no robot in the way and space is free
        retVal =  ~ismember(desVal,PosCurrent(:,1:2),'rows')  ...
            && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ... %check that we are not hitting the boundary
            && G. PosObstacles( desVal(2),desVal(1) )~=1; %check we are not hitting the obstacle
    end
    function moveto(Direction)
        totalMoves=totalMoves+1;
        % Maps key to moving pixels
        if strcmp(Direction,'a') %-x
            PosCurrent = sortrows(PosCurrent,1);
            step = -[1,0];
        elseif  strcmp(Direction,'d') %+x
            PosCurrent = sortrows(PosCurrent,-1);
            step = [1,0];
        elseif  strcmp(Direction,'w') %+y
            PosCurrent = sortrows(PosCurrent,-2);
            step = [0,1];
        elseif  strcmp(Direction,'x') %-y
            PosCurrent = sortrows(PosCurrent,2);
            step = -[0,1];
        end
        % implement the move on every robot
        for ni = 1:size(PosCurrent,1)
            stVal = PosCurrent(ni,1:2);
            desVal = PosCurrent(ni,1:2)+step;
            % move there if no robot in the way and space is free
            if spaceFreeWithNoRobot(desVal, PosCurrent, G) && frictionOK(stVal, step, G)
                PosCurrent(ni,1:2) = desVal;
            end
            %redraw the robot
            if ~isequal( stVal, PosCurrent(ni,1:2) )
                set(G.hRobots(PosCurrent(ni,3)),'Position',[PosCurrent(ni,1)-1/2,PosCurrent(ni,2)-1/2,1,1]);
                set(G.hRobotsN(PosCurrent(ni,3)),'Position',[PosCurrent(ni,1),PosCurrent(ni,2)]);
            end
        end
        PosCurrent= sortrows(PosCurrent,[2 1]);
        m=PosCurrent(1,3);
        if m==1
            for movieti=1:3
                makemymovie()
            end
        elseif m~=1
            makemymovie()
        end
    end
    function [Goalmap,map,PosCurrent] = SetupWorld(Goalmap,ObstacleExtra) %function that has data set of the gameboard, initial points,final points and obstacles
%         map=[1 1 1 1 1 1 1 1;
%             1 0 0 0 0 0 0 1;
%             1 0 0 2 2 2 0 1;
%             1 0 0 2 2 2 0 1;
%             1 0 0 2 2 2 0 1;
%             1 0 0 0 0 0 0 1;
%             1 0 0 0 0 0 0 1;
%             1 0 0 0 0 0 0 1;
%             1 0 0 0 0 0 0 1;
%             1 0 0 0 0 0 0 1;
%             1 1 1 1 1 1 1 1;];
rows  = 25;
map = ones(5+2*rows,5+rows);
map( 2:4+2*rows,2:4+rows) = 0;
map( 3:2+rows,4:3+rows) = 2;


        map = flipud(map); %has to be done to make the gameboard look like the matrix above
        d=size(map);
        switch nargin
            case 2
                q = size(Goalmap,1);
                numrobots=q(1,1);
                map(ObstacleExtra(:,1),ObstacleExtra(:,2))=1;
                for i=1:d(1,1)
                    for i2=1:d(1,2)
                        if map(i,i2)==2
                            map(i,i2)=0;
                        end
                    end
                end
                for i=1:q
                    map(Goalmap(i,2),Goalmap(i,1))=2;
                end
            otherwise
                numrobots =sum(map(:) == 2);
                
                count1=1;
                for i=1:d(1,1)
                    for i2=1:d(1,2)
                        if map(i,i2)==2
                            Q1(count1,2)=i; %#ok<AGROW>
                            Q1(count1,1)=i2; %#ok<AGROW>
                            count1=count1+1;
                        end
                    end
                end
                Goalmap=sortrows(Q1,[-1 -2]);
        end
        pos = zeros(numrobots,2);
        %place robots on defined location in the staging zone away from obstacles and not overlapping
 
        for i=1:numrobots
            pos(i,:) = [2+i-rows*floor((i-1)/rows), floor((i-1)/rows)+3];
        end
        PosCurrent = [pos,(1:numrobots)',(1:numrobots)'];
    end

function keyhandler(src,evnt) %#ok<INUSL>
    
        if strcmp(evnt.Key,'leftarrow') 
             moveto('a');
        elseif strcmp(evnt.Key,'rightarrow')
             moveto( 'd');
        elseif strcmp(evnt.Key,'uparrow') 
             moveto('w');
        elseif strcmp(evnt.Key,'downarrow') 
            moveto('x');
        end
    
    
       % if strcmp(evnt.Key,'s')
       %     imwrite(flipud(get(G.axis,'CData')+1), G.colormap, '../../pictures/png/MatrixPermutePic.png');
       if strcmp(evnt.Key,'x') ||strcmp(evnt.Key,'w') || strcmp(evnt.Key,'d') || strcmp(evnt.Key,'a')
            moveto(evnt.Key)
       end
    end

end



