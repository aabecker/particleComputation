function gadgetsMOVIE
    % demonstrates several gadgets.  My goal is to do everything with the input
    % sequence {D,L,D,R}
    % TODO: NOT and SPLITTER gate, remove commas
    global G MAKE_MOVIE RobotPts
    %close all; clc;
    clear all
    clc
    format compact
    MAKE_MOVIE = false;
    FrameCount = 1;
    MOVIE_NAME = 'Andgate5inputsFAIL';
    G.fig = figure(1);
    set(G.fig,'Units','normalized','outerposition',[0 0 1 1],'NumberTitle','off');%'MenuBar','none',
    if MAKE_MOVIE
        writerObj = VideoWriter(MOVIE_NAME,'MPEG-4');%http://www.mathworks.com/help/matlab/ref/videowriterclass.html
        set(writerObj,'Quality',100)
        %set(writerObj, 'CompressionRatio', 2);
        open(writerObj);
    end
    %
    
    %create obstacle map and draw it
    %[G.obstacle_pos,RobotPts] = ddNOTgate(); %BAD
    %[G.obstacle_pos,RobotPts] = SAFEddNOTgate();  %For ICRA paper, we made this
    %[G.obstacle_pos,RobotPts] = ddNOTandConnectorgate();
    %[G.obstacle_pos,RobotPts] = ONEWAY_SAFEddNOTgate();
    %[G.obstacle_pos,RobotPts] = FullAdderCarry();
    %[G.obstacle_pos,RobotPts] = FullAdderSum();
    %[G.obstacle_pos,RobotPts] = ddXORgate;
    %[G.obstacle_pos,RobotPts] = SAFEddCNTgate;
    %[G.obstacle_pos,RobotPts] = ONEWAY_SAFEddCNTgate;
    %[G.obstacle_pos,RobotPts] = XORgate; %single rail
    %[G.obstacle_pos,RobotPts] = NOTgate; %broken
    %[G.obstacle_pos,RobotPts] = FANOUTgate; %broken
    %[G.obstacle_pos,RobotPts] = ddANDgate();
    %[G.obstacle_pos,RobotPts] = maintainDLDR();
    %[G.obstacle_pos,RobotPts,strTitle] = verySAFEddANDgate();  % the gate Artie built
    %[G.obstacle_pos,RobotPts,strTitle] = verySAFEddANDgateSET();  % the gate Artie built
    %[G.obstacle_pos,RobotPts,strTitle] = unSAFEddANDgateSET();  % the gate Artie built
    %[G.obstacle_pos,RobotPts] = VariableBlkIndexed(4);
    %[G.obstacle_pos,RobotPts] = VariableBlk();
    %[G.obstacle_pos,RobotPts] = SAFEVariableBlk();
    %[G.obstacle_pos,RobotPts] = ONEWAY_mInANDgate(); %used for ALGOSENSORS paper
    %[G.obstacle_pos,RobotPts] = SandorsGadgetForCounting();
    %[G.obstacle_pos,RobotPts] = SandorsGadgetForCountingV2();
    %[G.obstacle_pos,RobotPts] = ONEWAY_3InORgate();   %used for ALGOSENSORS paper
    
    [G.obstacle_pos,RobotPts,strTitle] = unSAFEddFANOUT();  % fan-out gate?  Looks like memory
    G.EMPTY = 0;
    G.OBST = 1;
    
    
    G.maxX = size(G.obstacle_pos,2);
    G.maxY = size(G.obstacle_pos,1);
    
    %create vector of robots and draw them.  A robot vector consists of an xy
    %position, an index number, and a color.
    
    numRobots = size(RobotPts,1);
    
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
    % % %%% USEFUL FOR PRINTING A GRIDDED ARRAY:
    % figure
    % Ggrid.colormap = [  1,1,1; %Empty = white
    %     0.5,0.5,0.5; %obstacle
    %     0.5,0.5,0.5;
    %     ];
    % ObsGrid = [G.obstacle_pos;zeros(size(G.obstacle_pos(1,:)))]
    % ObsGrid = [ObsGrid,zeros(size(ObsGrid(:,1)))]
    % pcolor(ObsGrid)
    % G.title = title({'press arrows keys to move';strTitle});  %TODO: why no title?
    % axis equal
    % axis tight
    % hold on
    % colormap(Ggrid.colormap(1:numel(unique(G.obstacle_pos)),:));
    % return
    
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
    colors = hsv(numel(unique(RobotPts(:,4)))+1);
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
    
    %%%%%% MAKE MOVIE!
    updateDrawing;
    mvs = ['-y';'-x';'-y';'+x';'-y'];
    for myc = 1:size(mvs,1)
        moveto(mvs(myc,:) )
    end
    
    if MAKE_MOVIE
        close(writerObj);
    end
    title('Finished!')
    set(G.fig,'Units','normalized','outerposition',[0 0 .5 .5],'NumberTitle','off','Name', MOVIE_NAME);
    
    
    
    
    function handleRobotPath = createRobotPath( robotInfo, fractionColor)
        % creates a robot path variable
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(robotInfo(4),:))*fractionColor,'LineStyle','none');
    end
    
    function handleRobotPath = BLUEcreateRobotPath( robotInfo, fractionColor)
        % creates a robot path variable
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-[0,0,1])*fractionColor,'LineStyle','none');
    end
    
    
    function keyhandler(src,evnt) %#ok<INUSL>
        if strcmp(evnt.Key,'s')
            imwrite(flipud(get(G.axis,'CData')+1), G.colormap, '../../pictures/png/MatrixPermutePic.png');
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
            && G.obstacle_pos( desVal(2),desVal(1) )==0;
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
    function [blk,RobotPts,strTitle] = unSAFEddFANOUT
             % this is a  dual-rail logic gate that implements a FanOut
        
        % 
        strTitle = 'x, x'', 1';
        %       x   x'     1
       blk=[1 1 0 1 0 1 1 0 1 1 1 1 1 1 1 0 %allows 1 -> 11, 01, 
            1 0 0 1 0 1 0 0 1 1 1 1 1 1 1 0 %allows 0 -> 00
            1 0 1 1 0 1 0 1 1 1 1 1 1 1 1 0
            1 0 0 1 0 1 0 0 0 0 1 1 1 1 1 0
            1 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0
            1 1 0 1 1 1 0 1 1 0 1 0 1 1 1 0
            1 1 0 1 1 1 0 0 1 0 1 0 1 1 1 0
            1 1 0 1 1 1 1 0 1 0 1 0 1 1 1 0];
        %       x       x   x'  x'

       % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        ins = 1;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+3,h,1+(c-1)*ins,1,1,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+5,h,1+(c-1)*ins,1,1,1]; %A'
            end
        end
                %         x   1   x'    
        RobotPts(end+1,:) = [8,h,3,2,1,1]; %supply
        RobotPts(end+1,:) = [13,4,4,3,2,1]; %slider
        RobotPts(end+1,:) = [w+8,h,5,2,1,1]; %supply
        RobotPts(end+1,:) = [w+13,4,6,3,2,1]; %slider


        blk = flipud(repmat(blk,1,2^ins));
