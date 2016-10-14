function jellyBlocksSimple()
% Implements a game, jelly blocks, where the arrow keys move all
% unobstructed blocks by one unit, and blocks that touch are joined
% according to various rules

G.fig = figure(1);
G.numCommands = 0;
G.totalMoves = 0;

set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Jelly Blocks');




% build environment
G.game = flipud([
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 2 2 0 0 3 3 0 0 1 0 0 4 0 0 0 0 1;
    1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 5 5 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 4 4 1;
    1 0 0 0 0 3 3 0 5 0 5 5 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 5 0 0 5 0 0 0 0 0 4 1;
    1 0 0 0 0 0 0 0 5 5 5 5 0 0 0 0 0 4 1;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    ]);
G.obstacle_pos = (G.game==1);
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    hsv(numel(unique(G.game))-2);];
colormap(G.colormap);
G.axis=imagesc(G.game);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off','color',0.8*[1,1,1]);
%set(G.axis,'edgealpha',.08)
axis equal

% build list of items
makeItemList();
drawGameboard();



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
        end
        drawGameboard();
        
        %move everything: check for collisions, make list of objects that must be reverted
        G.game = zeros(size(G.obstacle_pos));
        revertList = [];
        for i = 1:numel(G.items)
            for j = 1:size(G.items{i},1)
                G.items{i}(j,1:2) =  G.items{i}(j,1:2)+step;
                G.game(G.items{i}(j,1),G.items{i}(j,2)) = i;
                if G.obstacle_pos(G.items{i}(j,1),G.items{i}(j,2))==true
                    if isempty(find(revertList == i, 1))
                        revertList(end+1) = i;
                    end
                end
            end
        end
        % go recursively through revert list, moving them back in the image
        % and adding any shapes they collide with back to the
        i = 1;
        while i<=numel(revertList)
            item2revert = revertList(i);
            for j = 1:size(G.items{item2revert},1)
                G.items{item2revert}(j,1:2) =  G.items{item2revert}(j,1:2)-step;
                collisionItem = G.game(G.items{item2revert}(j,1),G.items{item2revert}(j,2));
                if collisionItem ~= item2revert && collisionItem ~= 0
                    
                    if isempty(find(revertList == collisionItem, 1))
                        revertList(end+1) = collisionItem;
                    end
                end
            end
            i=i+1;
        end
        
        if numel(revertList) < numel(G.items)
            display('we could still move')
        end
        
        drawGameboard();
        makeItemList();
        
    end
    function drawGameboard()
        %draw obstacles
        G.game = uint8(G.obstacle_pos);
        for i = 1:numel(G.items)
            for j = 1:size(G.items{i},1)
                G.game(G.items{i}(j,1),G.items{i}(j,2)) = G.items{i}(j,3);
            end
        end
        
        set(G.axis,'CData',G.game)
    end



    function makeItemList()
        G.items = {};
        for x = 1:size(G.game,2)
            for y = 1:size(G.game,1)
                if G.game(y,x)>1
                    num = numel(G.items)+1;
                    G.items{num} = [];
                    addItems(y,x,G.game(y,x),num);
                end
            end
        end
    end

    function  addItems(y,x,color,num)
        if G.game(y,x) == color
            G.game(y,x) = 0;
            %                            y,x,color
            G.items{num}(end+1,:) = [y,x,color];
            addItems(y+1,x,color,num);
            addItems(y-1,x,color,num);
            addItems(y,x+1,color,num);
            addItems(y,x-1,color,num);
        end
    end


end