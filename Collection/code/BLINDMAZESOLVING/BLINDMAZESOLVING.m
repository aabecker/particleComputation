%% BLIND MAZE SOLVING...
% Maximize the probability of getting the robot to a destination.
% Number of moves/iterations is limited per maze. 
% Play the game manually, record moves, run program again to 
% re-initialize robot at a different location in the same maze and give
% your input commands to the 'auto' option, are you able to get similar
% results regardless of your intial robot start location??

% Michael Umeano  05/11/2015


% % Map 1...
  ObstacleMap =flipud(...
   [1, 1, 1, 1, 1, 1, 1, 1;
    1, 0, 0, 0, 0, 0, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 1;
    1, 1, 1, 1, 1, 1, 1, 1;]);
length (ObstacleMap)


%% RANDOM MAZE GENERATOR. %Make your own mazes
% figure(5)
% %initialize world (obstacles are 1, freespace is 0)
% origoMap = makeMaze(4);
% % for i = 1:numel(origoMap)
% for i = 2:size(origoMap,1)-1
%     for j = 2:size(origoMap,2)-1
% if origoMap(i,j) == 2
% origoMap(i,j) = 1;
% else if origoMap(i,j) == -2
% origoMap(i,j) = 0;
%     end;end;end;end;
% 
% OPTIONAL: Increase maze complexity by removing adjacent walls
% for i = 1:numel(origoMap)         
%     if origoMap(i) == 1
%         origoMap(i) = randi([0,1]);
%     elseif origoMap(i) == 2
%         origoMap(i) = 1;
%     end;end;
% obstacleMap = flipud(origoMap)

% dlmwrite('Mymaze_1_4.txt',obstacleMap) % Store maze to .txt file 
% obstacleMap = loadMaze('Mymaze.txt'); % Load stored Maze 



%%
prompt = 'Enter Maze complexity... 1-10 ---> ';
x = input(prompt);
switch x
    case 1
        ObstacleMap = loadMaze('Mymaze_1_1.txt');
        numIters = 10;
    case 2
        ObstacleMap = loadMaze('Mymaze_1_2.txt');
        numIters = 12;
    case 3 
        ObstacleMap = loadMaze('Mymaze_1_3.txt');
        numIters = 15;
    case 4 
        ObstacleMap = loadMaze('Mymaze_1_4.txt');
        numIters = 20;
    case 5 
        ObstacleMap = loadMaze('Mymaze_1_10.txt');
        numIters = 30;
    case 6 
        ObstacleMap = loadMaze('Mymaze_2_10.txt');
        numIters = 40;
    case 7 
        ObstacleMap = loadMaze('Mymaze_3_10.txt');
        numIters = 50;
    case 8 
        ObstacleMap = loadMaze('Mymaze.txt');
        numIters = 90;
end

prompt = 'Automatic Control??? Enter true or false--> ';
auto = input(prompt);
if auto == true
    prompt = 'Moves(max 100 u-up,d-down,r-right,l-left in quotes.) = ';
    moves  = input(prompt);
%        moves = 'llllllllllddddddddddlllllllllluulluulluulluullulululul...
%            ululdldldldldlrddddddddddddldddddddddllllllullullulldddddddl';
    SimpleRobotWithBayesRuleHW2(ObstacleMap, true, numIters,  moves)
else
    SimpleRobotWithBayesRuleHW2(ObstacleMap, 'numIters', numIters, 'posRobot', [2,2])
end
