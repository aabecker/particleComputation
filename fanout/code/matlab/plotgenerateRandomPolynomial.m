function plotgenerateRandomPolynomial
    % TODO: add plots showing the amont of time to get the ending amount of
    % coverage.
    recalculateHardProblems = false;
    
    
    load('normalExamplesV2with313')
    figure(1)
    
    hist(finalDensityA/max(numReachedPositionsA))
    ylabel('number trials')
    xlabel('Fraction Filled')
    title(['25x25 grid with 313 space polyomino, ',num2str(numExamples),' total trials'])
    
    figure(2)
    
    hist(numReachedPositionsA/max(numReachedPositionsA))
    ylabel('number trials')
    xlabel('Fraction Spaces reached')
    title(['25x25 grid with 313 space polyomino, ',num2str(numExamples),' total trials'])
    
    
    figure(3)
    hist(movesNumReachedPositionsA)
    ylabel('number trials')
    xlabel('Moves to reach all spaces')
    title(['25x25 grid with 313 space polyomino, ',num2str(numExamples),' total trials'])
    
    
    inds = find(numReachedPositionsA/max(numReachedPositionsA) < 1 );
    for i = 1:numel(obstaclesA) %#ok<USENS>
        %plot shapes that were not totally reached
        
        G.fig = figure(4+i);
        G.colormap = [  1,1,1; %Empty = white
            0,0,0; %obstacle
            1,0,0;%color of fill
            0,0,1; %color of source
            ];
        G.EMPTY = 0;
        G.OBST = 1;
        G.FULL = 2;
        G.SOURCE = 3;
        
        G.axis=imagesc(obstaclesA{i});
        colormap(G.colormap);
        set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','on');
        set(G.fig ,'color',[1,1,1]);
        axis equal
        axis tight
        
        title({'Black obstacles, white empty space, red filled, blue source (particles are supplied down)';...
            [num2str(sum(sum(obstaclesA{i} == G.FULL))) ,'/313 filled (',num2str(100*sum(sum(obstaclesA{i} == G.FULL))/313,'%.1f'),'%), after ',num2str( movesFinalDensity(inds(i))), ' moves'];...
            [num2str(numReachedPositionsA(inds(i))),'/313 reached, after ', num2str(movesNumReachedPositionsA(inds(i))),' moves'];})
        
        if recalculateHardProblems
        %can we do better?
        tic
        G.fig = figure(100+i)
        G.obstacle_pos = obstaclesA{i};
        G.axis=imagesc(G.obstacle_pos);
        colormap(G.colormap);
        
        set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','on');
        set(G.fig ,'color',[1,1,1]);
        axis equal
        axis tight
        
        [ci,cj] = find(G.obstacle_pos == G.SOURCE,1,'first');
        G.fs = [ci-1,cj];
        %empty the array
        G.obstacle_pos(G.obstacle_pos == G.FULL) = G.EMPTY;
        
        G.reachedPositions = find(G.obstacle_pos == G.FULL);
        
        r =size(G.obstacle_pos,1);
        c =size(G.obstacle_pos,2);
        G.spaces = round((r-2)*(c-2)/2);
        solvehardInstances(G)
        end
    end
    
    
    
    
    
    function solvehardInstances(G)
        
        SHOW_IMAGES = false;
        G = applyInput(G,SHOW_IMAGES,1);
        
        numTurnsPerSection = 10000;
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
            if i >  100000 %10^6
                %we may have a counter example,
                CEfilename = 'counterExamples2.mat';
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
            if mod(i,1000) == 0
                makePlots( finalDensity, numReachedPositions,G)
            end
            if i == numTurns
                
                numTurns = numTurns+numTurnsPerSection;
                if  finalDensity(sum(sum(G.obstacle_pos == G.FULL)))< i-numTurnsPerSection+1 ...
                        && numReachedPositions(numel(G.reachedPositions)) < i-numTurnsPerSection+1
                    
                    break;
                end
            end
        end
        filename = ['hardExamplesV2with',num2str(G.spaces),'.mat'];
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
        
        
        function makePlots( finalDensity, numReachedPositions,G)
            
            %TODO: update plot showing graphic
            set(G.axis,'CData',G.obstacle_pos);
        drawnow
        inds = find(numReachedPositions > 1 ,1,'last');
        indsden = find(finalDensity > 1 ,1,'last');
        figure(G.fig)
        title({'Black obstacles, white empty space, red filled, blue source (particles are supplied down)';...
            [num2str(sum(sum(G.obstacle_pos == G.FULL))) ,'/313 filled (',num2str(100*sum(sum(G.obstacle_pos == G.FULL))/313,'%.1f'),'%), after ',num2str( finalDensity(indsden)), ' moves'];...
            [num2str(inds),'/313 reached, after ', num2str(numReachedPositions(inds)),' moves'];})
      
            
    figure(21)
    pt2plot = 1:sum(finalDensity>0);
    plot(finalDensity(pt2plot),(pt2plot)/numel(finalDensity))
    xlabel('Number of turns')
    ylabel('Fraction Filled')
    ind = find(finalDensity>0,1,'last');
    title(['Final density is ',num2str(ind/numel(finalDensity)),' after ', num2str(finalDensity(ind)),' moves'])
    
    %hold on
    figure(31)
    pt2plot = 1:sum(numReachedPositions>0);
    plot(numReachedPositions(pt2plot),(pt2plot)/numel(finalDensity))
    xlabel('Number of turns')
    ylabel('Fraction Spaces reached')
    ind = find(numReachedPositions>0,1,'last');
    title(['Fraction Spaces reached is ',num2str(ind/numel(finalDensity)),' after ', num2str(numReachedPositions(ind)),' moves'])
    %hold on
    
    
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