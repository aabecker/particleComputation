function gadgets3SAT
% demonstrates NP proof. My goal is to do everything with the input
% sequence {D,L,D,R}
%
% TODO: i could remove many unnecessary lines...
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

% 1. Multiple copies of the 4 variables A, B, C, D, are initialized to arbitrary T/F values
% 2. 4 three-input or gates of these variables create 4 clauses,
% i.e. %(A|~B|C),  (B|~C|D),  (~A|B|D),  (~A|~C|D|)
% 3. A gadget that checks if at least 4 clauses are true
% 4. a recycling system that can return the pixels to the beginning to start

%create obstacle map and draw it
% (A|~B|C),  (B|~C|D),  (~A|B|D),  (~A|~C|D|)
[b1,RobotPts] =VariableSetOR(1,2,3,     0,1,0);
[b2,RobotPts] =VariableSetOR(2,3,4,     1,1,0);
[b3,RobotPts] =VariableSetOR(1,2,4,     1,0,0);
[b4,RobotPts] =VariableSetOR(1,3,4,     1,1,0);
% [b1,RobotPts] = SAFEVariableBlk();
% [b2,RobotPts] = ONEWAY_SAFEddCNTgate(10,36,42,   14,16,18,   size(b1,2));
% [b3,RobotPts] = orAND3SAT(size(b1,2));
 varOrs = [b1,b2,b3,b4];
 
 
 and3SatBlk = AND3SAT(size(varOrs,2));
 
 inx = find(0==varOrs(end,:));
spreadVars = ones(numel(inx)+1, size(varOrs,2));
for i = 1:numel(inx)
    spreadVars(i,inx(i):end) = 0;
end
 
 % add ones at end to provide room in recycling to avoid back-flow
 blk = [ones(3*4-5, size(varOrs,2)); 
     and3SatBlk;
     varOrs;
     spreadVars;
     ];

 blk = [blk, zeros(size(blk,1),12),ones(size(blk,1),1)];    %add recycling
 blk(end,:) = 1; %cap the top
  %restrict flow so only a vertical column can pass through
  blk(end - 13,end-12:end-2) = 1; 
 %add bottom row
 G.obstacle_pos = [ ones(1,size(blk,2));blk];
 %add left side
 G.obstacle_pos = [ ones(size(G.obstacle_pos,1),1), G.obstacle_pos];
 RobotPts = [ repmat(size(G.obstacle_pos,2)-1,1,12); 1+(1:12);[1:12];[1:12]]';
 
 
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
axis tight
hold on
G.title = title('press arrows keys to move');


%end
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

for hi = 1: numRobots
    G.hRobotsPast10(hi) =  createRobotPath( RobotPts(hi,:), 0.3);
    G.hRobotsPast9(hi) =  createRobotPath( RobotPts(hi,:), 0.3);
    G.hRobotsPast8(hi) =  createRobotPath( RobotPts(hi,:), 0.35);
    G.hRobotsPast7(hi) =  createRobotPath( RobotPts(hi,:), 0.4);
    G.hRobotsPast6(hi) =  createRobotPath( RobotPts(hi,:), 0.45);
    G.hRobotsPast5(hi) =  createRobotPath( RobotPts(hi,:), 0.5);
    G.hRobotsPast4(hi) =  createRobotPath( RobotPts(hi,:), 0.55);
    G.hRobotsPast3(hi) =  createRobotPath( RobotPts(hi,:), 0.6);
    G.hRobotsPast2(hi) =  createRobotPath( RobotPts(hi,:), 0.7);
    G.hRobotsPast(hi) =  createRobotPath( RobotPts(hi,:), 0.8);
    G.hRobots(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(hi,4),:));
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

function [blk] = AND3SAT(wid) 
    myAND=[ 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
            1 1 1 1 1 0 1 2 2 2 1 1 1 1 1 1;
            1 1 1 1 1 0 1 2 0 2 1 1 1 1 1 1;
            1 1 1 1 0 0 0 0 0 2 1 1 1 1 1 1;
            1 1 1 1 1 1 1 2 0 2 1 1 1 1 1 1;
            1 1 1 1 1 1 1 2 2 2 1 1 1 1 1 1;];
        % add AND gate
        blk = flipud([myAND, repmat(myAND(:,3),1,wid-size(myAND,2))]);
