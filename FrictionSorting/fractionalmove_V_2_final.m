function [numRobots,totalMoves,lapDistance] = fractionalmove_V_2_final(pattern)
% This program takes 'pattern'- any binary image file as input from user
% and performs the following:-
% 1.SetupWorld(map_input), 2.Completes the frictional move algorithm,
% 3.calculates the total number of commands required for
% robots to fill pattern while following algorithm and store it as 'totalMoves',
% 4.Calculates the number of moves required if each robot could be
% controlled independently and stores the value in 'lapDistance'.
% 5.MATLAB directory Returnvalue:'numRobots'- Number of robots,'totalMoves','lapDistance'.
%
% to call, give the name of an image, i.e. fractionalmove_V_2_final('bnw4.png')
%--------------------------------------------------------------------------------------------
% The algorithm gives the same input to all the robots and ends with the
% robots in a desired configuration. See video at YouTube:
% https://youtu.be/uhpsAyPwKeI The concept assumes that robots experience
% infinite friction along the surface of the walls. This code uses a
% rectangular workspace enclosed by four walls. The algorithm iterates over
% four steps that isolate one robot from the swarm and apply
% “drift-movements” to the whole swarm so that only the isolated robot
% experiences a different net movement because it touches a wall. The
% workspace is split into two regions: 1. Staging Zone – The robots are
% initialized in this zone. 2. Build Zone – The robots goal configuration
% is in this zone. Robots are depicted as colored blocks; the boundary is
% black, and final locations are black. Arguments: PosGoal: desired final
% position of robots (drawn in black) given in a 2D matrix. Column 1- x axis
% position, Column 2- y axis position PosObstacles: position of obstacles
% (drawn in black) given in a 2D matrix. Column 1- x axis position, Column
% 2- y axis position PosCurrent: the current location of all robots. Column
% 1 – x axis position, 2- y axis position, 3 – index, 4 - color Make_Movie:
% If true, a small video called  ‘Friction_bots.mp4’is saved in the current
% -------------------------------------------------------------------------
% ALGORITHM: robots are numbered such that bottom-most robot is ‘1’,
% and numbered in ascending order row-wise. The corresponding final
% locations of the robots are numbered based on descending y coordinate as
% first priority and descending x coordinate as second priority. The
% algorithm runs once for each of the N robots.  At the beginning of the
% Kth step the robots 1 to K-1 are in their goal positions and robots K to
% N are in their initial positions.  On the Kth iteration, steps 1 to 5 are
% implemented: Step 1: Move the robots to the left and down until kth robot
% touches the bottom boundary. Step 2: apply a “drift-move” left until kth
% robot reaches left wall Step 3: apply a “drift-move” up until Kth robot
% reaches its final y position. Step 4: move all robots left until Kth
% robot is in correct position relative to robots 1 to K-1.  Then move all
% robots right until the Kth robot’s x position is at its goal position.
% Now robots 1 to K have reached their final position. Robots from K+1 to N
% have been returned to the staging zone.This code has a built-in moviemaker
% function that can be turned
% on by setting Make_Movie to true.
% If true, a small video called  ‘Friction_bots.mp4’is saved in the current
% MATLAB directory.
% Authors: Arun Viswanathan Mahadev and Aaron T. Becker December 13, 2015
% Email:  vm.arun94@yahoo.com and atbecker@uh.edu
% . Jump to spaceFreeWithNoRobot(desVal,
% RobotPts,dir,step).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totalMoves=0; %the total number of moves being commanded onto the robots by the algorithm
e=0.5; %Determines the tightness of the map.
% Total number of moves is inversly proportional to it and area of map is directly proportional to it
close all; 
pauseTs = 0;
%clc
format compact
global G
if nargin < 1
    pattern = 'bnw4.png';
end
% -------------------------------------------------------------------------
% Moviecode
% MOVIE_NAME = 'Friction_bots';
G.fig = figure(1);
clf
% writerObj = VideoWriter(MOVIE_NAME,'MPEG-4');%http://www.mathworks.com/help/matlab/ref/videowriterclass.html
% set(writerObj,'Quality',100);
% writerObj.FrameRate=15;
% open(writerObj);
% % (for each frame)
%     function makemymovie()
%         figure(G.fig)
%         F = getframe;
%         writeVideo(writerObj,F.cdata);
%         writeVideo(writerObj,F.cdata);
%     end
% -------------------------------------------------------------------------
% setting up of map by reading map from input and then converting to
% requiredformat.
I=imread(pattern);
map_input=im2bw(I);
[PosGoal,G.PosObstacles,PosCurrent] = SetupWorld(map_input);
% -------------------------------------------------------------------------