end
    
    function [blk,RobotPts] = ddNOTgate() %#ok<DEFNU>
        % this is a reversible cross-over switch that is also a NOT gate for
        % dual-rail logic
        RobotPts = [
            5,11,1,1;
            %6,11,2,1;
            7,11,2,2;
            ];
        %                   x     x'
        blk = [ 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1;
            1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1;
            1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1];
        
        blk = flipud(blk);
    end
    
    function [blk,RobotPts] = XORgate() %#ok<DEFNU>
        % this is a reversible cross-over switch that is also a NOT gate for
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [ % x,y,color, num, w,h
            3,9,1,1,1,1;  %X input
            6,9,2,2,1,1;  %Y input
            12,9,3,3,1,1; %supply
            13,5,4,4,2,1; %slider
            ];
        for i = 1:numel(RobotPts(:,1))
            RobotPts(i,3) = i;
            RobotPts(i,4) = i;
        end
        %               x     x'
        %         blk=[1 1 1 0 1 0 1 1 1 0 1 1
        %             1 1 1 0 1 0 0 0 0 0 0 0
        %             1 1 1 0 1 0 0 0 0 1 0 1
        %             1 0 0 0 0 0 0 0 0 0 0 1
        %             1 1 1 1 0 1 1 1 1 1 1 1
        %             1 1 1 1 0 0 1 1 1 1 1 1
        %             1 1 1 1 1 0 1 1 1 1 1 1
        %             1 1 1 1 1 0 1 1 1 1 1 1];
        blk=[1 1 0 1 1 0 1 1 1 1 1 0 1 1 1
            1 1 0 1 0 0 0 1 1 1 0 0 0 1 1
            1 0 0 0 1 1 0 1 1 1 1 1 0 1 1
            1 1 1 0 1 1 0 1 1 1 1 1 0 1 1
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1
            1 1 1 1 0 1 1 1 1 0 0 0 1 0 1
            1 1 1 1 0 1 0 0 0 0 0 0 0 0 0
            1 1 1 0 0 0 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 0 1 1 1 1 1 1 1 1 1];
        blk = flipud([blk, repmat(blk(:,end),1,5)]);
    end
    function [blk,RobotPts] = NOTgate() %#ok<DEFNU>
        % uses a 2x1 block and supply bit to create a NOT gate
        % want 1->0, 0->1
        RobotPts = [ % x,y,color, num, w,h
            %6,8,1,1,1,1;  %X input
            9,8,3,3,1,1; %supply
            12,5,4,4,2,1; %slider
            ];
        for i = 1:numel(RobotPts(:,1))
            RobotPts(i,3) = i;
            RobotPts(i,4) = i;
        end
        blk=[1 1 1 1 1 0 1 1 0 1 1 1 1 1 1  %problem 0->1 OR 0!
            1 1 1 1 1 0 1 0 0 0 1 1 1 1 1
            1 1 1 1 1 0 1 0 1 1 1 1 1 1 1
            1 0 0 0 0 0 0 0 0 0 0 0 0 1 1
            1 1 1 0 1 1 1 1 1 0 1 1 0 1 1
            1 1 1 0 1 0 1 0 0 0 0 0 0 0 0
            1 1 0 0 0 0 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 0 1 1 1 1 1 1 1 1 1];
        blk = flipud([blk, repmat(blk(:,end),1,5)]);
    end
    function [blk,RobotPts] = FANOUTgate() %#ok<DEFNU>
        % uses a 2x1 block and supply bit to create a FANOUT gate
        %  Only outputs ones with the correct input sequence BUT easy to
        %  create zeros
        % want 1 -> 11; 0 -> 00
        %         RobotPts = [ % x,y,color, num, w,h
        %             6,8,1,1,1,1;  %X input
        %             9,8,3,3,1,1; %supply
        %             10,5,4,4,2,1; %slider
        %             ];
        %         for i = 1:numel(RobotPts(:,1))
        %             RobotPts(i,3) = i;
        %             RobotPts(i,4) = i;
        %         end
        %        blk=[1 1 1 1 1 0 1 1 0 1 1 1 1  %allows 1 -> 11, 01, 10
        %             1 1 1 1 1 0 1 0 0 0 1 1 1  %allows 0 -> 00
        %             1 1 1 1 1 0 1 0 1 1 1 1 1
        %             1 0 0 0 0 0 0 0 0 0 0 1 1
        %             1 1 1 1 0 1 1 1 0 1 0 1 1
        %             1 1 1 1 0 1 1 0 0 0 0 0 0
        %             1 1 1 0 0 0 1 1 0 1 1 1 1
        %             1 1 1 1 1 0 1 1 0 1 1 1 1];
        RobotPts = [ % x,y,color, num, w,h
            5,12,1,1,1,1;  %X input
            8,10,3,3,1,1; %supply
            10,5,4,4,2,1; %slider
            ];
        for i = 1:numel(RobotPts(:,1))
            RobotPts(i,3) = i;
            RobotPts(i,4) = i;
        end
        blk=[1 1 1 1 0 1 1 0 1 1 1 1 1 %allows 1 -> 11, 01,
            1 1 1 1 0 1 0 0 0 1 1 1 1 %allows 0 -> 00
            1 1 1 1 0 1 1 1 0 1 1 1 1
            1 1 1 0 0 0 1 0 0 0 1 1 1
            1 1 1 1 1 0 1 0 1 1 1 1 1
            1 0 0 0 0 0 0 0 0 0 0 1 1
            1 1 1 1 0 1 1 1 0 1 0 1 1
            1 1 1 1 0 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 1 1 0 1 1 1 1
            1 1 1 1 1 0 1 1 0 1 1 1 1];
        
        blk = flipud([blk, repmat(blk(:,end),1,5)]);
    end
    
    function [blk,RobotPts] = ddNOTandConnectorgate() %#ok<DEFNU>
        % this is a reversible cross-over switch that is also a NOT gate for
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            5,11,1,1;
            %6,11,2,1;
            12,11,2,2;
            ];
        %            A   A'
        blk=[1 1 1 1 0 1 0 1 ;
            1 1 1 1 0 1 0 1 ;
            1 0 0 0 0 0 0 1 ;
            1 0 1 1 0 1 1 1 ;
            1 0 1 0 0 1 1 1 ;
            1 0 1 0 1 1 1 1 ;
            1 0 1 0 0 0 0 1 ;
            1 0 1 1 1 1 0 1 ;
            1 0 0 0 0 1 0 1 ;
            1 1 1 1 0 1 0 1 ;
            1 1 1 1 0 1 0 1 ];
        %             B   B'
        blkC=[ 1 1 1 0 1 0 1 ;
            1 1 1 0 1 0 1 ;
            0 0 0 0 0 0 1 ;
            0 1 1 0 1 1 1 ;
            0 1 0 0 1 1 1 ;
            0 1 0 1 1 1 1 ;
            0 1 0 0 1 1 1 ;
            0 1 1 0 1 1 1 ;
            0 0 0 0 0 0 1 ;
            1 1 1 0 1 0 1 ;
            1 1 1 0 1 0 1 ];
        blk = flipud([blk,blkC]);
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
    
    function [blk,RobotPts] = ONEWAY_3InORgate() %#ok<DEFNU>
        % this is a NON-reversible OR gate for three inputs
        RobotPts = [
            8,10,1,1;
            10,10,2,2;
            12,10,3,3;
            ];
        %                     x1    x2    x3
        blk=[1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
            1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,0,0];
        blk = flipud(blk);
    end
    
    function [blk,RobotPts] = ONEWAY_RECYCLING() %#ok<DEFNU>
        % UNFINISHED
        RobotPts = [
            7,11,1,1;
            %6,11,2,1;
            9,11,2,2;
            ];
        %               x1    x2    x3
        blk=[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1];
        blk = flipud(blk);
    end
    
    
    function [blk,RobotPts] = SandorsGadgetForCounting() %#ok<DEFNU>
        %         % is a cross between 3(a) and 3(b)
        % that is basically another version of Figure 3(a) (the 3-input OR):
        % one additional dent of size 1 pixel at the left of the first horizontal row, similar to what's in
        % 3(b), where the dent has size m=4.
        % The idea is that we get 1 pixel out if we have at least 2 pixels, but don't get more out if there's more in.
        % This will be a separate (!) figure, which we will plug together 2 times to get a 2^n counter.
        % (OK, strictly speaking it will be a number of inputs through the SAME channel, but it will work
        %  the same way, and should get the idea across.)
        %
        % Maybe you can produce a second version with only one input channel, which exits from the lower
        % right of a preceding cave? And no white pixels in the third row.
        % Then we can fill the fourth row with a sequence of down/right moves,
        % and "cash in" the pixels by moving left/down.
        RobotPts = [
            8,10,1,1;
            10,10,2,2;
            12,10,3,3;
            ];
        %                     x1    x2    x3
        blk=[1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
            1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,0,0];
        blk = flipud(blk);
    end
    
    function [blk,RobotPts] = SandorsGadgetForCountingV2() %#ok<DEFNU>
        %
        % Maybe you can produce a second version with only one input channel, which exits from the lower
        % right of a preceding cave? And no white pixels in the third row.
        % Then we can fill the fourth row with a sequence of down/right moves,
        % and "cash in" the pixels by moving left/down.
        % (1) Make the vertical "chimney" of white pixels below the red horizontal row
        %       white enough to accommodate whatever is in the right "dead-end" half of the red row.
        %       (That way, we will have to empty that row completely when passing a pixel to the next gadget.)
        % (2) Extend the left dead-end in the long white row (parallel to and two rows below the red row
        %       - the one that exits to the right) so that it can also accommodate all extra pixels.
        %      (That way, there is no way of retaining extra pixels and feeding them back into the green column.)
        %
        % (2) is critical, as it makes it clear that "cheating" is impossible. (1) would also be good, but I can wave
        % my hands to explain why this is not a problem.
        RobotPts = [
            9,30,1,1;
            16,27,2,2;
            12,32,3,3;
            ];
        %                     x1
        %        blk=[1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
        %             1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
        %             1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0;
        %             1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0];
        blk=[1,1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
            1,1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0;
            1,1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0];
        blk = flipud([blk;2*blk;blk]);
    end
    
    
    function [blk,RobotPts] = ONEWAY_mInANDgate() %#ok<DEFNU>
        % this is a NON-reversible AND gate for m-inputs
        RobotPts = [
            7,10,1,1;
            9,10,2,2;
            11,10,3,3;
            130,10,4,4;
            15,10,5,5;
            ];
        %                     x1    x2    x3
        blk=[1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0,1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 0, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 0, 1, 2, 0, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 0, 0, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 1, 2, 0, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1];
        blk = flipud(blk);
    end
    function [blk,RobotPts] = ddXORgate()
        % sum bit for dual-rail full adder   d,l,d,r,d,l,d
        RobotPts = [];
        %            A   B   A'  B'
        blk=[1 1 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 1 1 1 0 1 0 1 1 1 0;
            1 0 0 1 0 0 0 0 0 1 1 1 0;
            1 0 0 1 0 0 1 1 1 1 1 1 0;
            1 0 0 0 0 0 0 0 0 0 1 1 0;
            1 1 0 1 1 0 1 1 0 0 1 1 0;
            1 1 0 0 0 0 0 1 0 0 1 1 0;
            1 1 1 1 1 1 0 1 0 0 1 1 0;
            %
            ];
        w = size(blk,2);
        h = size(blk,1);
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+5,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+7,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+9,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+11,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end
    function [blk,RobotPts] = FullAdderCarry() %#ok<DEFNU>
        RobotPts = [];
        %Fails.  Tomorrow. make a 3-XOR
        % dual-rail full adder
        %           A   B   C         A'  B'  C'
        blk=[1 1 1 1 0 1 0 1 0 1 1 1 1 0 1 0 1 0 1;
            1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1;
            1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1;
            1 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 1 1 1;
            1 1 0 1 0 0 1 1 1 1 1 0 1 1 0 0 1 1 1;
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  %Waste
            1 1 0 1 1 0 1 1 1 1 1 0 1 1 0 1 1 1 1;
            1 1 0 0 1 0 1 1 1 1 1 0 0 1 0 1 1 1 1;
            1 1 1 0 1 0 1 1 1 1 1 1 0 1 0 1 1 1 1;
            %      C   S             C'  S'
            ];
        w = size(blk,2);
        for c = 1:8
            str = dec2bin(c-1,3);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+5,9,1+(c-1)*3,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+14,9,1+(c-1)*3,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+7,9,2+(c-1)*3,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+16,9,2+(c-1)*3,2]; %B'
            end
            if str(3) == '1'
                RobotPts(end+1,:) = [w*(c-1)+9,9,3+(c-1)*3,3];  %C
            else
                RobotPts(end+1,:) = [w*(c-1)+18,9,3+(c-1)*3,3]; %C'
            end
            
        end
        blk = flipud(repmat(blk,1,8));
    end
    function [blk,RobotPts] = FullAdderSum() %#ok<DEFNU>
        % sum bit for dual-rail full adder   d,l,d,r,d,l,d
        RobotPts = [];
        %           A   B   C         A'  B'  C'
        blk=[1 1 1 1 0 1 0 1 0 1 1 1 1 0 1 0 1 0 1;
            1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1;
            1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1; %at least 1 / 2
            1 1 0 0 1 1 1 1 1 1 0 1 0 1 0 1 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1; %at least 2 / 1
            1 1 1 0 1 1 1 1 1 1 1 1 0 1 0 1 0 1 1;
            1 1 1 0 0 1 1 1 1 1 1 1 0 1 0 1 0 1 1;
            1 1 1 1 0 1 1 1 1 1 1 1 0 1 0 1 0 1 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1;
            1 0 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1;
            1 0 1 1 1 1 1 1 1 1 1 1 0 0 1 1 0 1 1;
            1 0 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1;
            1 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1;
            1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1;
            1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1;
            %
            ];
        w = size(blk,2);
        h = size(blk,1);
        for c = 1:8
            str = dec2bin(c-1,3);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+5,h,1+(c-1)*3,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+14,h,1+(c-1)*3,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+7,h,2+(c-1)*3,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+16,h,2+(c-1)*3,2]; %B'
            end
            if str(3) == '1'
                RobotPts(end+1,:) = [w*(c-1)+9,h,3+(c-1)*3,3];  %C
            else
                RobotPts(end+1,:) = [w*(c-1)+18,h,3+(c-1)*3,3]; %C'
            end
        end
        blk = flipud(repmat(blk,1,8));
    end
    
    
    function [blk,RobotPts] = ONEWAY_SAFEddNOTgate() %#ok<DEFNU>
        % this is a NON-reversible cross-over switch that is also a NOT gate for
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            7,11,1,1;
            %6,11,2,1;
            9,11,2,2;
            ];
        %               x     x'
        blk=[1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1;
            1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;
            1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1;
            1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1];
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
    
    
    function [blk,RobotPts] = ONEWAY_SAFEddCNTgate() %#ok<DEFNU>
        % this is a NON-reversible CONNECTOR (PIPLINE)
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            7,11,1,1;
            %6,11,2,1;
            9,11,2,2;
            ];
        %               x     x'
        blk=[1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1;
            1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1];
        blk = flipud(blk);
    end
    
    
    
    function [blk,RobotPts] = SIMPLEmaintainDLDR() %#ok<DEFNU>
        % ensure that the sequence DLDR is followed
        % without skips
        RobotPts = [
            4,13,1,1; % x
            6,15,2,2; % x'
            8,15,3,3;  %y
            10,15,4,4;  %y'
            ];
        %                x     x'    y     y'
        blk = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;];
        %           x&y, (x|y)',x|y, (x&y)'
        blk = flipud(blk);
    end
    function [blk,RobotPts] = maintainDLDR() %#ok<DEFNU>
        % includes CAVEs to ensure that the sequence DLDR is followed
        % without skips
        RobotPts = [
            6,13,1,1; % x
            6,15,2,2; % x'
            8,15,3,3;  %y
            10,15,4,4;  %y'
            ];
        %                  x     x'    y     y'
        blk = [ 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0;
            1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0;
            1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0;
            0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0;
            0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0;
            0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0;
            0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;];
        %           x&y, (x|y)',x|y, (x&y)'
        blk = flipud(blk);
    end
    
    
    function [blk,RobotPts] = ddANDgate() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND gate
        RobotPts = [
            4,13,1,1; % x
            6,15,2,2; % x'
            8,15,3,3;  %y
            10,13,4,4;  %y'
            ];
        %                x     x'    y     y'
        blk = [ 1 1 1 0 1 0 1 0 1 0 1 1;
            1 0 0 0 0 0 0 0 1 0 1 1;
            1 0 0 1 1 0 1 1 1 0 1 1;
            1 0 0 0 0 0 0 0 1 0 1 1;
            1 1 0 1 1 0 1 0 1 0 1 1;
            1 1 0 0 1 0 1 0 1 0 1 1;
            1 1 1 0 1 0 1 0 1 0 1 1;
            1 0 0 0 0 0 0 0 0 0 1 1;
            1 0 0 0 1 1 1 0 1 1 1 1;
            1 0 0 0 0 0 1 0 1 1 1 1;
            1 1 0 0 1 0 1 0 1 1 1 1;
            1 1 0 0 0 0 0 0 0 0 1 1;
            1 1 1 0 1 0 1 0 1 0 1 1;];
        %           x&y, (x&y)',x|y, (x|y)'
        blk = flipud(blk);
    end
    
    function [blk,RobotPts] = SAFEddANDgate() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND gate
        RobotPts = [
            4,17,1,1; % x
            6,15,2,2; % x'
            8,17,3,3;  %y
            10,15,4,4;  %y'
            ];
        %                x     x'    y     y'
        blk=[1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1;
            1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            % 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2; %AND/NAND gate
            % 2, 2, 2, 0, 2, 2, 2, 2, 2, 0, 2, 2, 2;
            2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2; %NOR/OR gate
            2, 2, 2, 2, 2, 0, 2, 0, 2, 2, 2, 2, 2;
            ];
        %           x&y, (x|y)',x|y, (x&y)'
        blk = flipud(blk);
    end
    
    function [blk,RobotPts,strTitle] = verySAFEddANDgate() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND/NOR/OR/NAND
        % and can never be reversed more than 1 move.
        %  thi is the first gate we will manufacture
        strTitle = 'x, x'', y, y''';
        RobotPts = [
            6,16,1,1; % x
            8,18,2,2; % x'
            10,16,3,3;  %y
            12,18,4,4;  %y'
            ];
        %                x     x'    y     y'
        blk=[
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 0 0 1 1 1 0 1 1 1 0 1 1 1;
            1 1 0 0 1 1 1 0 1 0 1 0 1 1 1;
            1 0 0 0 0 0 0 0 0 0 1 0 1 1 1;
            1 1 1 0 1 1 1 0 1 0 1 0 1 1 1;
            1 1 1 0 1 0 1 0 1 0 1 0 1 1 1;
            1 1 0 0 0 0 1 0 1 0 1 0 1 1 1;
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 0 0 1 0 1 1 1 0 1 1 1 1 1;
            1 1 0 0 1 0 1 0 1 0 1 1 1 1 1;
            1 0 0 0 0 0 0 0 1 0 1 1 1 1 1;
            1 1 1 0 1 0 1 0 1 0 1 0 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 1 1 1;
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1;
            % 2 2 2 2 2 0 2 0 2 2 2 2 2 2 2;%AND/NAND gate
            % 2 2 2 2 2 2 2 2 2 0 2 0 2 2 2; %NOR/OR gate
            ];
        %           x&y, (x&y)',x|y, (x|y)'
        blk = flipud(blk);
        
    end
    
    function [blk,RobotPts,strTitle] = verySAFEddANDgateSET() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND/NOR/OR/NAND
        % and can never be reversed more than 1 move.
        %  thi is the first gate we will manufacture
        strTitle = 'x, x'', y, y''';
        %                x     x'    y     y'
        blk=[
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 1 0 0 1 1 1 0 1 1 1 0 1 1 1 0;
            1 1 0 0 1 1 1 0 1 0 1 0 1 1 1 0;
            1 0 0 0 0 0 0 0 0 0 1 0 1 1 1 0;
            1 1 1 0 1 1 1 0 1 0 1 0 1 1 1 0;
            1 1 1 0 1 0 1 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 1 0 1 0 1 0 1 1 1 0;
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 1 0 0 1 0 1 1 1 0 1 1 1 1 1 0;
            1 1 0 0 1 0 1 0 1 0 1 1 1 1 1 0;
            1 0 0 0 0 0 0 0 1 0 1 1 1 1 1 0;
            1 1 1 0 1 0 1 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 0;
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1 0;
            % 2 2 2 2 2 0 2 0 2 2 2 2 2 2 2;%AND/NAND gate
            % 2 2 2 2 2 2 2 2 2 0 2 0 2 2 2; %NOR/OR gate
            ];
        %           x&y, (x&y)',x|y, (x|y)'
        % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+6,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+8,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+10,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+12,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end
    
    function [blk,RobotPts,strTitle] = unSAFEddANDgateSET() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND/NOR/OR/NAND
        % and can never be reversed more than 1 move.
        %  thi is the first gate we will manufacture
        strTitle = 'x, x'', y, y''';
        %                x     x'    y     y'
        blk=[1 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 1 0 1 0;
            1 0 0 1 1 0 1 1 1 0 1 0;
            1 0 0 0 0 0 0 0 1 0 1 0;
            %1 1 0 1 1 0 1 0 1 0 1 0;
            1 1 0 0 1 0 1 0 1 0 1 0;
            1 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 0 1 1 1 0 1 1 1 0;
            1 0 0 0 0 0 1 0 1 1 1 0;
            %1 1 0 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 1 0;
            1 1 1 0 1 0 1 0 1 0 1 0;
            ];
        %           x&y, (x&y)',x|y, (x|y)'
        % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+4,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+6,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+8,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+10,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end
    
    function [blk,RobotPts] = SAFEVariableBlk() %#ok<DEFNU>
        % lets the user set a variable t/f on the ith step, and ignores
        % all other r/l switching on steps j ~= i.
        % this is SAFE because  applying a u/d after the deciding r/l
        % switch latches the input.
        RobotPts = [
            10,15,1,1; % x
            6,18,2,2; % x'
            8,18,3,3;  %y
            10,18,4,4;  %y'
            ];
        %
        blk=[1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1;
            1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1;
            1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1;];
        blk = flipud(blk);
    end
    
    function [blk,RobotPts] = VariableBlkIndexed(index) %#ok<DEFNU>
        % lets the user set a variable t/f on the ith step, and ignores
        % all other r/l switching on steps j ~= i.
        % this is SAFE because  applying a u/d after the deciding r/l
        % switch latches the input.
        switch index
            case 1
                RobotPts = [ 11,11,1,1;  ];
            case 2
                RobotPts = [ 9,11,1,1;  ];
            case 3
                RobotPts = [ 7,11,1,1;  ];
            otherwise
                RobotPts = [ 7,11,1,1;  ];
        end
        
        %
        blk{1}=[1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 0 1 1 1 1;
            1 1 1 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 1;
            1 1 1 1 0 1 0 1 1 1 1 1 1 1 0 1 0 1 1 1;
            1 1 1 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1;
            1 1 1 0 1 1 1 0 1 1 1 1 1 0 1 1 1 0 1 1;
            1 1 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 1;
            1 1 0 1 1 1 1 1 0 1 1 1 0 1 1 1 1 1 0 1;
            1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0;
            1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 0;
            ];%               10,                 20
        blk{2}=[1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1;
            1 1 1 1 1 1 1 0 1 0 1 1 1 1 1 1;
            1 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1;
            1 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1;
            1 1 1 0 0 0 1 1 1 1 1 0 0 0 1 1;
            1 1 1 0 1 0 1 1 1 1 1 0 1 0 1 1;
            1 1 0 0 0 0 0 1 1 1 0 0 0 0 0 1;
            1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1;
            1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0;
            1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
            ]; %           8              16
        blk{3}=[1 1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 0 0 1 1 1 1;
            1 1 1 1 1 0 1 0 1 1 1 1;
            1 1 1 1 0 0 0 0 0 1 1 1;
            1 1 1 1 0 1 1 1 0 1 1 1;
            1 1 1 0 0 0 0 0 0 0 1 1;
            1 1 1 0 1 1 1 1 1 0 1 1;
            1 1 0 0 0 1 1 1 0 0 0 1;
            1 1 0 1 0 1 1 1 0 1 0 1;
            1 0 0 0 0 0 1 0 0 0 0 0;
            1 1 1 1 1 0 1 1 1 1 1 0;
            ];%        6          12
        blk{4}=[1, 1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 0 0 1 1 1 1;
            1 1 1 1 1 0 1 0 1 1 1 1;
            1 1 1 1 0 0 0 0 0 1 1 1;
            1 1 1 1 0 1 1 1 0 1 1 1;
            1 1 1 0 0 0 0 0 0 0 1 1;
            1 1 1 0 1 1 1 1 1 0 1 1;
            1 1 0 0 0 0 0 0 0 0 0 1;
            1 1 0 1 1 1 1 1 1 1 0 1;
            1 0 0 0 1 1 1 1 1 0 0 0;
            1 1 1 0 1 1 1 1 1 1 1 0;
            ];%    4              12
        blk = flipud([blk{index},ones(size(blk{index}(:,1)))] );
    end
    
    function [blk,RobotPts] = VariableBlk() %#ok<DEFNU>
        % lets the user set a variable t/f on the ith step, and ignores
        % all other r/l switching on steps j ~= i.
        RobotPts = [
            9,13,1,1; % x
            6,16,2,2; % x'
            8,16,3,3;  %y
            10,16,4,4;  %y'
            ];
        %
        blk=[1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1;
            1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1;
            1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1;
            1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1;];
        blk = flipud(blk);
    end
    
    function blk = GateBlk() %#ok<DEFNU>
        blk = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
    end
    function ANDGate = ANDGate() %#ok<DEFNU>
        ANDGate=[1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0;
            1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1];
    end
    function ORGate = ORGate()  %#ok<DEFNU>
        ORGate=[1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1;
            1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1];
    end
    function NOTGate = NOTGate()  %#ok<DEFNU>
        NOTGate=[1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1;
            1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0;
            1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1];
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