function jellyBlocks()
% Implements a logic game, similar to "Jelly Blocks" and "Denki Blocks".
% Blocks move on a 2D grid with unmoveable black obstacles.
% The arrow keys move all unobstructed blocks by one unit, and blocks of
% the same color that touch are joined. The goal is to join all blocks of
% the same color.
%
%  Aaron T. Becker
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G.fig = figure(1);
G.numCommands = 0;
G.totalMoves = 0;

set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Jelly Blocks');

% build environment
loadGameBoards();

G.GameNum = 5;
G.titleLine1 = 'Join blocks of the same color! Arrow Keys to move, `r` to reset, `u` to undo';
initGame();

    function initGame()
        G.game = G.gameBoard{G.GameNum};
        G.obstacle_pos = (G.game==1);
        G.uniqueItemColors = numel(unique(G.game))-2;
        G.colormap = [  1,1,1; %Empty = white
            0,0,0; %obstacle
            hsv(G.uniqueItemColors);];
        colormap(G.colormap);
        G.axis=imagesc(G.game);
        set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','on','color',0.8*[1,1,1],'XColor',0.8*[1,1,1],'YColor',0.8*[1,1,1]);
        %set(G.axis,'edgealpha',.08)
        axis equal
        title(G.titleLine1)
        G.histIncrement = 10;
        G.historyLength = G.histIncrement;
        G.history = uint8(zeros([size(G.game,1),size(G.game,2),G.historyLength]));
        G.moveCount = 0;
        title({G.titleLine1; [num2str(G.moveCount),' moves']})
        set(G.axis,'CData',G.game)
        makeItemList();
        
        G.hTextWin = text(size(G.game,2)/2,size(G.game,1)/2,'');
        checkForWin();
    end

    function  addItems(y,x,color,num)
        if G.tempGame(y,x) == color
            G.tempGame(y,x) = 0;
            %                            y,x,color
            G.items{num}(end+1,:) = [y,x,color];
            addItems(y+1,x,color,num);
            addItems(y-1,x,color,num);
            addItems(y,x+1,color,num);
            addItems(y,x-1,color,num);
        end
    end

    function keyhandler(src,evnt) %#ok<INUSL>
        key = evnt.Key;
        step = [0,0];
        if strcmp(key,'leftarrow') || strcmp(key,'-x') %-x
            step = -[0,1];
        elseif strcmp(key,'rightarrow')|| strcmp(key,'+x') %+x
            step = [0,1];
        elseif strcmp(key,'uparrow')|| strcmp(key,'+y') %+y
            step = [1,0];
        elseif strcmp(key,'downarrow')|| strcmp(key,'-y') %-y
            step = -[1,0];
        elseif  strcmp(key,'r')
            initGame();
        elseif strcmp(key,'n') && G.isWin
            G.GameNum = G.GameNum+1;
            if G.GameNum>numel(G.gameBoard)
                G.GameNum = 1;
            end
            initGame();
        elseif  strcmp(key,'u')
            if G.moveCount > 1
                G.game = G.history(:,:,G.moveCount-1);
                G.moveCount = G.moveCount-1;
                set(G.axis,'CData',G.game)
                title({G.titleLine1; [num2str(G.moveCount),' moves']})
            else
                initGame();
            end
        end
        
        if ~isequal(step, [0,0])
            %move everything: check for collisions, make list of objects that must be reverted
            G.game = zeros(size(G.obstacle_pos));
            revertList = zeros(numel(G.items),1);
            num2revert = 0;
            
            for i = 1:numel(G.items)
                for j = 1:size(G.items{i},1)
                    G.items{i}(j,1:2) =  G.items{i}(j,1:2)+step;
                    G.game(G.items{i}(j,1),G.items{i}(j,2)) = i;
                    if G.obstacle_pos(G.items{i}(j,1),G.items{i}(j,2))==true
                        if isempty(find(revertList == i, 1))
                            num2revert = num2revert+1;
                            revertList(num2revert) = i;
                        end
                    end
                end
            end
            % go recursively through revert list, moving them back in the image
            % and adding any shapes they collide with back to the
            i = 1;
            while i<=num2revert
                item2revert = revertList(i);
                for j = 1:size(G.items{item2revert},1)
                    G.items{item2revert}(j,1:2) =  G.items{item2revert}(j,1:2)-step;
                    collisionItem = G.game(G.items{item2revert}(j,1),G.items{item2revert}(j,2));
                    if collisionItem ~= item2revert && collisionItem ~= 0
                        
                        if isempty(find(revertList == collisionItem, 1))
                            num2revert = num2revert+1;
                            revertList(num2revert) = collisionItem;
                        end
                    end
                end
                i=i+1;
            end
            drawGameboard();
            %save move
            if (G.moveCount == 0 && ~isequal(G.game, G.gameBoard{G.GameNum})) || ...
                    (G.moveCount > 0 && ~isequal(G.game, G.history(:,:,G.moveCount)))
                G.moveCount = G.moveCount+1;
                if G.moveCount > G.historyLength
                    G.history(1,1,G.historyLength+G.histIncrement) = 0;
                    G.historyLength = G.historyLength+G.histIncrement;
                end
                G.history(:,:,G.moveCount) = G.game;
            end
        end
        
        makeItemList();
        checkForWin();
        title({G.titleLine1;
            [num2str(G.moveCount),' moves, ', num2str(numel(G.items)),' items, goal: ',num2str(G.uniqueItemColors)]})
        
    end

    function checkForWin()
        G.isWin = (G.uniqueItemColors == numel(G.items));
        if G.isWin
            set(G.hTextWin, 'color','w',...
                'Position',[0.5+size(G.game,2)/2,size(G.game,1)/2,0],...
                'String','Congratulations! ''n'' for next board',...
                'FontSize',24,'HorizontalAlignment','center' );
            colormap(G.colormap*.4);
        else
            set(G.hTextWin,'String','');
            colormap(G.colormap);
        end
    end


    function drawGameboard()
        %draw obstacles
        G.game = uint8(G.obstacle_pos);
        %draw items
        for i = 1:numel(G.items)
            for j = 1:size(G.items{i},1)
                G.game(G.items{i}(j,1),G.items{i}(j,2)) = G.items{i}(j,3);
            end
        end
        set(G.axis,'CData',G.game)
    end

    function makeItemList() %parses gameboard and creates a list of distinct objects (moveable blocks)
        G.items = {};
        G.tempGame = G.game;
        for x = 1:size(G.game,2)
            for y = 1:size(G.game,1)
                if G.tempGame(y,x)>1
                    num = numel(G.items)+1;
                    G.items{num} = [];
                    addItems(y,x,G.tempGame(y,x),num);
                end
            end
        end
    end

    function loadGameBoards()
        G.gameBoard{1} = uint8(flipud([
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 2 2 0 0 3 3 0 0 2 2 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            ]));
        G.gameBoard{2} = uint8(flipud([
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 2 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 2 0 2 2 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 2 0 1 2 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 2 2 2 2 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            ]));
        G.gameBoard{3} = uint8(flipud([
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 1;
            1 0 0 0 2 1 0 0 1 1 1 0 0 2 0 0 0 0 1;
            1 0 0 0 2 2 0 0 0 0 0 0 2 2 0 0 0 0 1;
            1 0 0 0 2 1 0 0 1 1 1 0 0 2 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1;
            1 2 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 2 1;
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            ]));
        
        G.gameBoard{4} = uint8(flipud([
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 2 2 2 0 0 0 0 1;
            1 0 0 0 2 2 0 0 0 0 0 2 1 2 0 0 0 0 1;
            1 0 0 0 2 1 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 2 2 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 0 0 1;
            1 0 0 0 0 0 2 1 2 0 0 0 0 0 2 2 0 0 1;
            1 0 0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            ]));
        G.gameBoard{5} = uint8(flipud([
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            1 0 0 0 4 4 4 0 0 1 0 0 0 0 0 0 0 0 1;
            1 0 0 0 2 2 2 0 0 0 3 0 0 0 0 0 0 0 1;
            1 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 1;
            1 0 0 0 0 0 2 4 2 4 2 4 0 0 3 0 0 0 1;
            1 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
            ]));
    end
end