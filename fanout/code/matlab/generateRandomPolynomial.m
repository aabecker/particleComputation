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


function generateRandomPolynomial(r,c)
    %must have at least a one border border
    
    SHOW_IMAGES = false;  %faster code when set to false
    
    G.EMPTY = 0;
    G.OBST = 1;
    G.FULL = 2;
    G.SOURCE = 3;
    maxiters = 100000;
    for iters = 1:maxiters
        
        if nargin <2
            r = 52;
            c = 52;
        end
        
        tic
        G.obstacle_pos=G.OBST*ones(r,c);
        % G.obstacle_pos(1,1) = G.FULL;
        G.fig = figure(1);
        
        G.colormap = [  1,1,1; %Empty = white
            0,0,0; %obstacle
            %  1,0,0;
            ];
        
        colormap(G.colormap);
        G.axis=imagesc(G.obstacle_pos);
        set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');
        set(G.fig ,'color',[1,1,1]);
        axis equal
        axis tight
        G=generateRandomPoly(G, SHOW_IMAGES);
        G.reachedPositions = find(G.obstacle_pos == G.FULL);
        G.transittedPositions = find(G.obstacle_pos == G.FULL);
        
        G=pickFillLocation(G);
        G.colormap(end+1,:)= [ 1,0,0]; %color of fill
        G.colormap(end+1,:)= [ 0,0,1]; %color of source
        colormap(G.colormap);
        
        G = applyInput(G,SHOW_IMAGES,1);
        
        numTurnsPerSection = 5000;
        numTurns = numTurnsPerSection;
        finalDensity = zeros(1,G.spaces);
        numReachedPositions = zeros(1,G.spaces);
        
        finalDensity(1) = sum(sum(G.obstacle_pos == G.FULL))/ G.spaces;
        i=1;
        while true
            i = i+1;
            G = applyInput(G,SHOW_IMAGES);
            if finalDensity(sum(sum(G.obstacle_pos == G.FULL))) == 0
                finalDensity( find(finalDensity==0,1,'first'):sum(sum(G.obstacle_pos == G.FULL)) ) = i;
            end
            
            G.reachedPositions = unique([G.reachedPositions;find(G.obstacle_pos == G.FULL)]);
            if numReachedPositions(numel(G.reachedPositions)) == 0;
                numReachedPositions( find(numReachedPositions==0,1,'first'): numel(G.reachedPositions)) = i;
            end
            
            %save as a counter example if we reach a terminal point
            if i >  10^6
                %we may have a counter example,
                CEfilename = ['counterExamplesV2with',num2str(G.spaces),'.mat']; %first time,  numCounterExamples = 0;obstaclesA={};fillpositionA={};spacesA={};finalDensityA={};numReachedPositionsA={};save(CEfilename,'numCounterExamples','numNotTotallyReached','obstaclesA');

                load(CEfilename)
                
                numCounterExamples = numCounterExamples+1;
                obstaclesA{numCounterExamples} = G.obstacle_pos; %#ok<AGROW>
                fillpositionA{numCounterExamples} = G.fs;%#ok<AGROW,NASGU>
                spacesA{numCounterExamples} = G.spaces;%#ok<AGROW,NASGU>
                finalDensityA{numCounterExamples} = finalDensity;%#ok<AGROW>
                numReachedPositionsA{numCounterExamples} = numReachedPositions;%#ok<AGROW>
                
                save(CEfilename,'numCounterExamples','obstaclesA','fillpositionA','spacesA','finalDensityA','numReachedPositionsA');
                break;
            end
            
            
            % if these values haven't changed for 'a while' we can stop.
            if i == numTurns
                makePlots( finalDensity, numReachedPositions)
                numTurns = numTurns+numTurnsPerSection;
                if  finalDensity(sum(sum(G.obstacle_pos == G.FULL)))< i-numTurnsPerSection+1 ...
                        && numReachedPositions(numel(G.reachedPositions)) < i-numTurnsPerSection+1
                    
                    break;
                end
            end
        end
        filename = ['normalExamplesV2with',num2str(G.spaces),'.mat'];
        load(filename) %first time,  numExamples = 0;numNotTotallyReached=0;,obstaclesA={};save(filename,'numExamples','numNotTotallyReached','obstaclesA');
        numExamples = numExamples+1;
        movesFinalDensity(numExamples)= finalDensity(sum(sum(G.obstacle_pos == G.FULL)));%#ok<NASGU,AGROW>
        finalDensityA(numExamples) = sum(sum(G.obstacle_pos == G.FULL)); %#ok<AGROW>
        numReachedPositionsA(numExamples) = numel(G.reachedPositions); %#ok<AGROW>
        movesNumReachedPositionsA(numExamples) = numReachedPositions(numel(G.reachedPositions));%#ok<NASGU,AGROW>
        if numReachedPositionsA(numExamples) < G.spaces
            numNotTotallyReached = numNotTotallyReached+1;
            %save the obstacle in final configuration.  What is cool about it?
            obstaclesA{numNotTotallyReached} = G.obstacle_pos; %#ok<AGROW>
        end
        
        save(filename,'numExamples','finalDensityA','movesFinalDensity','numReachedPositionsA','movesNumReachedPositionsA','numNotTotallyReached','obstaclesA');
        
        toc
        display(['iters = ', num2str(iters),'/',num2str(maxiters)]);
    end
    %%%%%%%%%%%%%%%%%%%% LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function makePlots( finalDensity, numReachedPositions)
    figure(2)
    pt2plot = 1:sum(finalDensity>0);
    plot(finalDensity(pt2plot),(pt2plot)/numel(finalDensity))
    xlabel('Number of turns')
    ylabel('Fraction Filled')
    ind = find(finalDensity>0,1,'last');
    title(['Final density is ',num2str(ind/numel(finalDensity)),' after ', num2str(finalDensity(ind)),' moves'])
    
    %hold on
    
    figure(3)
    pt2plot = 1:sum(numReachedPositions>0);
    plot(numReachedPositions(pt2plot),(pt2plot)/numel(finalDensity))
    xlabel('Number of turns')
    ylabel('Fraction Spaces reached')
    ind = find(numReachedPositions>0,1,'last');
    title(['Fraction Spaces reached is ',num2str(ind/numel(finalDensity)),' after ', num2str(numReachedPositions(ind)),' moves'])
    %hold on
    
    
