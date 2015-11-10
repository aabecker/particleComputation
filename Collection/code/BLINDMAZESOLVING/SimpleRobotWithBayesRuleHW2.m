function SimpleRobotWithBayesRuleHW2(obstacleMap, varargin)
% Demonstrates Bayes rule in an simple environment:
% implements a unit-size robot in a grid world composed of obstacles and
% free space.  The robot has five actions: {?,?,?,?,s,z} for moving in the
% cardinal directions, scanning the environment, or gathering a GPS measurement.
%
%  The uncertainty in the robots movement can be adjusted, causing it to move
% probabilistically, as described in the function moveRobot()
%
% Similarly, the scanner is low quality.  The 'scanner'  approximates 4
% capacitive sensors that detect (with some probability of error) if a wall
% adjacent to the current cell.  This is described in the function
% applyScan
%
%  Date 5/11/2015
% Author: Aaron Becker, abecker5@uh.edu.



% Setting Default Values...

%  Map 2:
% obstacleMap = ones(6,6);
% obstacleMap(2:end-1,2:end-1) = 0;

format compact
belief = zeros(size(obstacleMap)); %the belief is the probability that the robot is at any given location
[freespacey,freespacex] = find(obstacleMap == 0);
numFreeSpaces = numel(freespacey);
numExperiments = 1;   %default
robotInd = ceil(rand*numFreeSpaces); %robot position drawn from a uniform distribution
robotInitialPose = [freespacex(robotInd),freespacey(robotInd)];
allowedIterations = 100;  %default
automaticControl = false;  %If false, you can control using the keyboard, if true uses function "automaticController"


for i = 1:2:length(varargin)                  % get optional args
    switch varargin{i}
        case 'auto', automaticControl = varargin{i+1};
        case 'numIters', allowedIterations = varargin{i+1};  
        case 'moves', moves = varargin{i+1};
        case 'posRobot', robotInitialPose = varargin{i+1};
        case 'goalRobot', goalRobot = varargin{i+1};
    
    end
end



%initialize motion model accuracy.  The robot actuators are inaccurate
probStraight   = 1;  %0.6 
profOffby90Deg = 0;  %0.1

%initialize scanner accuracy. The scanners are imperfect
%                 wall      no wall
%   detectwall     0.8        0.4
%  ~detectwall     0.2        0.6
sTruePositive = 0.8;  % probability scanner detects wall if there is a wall
sTrueNegative = 0.6;  % probability scanner detects no wall if no wall

%initialize GPS uncertainty:
GPSvar = 5;
bShowRobot = 'off'; %should we show robot on screen? Set to 'off' or 'on'.

tic
for experiment= 1:numExperiments
%initialize robot
robotInd = ceil(rand*numFreeSpaces); %robot position drawn from a uniform distribution
posRobot = robotInitialPose;
probs = ones(numFreeSpaces,1)/numFreeSpaces; %uniformly distributed
for i1 = 1:numFreeSpaces
    belief(freespacey(i1),freespacex(i1)) = probs(i1);
end