G.EMPTY = 0;
G.OBST = 1;
G.maxX = size(G.PosObstacles,2);
G.maxY = size(G.PosObstacles,1);
%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.
numRobots = size(PosCurrent,1);
figure(1)
clf
G.framecount = 0;
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    0.5,0.5,0.5;
    ];
colormap(G.colormap(1:numel(unique(G.PosObstacles))-1,:));
G.axis=imagesc(G.PosObstacles);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');
axis equal
hold on

G.hRobots = zeros(1, numRobots);
colors = jet(numel(unique(PosCurrent(:,4)))+1);
for hi = 1: numRobots
    
    G.hRobots(hi) =  rectangle('Position',[PosCurrent(hi,1)-1/2,PosCurrent(hi,2)-1/2,1,1],'Curvature',[0,0],'FaceColor',colors(PosCurrent(hi,4),:));
    
end
% lap distance is computed by calling binary_gdm. PosCurrent(:,1:2)-Staging
% zone coordinates of robots, PosGoal
lapDistance= binary_gdm(PosCurrent(:,1:2),PosGoal);
%--------------------------------------------------------------------------
%%%%%%algorithm code having 4 steps
Flag3=0 ;%Signals the completion of the algorithm
count=1; %index of k'th robot

while Flag3~=1
    
    for j=1:size(PosCurrent(1,:))
        %step 1, move left and down
        %         makemymovie()
        stepsize=0.1;
        moveto('a')
        sortrows(PosCurrent,3);
        min=PosCurrent(1,2);
        for down=1:size(PosCurrent)
            if PosCurrent(down,2)<min
                min=PosCurrent(down,2);
            end
        end
        stepsize=min-2;
        moveval=min-2;
        moveto('x')
        
        %end of step 1
        
        Flag1=0 ;%step 2, Left drift move
        while Flag1~=1
            stepsize=e;
            moveto('w');
            stepsize=e;
            moveto('a');
            stepsize=e;
            wq=PosCurrent(:,:);
            wq=sortrows(wq,3);
            if  wq(count,1)==2
                break
            end
            moveto('x');
            stepsize=e;
            moveto('d');
        end
        
        % end of step 2 ,left drift move
        %step 3 starts. the up drift of k'th robot starts
        m=ceil((PosGoal(count,2)-2-e)/e);
        b=(PosGoal(count,2)-2-e)/m;
        a=b-((moveval-e)/m);
        for loop=1:m
            stepsize=e;
            moveto('d');
            stepsize=b;
            moveto('w');
            stepsize=e;
            moveto('a');
            stepsize=a;
            moveto('x');
        end
        %updrift ends
        %step 4 start of movement of robots to relative x position wrt k'th robot
        stepsize=PosGoal(count,1)-2-e-0.1;
        moveto('a')
        
        stepsize=PosGoal(count,1)-2;
        moveto('d')
        
        
    end
    %Count the iteration of the while loop and stops when count is equal to the number of robots
    eq=size(PosGoal);
    if count==eq(1)
        Flag3=1;
    end
    count=count+1;