function G = generateRandomPoly(G,showOutput)
    if nargin < 2
        showOutput = true;
    end
    r =size(G.obstacle_pos,1);
    c =size(G.obstacle_pos,2);
    dirs = [-1,0;1,0;0,1;0,-1];
    % pick a seed pixel
    sp = [randi([2,r-1]),randi([2,c-1])];
    
    G.obstacle_pos(sp(1),sp(2)) = G.EMPTY;
    G.spaces = round((r-2)*(c-2)/2);
    while sum(sum(G.obstacle_pos == G.EMPTY))< G.spaces
        rdir = dirs(randi(4),:);
        
        if rdir(1)+sp(1) >1 &&  rdir(1)+sp(1) <r  && rdir(2)+sp(2) >1 &&  rdir(2)+sp(2) <c
            sp = rdir+sp;
            G.obstacle_pos(sp(1),sp(2)) = G.EMPTY;
            set(G.axis,'CData',G.obstacle_pos)
        end
        if showOutput
            drawnow
        end
    end
    
function G=pickFillLocation(G)
    G.obstacle_pos(1,1) = G.OBST;
    r =size(G.obstacle_pos,1);
    c =size(G.obstacle_pos,2);
    %pick a random spot in the free space,
    G.fs = [1,1];
    while G.obstacle_pos(G.fs(1),G.fs(2)) ~=G.EMPTY
        G.fs = [randi([2,r-1]),randi([2,c-1])];
    end
    G.obstacle_pos(G.fs(1),G.fs(2)) = G.FULL;
    set(G.axis,'CData',G.obstacle_pos)
    
    %move it up until it hits a border
    while G.obstacle_pos(G.fs(1)+1,G.fs(2)) == G.EMPTY
        G.obstacle_pos(G.fs(1),G.fs(2)) = G.EMPTY;
        G.fs(1)=G.fs(1)+1;
        G.obstacle_pos(G.fs(1),G.fs(2)) = G.FULL;
        set(G.axis,'CData',G.obstacle_pos);
        drawnow
    end
    G.obstacle_pos(G.fs(1)+1,G.fs(2)) = G.SOURCE;
    %G.hRobots =  rectangle('Position',[G.fs(2)-1/2,G.fs(1)+1/2,1,1],'Curvature',[1,1],'FaceColor',[0.8,0.2,0.2],'EdgeColor','w');
    
    
function G=applyInput(G, ShowOutput,rdir)
    if nargin < 3
        rdir =  randi(4);
    end
    if nargin < 2
        ShowOutput =  true;
    end
    [row,col] = find(G.obstacle_pos==G.FULL);
    RobotPts = [row,col];
    if rdir == 1 %-x
        RobotPts = sortrows(RobotPts,1);
        step = [-1,0];
    elseif rdir == 2 %+x
        RobotPts = sortrows(RobotPts,-1);
        step = [1,0];
    elseif rdir == 3 %+y
        RobotPts = sortrows(RobotPts,-2);
        step = [0,1];
    elseif rdir == 4 %-y
        RobotPts = sortrows(RobotPts,2);
        step = [0,-1];
    end
    %clear the robots
    %G.obstacle_pos(row,col)=G.EMPTY;
    
    
    for ni = 1:size(RobotPts,1)
        desVal = RobotPts(ni,1:2)+step;
        G.obstacle_pos(RobotPts(ni,1),RobotPts(ni,2))=G.EMPTY;
        % move there if no robot in the way and space is free
        while G.obstacle_pos( desVal(1),desVal(2) )==G.EMPTY
            
            RobotPts(ni,1:2) = desVal;
            desVal = RobotPts(ni,1:2)+step;
        end
        G.obstacle_pos(RobotPts(ni,1),RobotPts(ni,2))=G.FULL;
        
    end
    
    %implement fill operation
    if isequal(step, [-1,0])
        %is there a robot in the souce row
        %RobotPts = [ Source(2), Source(1),  1, 1]; %
        desVal = [G.fs(1), G.fs(2)];
        while  G.obstacle_pos( desVal(1),desVal(2) )==G.EMPTY
            nl = size(RobotPts,1)+1;
            RobotPts(nl,:) = (desVal);
            G.obstacle_pos(RobotPts(nl,1),RobotPts(nl,2))=G.FULL;
            desVal = desVal+step;
        end
        
    end
    
    %draw the robots
    %G.obstacle_pos(RobotPts(:,1),RobotPts(:,2))=G.FULL;
    
    if ShowOutput
        set(G.axis,'CData',G.obstacle_pos);
        drawnow
    end
    
    % plot