%draw world & robot
[hWorldFig,hProb] = drawWorld();
[hRobotPos,hRobotOrient] = drawRobot();
titleString = {'''s'' to scan for walls, arrow keys to move,''h'' to hide/unhide robot'; ''};
title(titleString);
hGPS = rectangle('Position',[posRobot(1)-2*sqrt(GPSvar),posRobot(2)-2*sqrt(GPSvar),4*sqrt(GPSvar),4*sqrt(GPSvar)],'Curvature', [1 1],'EdgeColor','g','visible','off');

if ~automaticControl
        IterNumForKey = 0;  %Logging Manual Iteration Count...
        IterMove = zeros(100,1);
        set(figure(1) ,'KeyPressFcn',@keyhandler,'Name','Bayesian Update');
%         probAtGoal(iter) = belief(2,2);

elseif automaticControl
    numIters = allowedIterations;
    probAtGoal = zeros(numIters,1);
    goalPosition = [2,2];
    for iter = 1:numIters
        % obtain GPS measurement & correct the distribution
        % CorrectUsingGPS()
        % draw the measurement and probability
        redrawWorld(experiment,iter); drawnow;
        % pause(0.25) %pause to show values  ( pause(0.5) waits 1/2 second )
        moveControl = automaticControllerOpenLoop(moves);
        % choose a direction to move
        % moveControl = automaticController(belief, goalPosition)
        % move and correct the distribution.
        moveAndUpdateBelief(moveControl)
        probAtGoal(iter) = belief(2,2);
          
    end
    
    redrawWorld(experiment,iter); drawnow;
        set(figure(2) ,'Name','Prob( x[13,13]) as Function of time step');
        plot(probAtGoal)
        xlabel('Iteration');
        ylabel('Probability');
        title(['Prob(x_t_=_1_5_0[13,13]),  Experiment #',num2str(experiment)])
        toc
end; 
%         probAt13_13(experiment) = probAtGoal(end);
end;

% if automaticControl
% figure(3)
% set(figure(3) ,'Name','Experiment results -- is it better than 60%?');
% bar(probAt13_13)
% xlabel('Experiment #');
% ylabel('Probability at [13,13]');
% title(['Mean prob = ',num2str(mean(probAt13_13))])
% end; 

%Drawing functions
    function [hWorldFig,hProb] = drawWorld()
        figure(1)
        colormap(gray)
        hWorldFig = imagesc(belief);
        set(gca,'YDir','normal');
        [obsy,obsx] = find(obstacleMap == 1);
        for i = 1:numel(obsy)
            rectangle('Position',[obsx(i)-.5,obsy(i)-.5,1,1],'FaceColor','g')
        end
        hProb = zeros(size(belief));
        
        for y = 1:size(belief,1)
            for x = 1:size(belief,2)
                hProb(y,x)=text(x-.4,y,[num2str(100*belief(y,x),'%2.1f\n'),'%']);
            end
        end
        
    end

    function [hRobotPos,hRobotOrient] = drawRobot()
        hRobotPos = rectangle('Position',[posRobot(1)-.5,posRobot(2)-.5,1,1],'Curvature',[1,1],...
            'EdgeColor','r', 'LineWidth',3,'Visible',bShowRobot);
        hRobotOrient = line(posRobot(1)+[0,0.6],posRobot(2)+[0,0],'color','r', 'LineWidth',3,'Visible',bShowRobot);
    end

% redrawing functions
    function redrawRobot()
        set(hRobotPos,'Position',[posRobot(1)-.5,posRobot(2)-.5,1,1],'Visible',bShowRobot);
        set(hRobotOrient,'XData',posRobot(1)+[0,0.6],'YData',posRobot(2)+[0,0],'Visible',bShowRobot);
    end


    function redrawWorld(experiment,iteration)
        set(hWorldFig,'CData',belief);
        for y = 1:size(belief,1)
            for x = 1:size(belief,2)
                set(hProb(y,x),'String',[num2str(100*belief(y,x),'%2.1f\n'),'%']);
            end
        end
        xlabel(['Experiment ',num2str(experiment),', iteration ',num2str(iteration)])
        %display(['Total probability = ',num2str(sum(sum(belief)))])
    end

    function CorrectUsingScan()
        scan = MeasureScan(posRobot, obstacleMap);
        % the measurement update, line 4 "Algorithm Bayes_filter" Table
        % 2.1 on page 27 of Probabilistic Robotics.
        %for each freespace
        for i2 = 1:numFreeSpaces
            oldProb = belief(freespacey(i2),freespacex(i2));
            newProb = BayesianUpdateScan(oldProb, scan, [freespacex(i2),freespacey(i2)]);
            belief(freespacey(i2),freespacex(i2)) = newProb;
        end
        %The resulting belief is usually not a probability
        %distribution (doesn't sum to one) and needs to be nomalized.
        normalizer = 1/sum(sum(belief));
        belief = belief*normalizer;
    end
    
    function moveAndUpdateBelief(move)
        if sum(move ~=0)
            % move the robot
            posRobot = moveRobot(posRobot, move, obstacleMap);
            redrawRobot();
            % the movement update (or 'prediction'), line 3 "Algorithm Bayes_filter" Table
            % 2.1 on page 27 of Probabilistic Robotics.
            %for each freespace
            newBelief = zeros(size(belief));
            for i2 = 1:numFreeSpaces
                %update probabilities at positions around freespacex(i2),freespacey(i2)
                curPos = [freespacex(i2),freespacey(i2)];
                px = belief(curPos(2),curPos(1));
                pMoveS = 0; pMoveR = 0; pMoveL = 0;
                posS = curPos+move;
                if( obstacleMap(posS(2), posS(1)) == 0)
                    pMoveS = probStraight;
                    newBelief(posS(2),posS(1)) = newBelief(posS(2),posS(1)) + pMoveS*px;
                end
                posR = curPos+[-move(2),move(1)];
                if( obstacleMap(posR(2), posR(1)) == 0)
                    pMoveR = profOffby90Deg;
                    newBelief(posR(2),posR(1)) = newBelief(posR(2),posR(1)) + pMoveR*px;
                end
                posL = curPos+[move(2),-move(1)];
                if( obstacleMap(posL(2), posL(1)) == 0)
                    pMoveL = profOffby90Deg;
                    newBelief(posL(2),posL(1)) = newBelief(posL(2),posL(1)) + pMoveL*px;
                end
                pNoMove = 1-(pMoveS+pMoveR+pMoveL);
                newBelief(curPos(2),curPos(1)) = newBelief(curPos(2),curPos(1)) + pNoMove*px;
            end
            % update belief according to move
            belief = newBelief;
        end
    end


    function keyhandler(src,evnt) %#ok<INUSL>
        set(hGPS,'visible','off');
        
if IterNumForKey < allowedIterations  % Stops the game if you have exceeded moves
   
        if strcmp(evnt.Key,'s')
            CorrectUsingScan();
            titleString{2} = [titleString{2}, 's,'];
            IterNumForKey = IterNumForKey + 1;
          
        elseif strcmp(evnt.Key,'z')
            CorrectUsingGPS();
            titleString{2} = [titleString{2}, 'z,'];
            IterNumForKey = IterNumForKey + 1;
        elseif strcmp(evnt.Key,'h')
            if strcmp(bShowRobot,'off')
                bShowRobot = 'on';
            else
                bShowRobot = 'off';
            end
            redrawRobot();
        else
            move = [0,0];
            if strcmp(evnt.Key,'leftarrow')
                move =-[1,0];
                titleString{2} = [titleString{2}, '<,'];
                IterNumForKey = IterNumForKey + 1;
            elseif strcmp(evnt.Key,'rightarrow')
                move = [1,0];
                titleString{2} = [titleString{2}, '>,'];
                IterNumForKey = IterNumForKey + 1;
            elseif strcmp(evnt.Key,'uparrow')
                move = [0,1];
                titleString{2} = [titleString{2}, '\^,'];
                IterNumForKey = IterNumForKey + 1;
            elseif strcmp(evnt.Key,'downarrow')
                move =-[0,1];
                titleString{2} = [titleString{2}, 'v,'];
                IterNumForKey = IterNumForKey + 1;
            end
            moveAndUpdateBelief(move);
        end
        %redrawmap 
        redrawWorld(1,IterNumForKey); %MICHAEL
        title(titleString);
        end;
end

    function newProb = BayesianUpdateScan(oldProb, scan, pos)
        %P(x|s) = P(s|x)P(x);
        %       = P(s_right|x)*P(s_up|x)*P(s_left|x)*P(s_down|x)*P(x)
        newProb = ProbOfScanGivenPosition(scan(1), pos +[1,0] ) *...
            ProbOfScanGivenPosition(scan(2), pos +[0,1] ) * ...
            ProbOfScanGivenPosition(scan(3), pos +[-1,0] ) * ...
            ProbOfScanGivenPosition(scan(4), pos +[0,-1] ) * ...
            oldProb;
    end

    function p = ProbOfScanGivenPosition(scan, pos)
        % returns probability of getting the scan if the cell being scanned
        % is at position pos
        isWall = obstacleMap(pos(2), pos(1));
        if isWall
            if scan
                p = sTruePositive;
            else
                p = 1- sTruePositive;
            end
        else
            if scan
                p = 1-sTrueNegative;
            else
                p = sTrueNegative;
            end
        end
    end

    function scanOut = MeasureScan(pos, obstacleMap)
        %  returns the scan {1 meaning  wall detected, 0 meaning no wall
        %  detected}.  The scans are performed in the following order: facing
        %  {?,?,?,?}.
        scanOut = [
            detectWall(obstacleMap, pos+[1,0]);
            detectWall(obstacleMap, pos+[0,1]);
            detectWall(obstacleMap, pos+[-1,0]);
            detectWall(obstacleMap, pos+[0,-1])
            ];
    end

    function bDetectWall = detectWall(obstacleMap, pos)
        isWall = obstacleMap(pos(2), pos(1));
        
        if isWall
            bDetectWall = (rand() < sTruePositive); % probability of true positive
        else
            bDetectWall = (rand() > sTrueNegative); %probability of true negative
        end
    end

    function posOut = moveRobot(posIn, move, obstacleMap)
        % move is a [x,y] command to add to the [x,y] position.
        %  The robot is low quality and so moves probabilistically. If commanded to
        %  move in some direction it does so with 0.6 probability, stays in place
        %  with 0.2 probability, and moves 90deg to the right of the command with
        %  probability .1 and to the left with prob. 0.1.
        rVal = rand(); %number between 0 and 1
        if rVal< (1-probStraight - 2*profOffby90Deg);
            move = [0,0];
        elseif rVal < (1-probStraight - profOffby90Deg)
            move = [-move(2),move(1)]; %move +90deg of command
        elseif rVal < (1-probStraight)
            move = [move(2),-move(1)]; %move -90deg of command
        end
        
        % collision check
        posOut = posIn + move;
        if( obstacleMap(posOut(2), posOut(1)) ~= 0)
            posOut = posIn; %don't allow collisions.
        end
    end


    function measGPS = MeasureGPS(pos)
        %  returns the GPS reading, which is the actual position plus zero
        %  mean noise with variance GPSvar units^2 in the x and y
        xGPS = pos(1)+randn(1)*sqrt(GPSvar);
        yGPS = pos(2)+randn(1)*sqrt(GPSvar);
        measGPS = [xGPS,yGPS];
    end

    function newProb = BayesianUpdateGPS(oldProb, GPSmeasurement, pos)
        %P(x|z) = P(z|x)*P(x)  * normalizer
        %       = P(z(1)|x(1))*P(z(2)|x(2))*P(x)
        % the normalizer will be calculated outside the loop
       % newProb = oldProb*GPSmeasurement*pos
         %%CONFUSED
        newProb = ((2*pi*GPSvar^2)^-0.5)*exp((-0.5*(pos(1)-measGPS(1))^2)/GPSvar^2)*...
                  ((2*pi*GPSvar^2)^-0.5)*exp((-0.5*(pos(2)-measGPS(2))^2)/GPSvar^2)*...
                   oldProb;
    end

    function CorrectUsingGPS()
        measGPS = MeasureGPS(posRobot);
        % the measurement update, line 4 "Algorithm Bayes_filter" Table
        % 2.1 on page 27 of Probabilistic Robotics.
        %for each freespace
        for i2 = 1:numFreeSpaces
            oldProb = belief(freespacey(i2),freespacex(i2));
            newProb = BayesianUpdateScan(oldProb, measGPS, [freespacex(i2),freespacey(i2)]);
            belief(freespacey(i2),freespacex(i2)) = newProb;
        end
        %The resulting belief is usually not a probability
        %distribution (doesn't sum to one) and needs to be nomalized.
        normalizer = 1/sum(sum(belief));
        belief = belief*normalizer;
    end


  function autoMove = automaticControllerOpenLoop(moves) %#ok<*DEFNU>
        % returns [0,0],[1,0],[-1,0],[0,-1], or [0,1]
        % inputs are:
        %  belief: a 2D probability distribution on the robot's position
        % goalPosition:  a desired [x,y] position of the robot
        %  1   2   3   4   5   6   7   8   9  10  11  12  13  14   15  16  1
%        moves = 'uuuuuuurrrrrrrrdddddddlululululululululululululululululuddddddddddd';   %0.7 at goal!

%        moves = 'llllllllllddddddddddlllllllllluulluulluulluullululululululdldldldldlrddddddddddddldddddddddllllllullullulldddddddl';
       
        autoMove = [0,0];
        
         if iter<numel(moves)
            if moves(iter)=='r'
                autoMove = [1,0];
            elseif moves(iter)=='u'
                autoMove = [0,1];
            elseif moves(iter)=='l'
                autoMove = [-1,0];
            elseif moves(iter)=='d'
                autoMove = [0,-1];
             end
        end
    end


    function autoMove = automaticController(belief, goalPosition)
        % returns [0,0],[1,0],[-1,0],[0,-1], or [0,1]
        % inputs are:
        %  belief: a 2D probability distribution on the robot's position
        % goalPosition:  a desired [x,y] position of the robot
        syms 'u' = [0,1];       syms 'f' = [1,0];   
        syms 'd' = [0,-1];      syms 'b' = [-1,0];
       
    end

end