end
%The steps end
% makemymovie()
    function retVal = frictionOK(stVal, step, G)
        frictionBad = (stVal(2)<=2.01 && step(2)<=0) ... %friction if on bottom row and not trying to move up
            || (stVal(1) >= G.maxX-1 && step(1) >=0)...%friction if on left wall and not trying to move right
            || (stVal(2)>=G.maxY-1 && step(2) >=0)...%friction if on top row and not trying to move down
            || (stVal(1)<=2&& step(1) <=0); %friction if on right wall and not trying to move left
        
        retVal = ~frictionBad;
    end

    function desValnew = spaceFreeWithNoRobot(desVal,stVal,RobotPts,dir) %new code to check collision
        desValnew=desVal;
        if strcmp('d',dir)
            boundary=G.maxX-1;
            for ia=1:size(RobotPts,1)
                if abs(stVal(2)-RobotPts(ia,2))<=0.9 && stVal(1)<RobotPts(ia,1)
                    if boundary>RobotPts(ia,1)-1
                        boundary=RobotPts(ia,1)-1;
                    end
                end
            end
            if desVal(1)> boundary
                desValnew(1)=boundary;
            end
        end
        
        if strcmp('a',dir)
            boundary=2;
            for ia=1:size(RobotPts,1)
                if abs(stVal(2)-RobotPts(ia,2))<=0.9 && stVal(1)>RobotPts(ia,1)
                    if boundary<RobotPts(ia,1)+1
                        boundary=RobotPts(ia,1)+1;
                    end
                end
            end
            if desVal(1)< boundary
                desValnew(1)=boundary;
            end
        end
        if strcmp('x',dir)
            boundary=2;
            for ia=1:size(RobotPts)
                if abs(stVal(1)-RobotPts(ia,1))<=0.9 && stVal(2)>RobotPts(ia,2)
                    if boundary<RobotPts(ia,2)+1
                        boundary=RobotPts(ia,2)+1;
                    end
                end
            end
            if desVal(2)< boundary
                desValnew(2)=boundary;
            end
        end
        if strcmp('w',dir)
            boundary=G.maxY-1;
            for ia=1:size(RobotPts)
                if abs(stVal(1)-RobotPts(ia,1))<=0.9 && stVal(2)<RobotPts(ia,2)
                    if boundary>RobotPts(ia,2)-1
                        boundary=RobotPts(ia,2)-1;
                    end
                end
            end
            if desVal(2)> boundary
                desValnew(2)=boundary;
            end
        end
    end

    function moveto(key)
        totalMoves=totalMoves+1;
        % Maps keypresses to moving pixels
        % implement the move on every robot
        for ni = 1:size(PosCurrent,1)
            if strcmp(key,'a') %-x
                PosCurrent = sortrows(PosCurrent,1);
                step = -[1,0];
            elseif  strcmp(key,'d') %+x
                PosCurrent = sortrows(PosCurrent,[-1 -2]);
                step = [1,0];
            elseif  strcmp(key,'w') %+y
                PosCurrent = sortrows(PosCurrent,-2);
                step = [0,1];
            elseif  strcmp(key,'x') %-y
                PosCurrent = sortrows(PosCurrent,2);
                step = -[0,1];
            end
            step = stepsize*step;
            stVal = PosCurrent(ni,1:2);
            desVal = PosCurrent(ni,1:2)+step;
            
            % move there if no robot in the way and space is free
            if  frictionOK(stVal, step, G)
                desValnew = spaceFreeWithNoRobot(desVal,stVal, PosCurrent,key);
                if stVal(2)<=2 && strcmp(key,'d')
                    PosCurrent(ni,1:2) =stVal;
                else
                    PosCurrent(ni,1:2) = desValnew;
                end
            end
            %redraw the robot
            if ~isequal( stVal, PosCurrent(ni,1:2) )
                set(G.hRobots(PosCurrent(ni,3)),'Position',[PosCurrent(ni,1)-1/2,PosCurrent(ni,2)-1/2,1,1]);
            end
        end
        pause(pauseTs);
        G.framecount=G.framecount+1;
        set(gcf,'Name',num2str(G.framecount))
        drawnow
        if  G.framecount > 30 
            return
        end
        %         makemymovie()
    end

    function [Goalmap,map,PosCurrent] = SetupWorld(map_input)
        %function that has data set of the gameboard, initial points,final points and obstacles
        numrobots = sum(map_input(:)==1);
        m2=size(map_input,1);
        n2=size(map_input,2);
        map_inputz=zeros(m2,n2);
        map_inputz(map_input == 1) = 2;
        map_inputz(map_input == 0) = 0;
        
        % allocate space for staging zone
        % allocate m pixel space around staging and build zone  (m=1)
        % allocate 1 pixel border
        
        ty=ceil(numrobots/n2); %height of staging zone
        
        map = ones(m2+ty+5,n2+5); %want 1 px border, 2 px space, width of build, 1 px space, 1 px border
        map( 2:end-1, 2:end-1) = 0;
        
        
        for i=4: m2+3
            for j1=n2:-1:1
                map(i-1,size(map,2)-j1-1)=map_inputz(i-3,n2-j1+1); %draw the build zone
            end
        end
        
        map = flipud(map); %has to be done to make the gameboard look like the matrix above
        d=size(map);
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
        
        pos = zeros(numrobots,2);
        %place robots on defined location in the staging zone away from obstacles and not overlapping
        for i=1:numrobots
            pos(i,:) = [d(2)-n2+rem(i-1,n2)-1, ceil(i/n2)+2];
        end
        
        PosCurrent = [pos,(1:numrobots)',(1:numrobots)'];
    end
    function  dist = binary_gdm(F1,F2)
        % the G.D.M. Ground distance matrix between two matrices F1 and F2 using
        % the Manhattan distance.
        dist = sum(  abs( F1(:,1)- F2(:,1) ) + abs( F1(:,2)- F2(:,2) ));
    end
end