end

   function [blk,RobotPts] = orAND3SAT(wid) 
        % this is a NON-reversible OR gate for three inputs
        RobotPts = [
            14,17,1,1;
            16,17,2,2;
            18,17,3,3;
            ];
        %               7              15
        %              x1  x2  x3
       blk=[1 1 1 1 1 1 0 1 0 1 0 1 1 1 1;
            1 1 1 1 1 1 0 1 0 1 0 1 1 1 1;
            1 1 0 0 0 1 0 1 0 1 0 1 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 0 0 0 1 1 1 1 1 1 1 1 1 1;
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
            1 1 0 1 1 1 1 1 1 1 1 1 1 1 1;
            1 1 0 1 1 1 1 1 0 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 0 1 1 1 1 1 1,];
         buffer=[1 1,;
            1 1 ;
            1 1;
            1 1;
            1 1;
            1 0;
            1 1;
            1 1;
            1 1;
            1 1];
        
        myAND=[
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
            1 1 1 1 1 0 1 2 2 2 1 1 1 1 1 1;
            1 1 1 1 1 0 1 2 0 2 1 1 1 1 1 1;
            1 1 1 1 0 0 0 0 0 2 1 1 1 1 1 1;
            1 1 1 1 1 1 1 2 0 2 1 1 1 1 1 1;
            1 1 1 1 1 1 1 2 2 2 1 1 1 1 1 1;];
        
        %construct OR gates
        blk = [buffer(:,1), repmat(buffer(:,2),1,6), blk,blk,blk,blk];
        %blk = [blk; myAND, ones(size(myAND,1),size(blk,2)-size(myAND,2))];
        % add AND gate
        blk = [blk; myAND, repmat(myAND(:,2),1,size(blk,2)-size(myAND,2))];
        
        
        
        %add recycling
        blk = [blk, [zeros(size(blk,1),6),ones(size(blk,1),1)]];
        %add bottom row
        blk = [blk; ones(1,size(blk,2))];
        backg = ones(size(blk,1),wid);
        backg(1:size(blk,1),1:size(blk,2)) = blk;
        blk = flipud(backg);
   end

function [blk,RobotPts] = ONEWAY_SAFEddCNTgate(i1,i2,i3,o1,o2,o3,wid) %#ok<DEFNU>
        % this is a NON-reversible CONNECTOR (PIPLINE)
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            i1,15,1,1;
            i2,15,2,2;
            i3,15,3,3;
            ];
        ins = sort([i1,i2,i3]);
        outs = sort([o1,o2,o3]);
        blk = ones(15,max([[ins,outs]+2,wid]));
        %down 
        blk(1:7,i1) = 0;
        blk(1:5,i2) = 0;
        blk(1:3,i3) = 0;
        %left
        blk(7,7:i1+1) = 0;
        blk(5,5:i2+1) = 0;
        blk(3,3:i3+1) = 0;
        %down        
        blk(2:14,3) = 0;
        blk(2:12,5) = 0;
        blk(2:10,7) = 0;
        %right
        blk(10,2:o1) = 0;
        blk(12,2:o2) = 0;
        blk(14,2:o3) = 0;
        %down
        blk(9:15,o1) = 0;
        blk(11:15,o2) = 0;
        blk(13:15,o3) = 0;
        %                   a   b   c
%        blk=[1 1 1 1 1 1 1 1 0 1 0 1 0 1 1;
%             1 1 0 1 0 1 0 1 0 1 0 1 0 1 1;
%             1 1 0 0 0 0 0 0 0 0 0 0 0 0 1;
%             1 1 0 1 0 1 0 1 0 1 0 1 1 1 1;
%             1 1 0 1 0 0 0 0 0 0 0 0 1 1 1;
%             1 1 0 1 0 1 0 1 0 1 1 1 1 1 1;
%             1 1 0 1 0 1 0 0 0 0 1 1 1 1 1;
%             1 1 0 1 0 1 0 1 1 1 1 1 1 1 1;
%             1 1 0 1 0 1 0 1 0 1 1 1 1 1 1;
%             1 0 0 0 0 0 0 0 0 1 1 1 1 1 1;
%             1 1 0 1 0 1 1 1 0 1 0 1 1 1 1;
%             1 0 0 0 0 0 0 0 0 0 0 1 1 1 1;
%             1 1 0 1 1 1 1 1 0 1 0 1 0 1 1;
%             1 0 0 0 0 0 0 0 0 0 0 0 0 1 1;
%             1 1 1 1 1 1 1 1 0 1 0 1 0 1 1];
        blk = flipud(blk);
    end

function [blk,RobotPts] = VariableSetOR(v1,v2,v3,p1,p2,p3)
    % v values set the selection stage, o values set t/f as the output sent
    % to OR
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
        blk = cell(4,1);
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
       % A 10,20,  B8,16,    C6,12,D 4, 12
       port = [10,20;8,16;6,12;4,12];
       %(A|~B|C),  (B|~C|D),  (~A|B|D),  (~A|~C|D|)
       %10,36,42    8,
       VarSet = flipud([blk{v1},blk{v2},blk{v3}]);
       if p3
         VarSet = [VarSet, ones(size(VarSet(1),2))];
       end
       
         in1 = port(v1,p1+1);
         in2 = port(v1,2)+port(v2,p2+1);
         in3 = port(v1,2)+port(v2,2)+port(v3,p3+1);
       Piping =  ONEWAY_SAFEddCNTgate(in1,in2,in3,   14,16,18,   size(VarSet,2));

       
        %               7              15
        %              x1  x2  x3
       blk=[1 1 1 1 1 1 0 1 0 1 0 1 1 1 1;
            1 1 1 1 1 1 0 1 0 1 0 1 1 1 1;
            1 1 0 0 0 1 0 1 0 1 0 1 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 0 0 0 1 1 1 1 1 1 1 1 1 1;
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
            1 1 0 1 1 1 1 1 1 1 1 1 1 1 1;
            1 1 0 1 1 1 1 1 0 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 0 1 1 1 1 1 1,];
         buffer=[1 1,;
            1 1 ;
            1 1;
            1 1;
            1 1;
            1 0;
            1 1;
            1 1;
            1 1;
            1 1];
        
       %construct OR gates
       Or3in = [ repmat(buffer(:,2),1,7),blk];       
       Or3in = flipud([Or3in, repmat(buffer(:,2),1,1+size(Piping,2)-size(Or3in,2))]);
       blk =[Or3in;
             Piping,ones(size(Piping,1),1);
             zeros(1,size(VarSet,2)+1);
             VarSet,ones(size(VarSet,1),1)];% [Or3in;Piping;VarSet];
        
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
      blk1=[1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1;
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
      blk2=[1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1;
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
      blk3=[1 1 1 1 1 1 0 1 1 1 1 1;
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
      blk4=[1, 1 1 1 1 1 0 1 1 1 1 1;
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
       % A 10,20,  B8,16,    C6,12,D 4, 12
       %(A|~B|C),  (B|~C|D),  (~A|B|D),  (~A|~C|D|)
       %10,36,42    8,
         blk = flipud([blk1,blk2,blk3,  blk2, blk3, blk4,   blk1,blk2,blk4,]);%   blk1, blk3,blk4]);
    end

    

    function updatePastPath( hOldPath, hOlderPath)
        for ni = 1:size(RobotPts,1)
            set(hOlderPath(ni),'Position', get(hOldPath(ni),'Position'), ...
                'Curvature', get(hOldPath(ni),'Curvature'));
            uistack(hOlderPath(RobotPts(ni,3)),'top');
        end
    end

    function moveto(key)
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
                rectangle('Position',[x-1/2,y-1/2,xd+1,yd+1],'Curvature',[1/(1+xd),1/(1+yd)],'FaceColor',[1,1,1]-([1,1,1]-colors(RobotPts(ni,4),:))*0.3,'LineStyle','none');
                uistack(G.hRobotsPast(RobotPts(ni,3)),'top');
                set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
            else
                set(G.hRobotsPast(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1],'Curvature',[1,1]);
            end
            
        end
        for ni = 1:size(RobotPts,1)
            uistack(G.hRobots(RobotPts(ni,3)),'top');
        end
        
    end



end