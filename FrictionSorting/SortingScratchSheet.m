

%image = imread('Mona_Lisa25x25.png');
image = imread('Mona_Lisa6x6.png');
rows = size(image,1);
cols = size(image,1);

%random permutation of the numbers 
iM = reshape(randperm(rows*cols),rows,cols);
gM = reshape(1:rows*cols,rows,cols);


%arrange by gradient
imgGray = rgb2gray(image);
[B,I] = sort(imgGray(:));
iM = reshape(I,rows,cols);

%                cols
%           1 2 3 4 5 6
%         1
% rows    2
%         3
%         4
%         5

% step 1: place the particles so particles in  column i are in row i
s1M = zeros(size(gM));
rowCounts = zeros(1,rows);
for r = rows:-1:1
    for c = 1:cols
        % take the next item, and place it in the row of s1M corresponding
        % to the column.
        [i,j] = find(gM==iM(r,c));
        s1M(  j, rows-rowCounts(j)) = iM(r,c);
        rowCounts(j) = rowCounts(j)+1;        
    end
end

% step 2: place particles in correct position
s2M = zeros(size(gM));
rowCounts2 = zeros(1,rows);
for r = rows:-1:1
    for c = 1:cols
        % 
        [i,j] = find(gM==s1M(r,c));
        s2M(  i, rows-rowCounts2(i)) = s1M(r,c);
        rowCounts2(i) = rowCounts2(i)+1;        
    end
end


image(2,:,1) = 255; %MAKE A COLUMN RED
image(:,5,2) = 255; % MAKE A ROW GREEN

% figure(1); clf
% for r = 1:size(im,2)
%     for c = 1:size(im,1)
%         % take the next item, and place it in the row of s1M corresponding
%         % to the column.
%         %rectangle('Position',[c,-r,1,1],'FaceColor',im(r,c,:))  
%         
%         [i,j] = find(iM==gM(r,c));
%         rectangle('Position',[j,-i - 0,1,1],'FaceColor',im(r,c,:))  
%         
%          [i,j] = find(s1M==gM(r,c));
%         rectangle('Position',[j,-i - 30,1,1],'FaceColor',im(r,c,:)) 
%         
%          [i,j] = find(s2M==gM(r,c));
%         rectangle('Position',[j,-i - 60,1,1],'FaceColor',im(r,c,:)) 
% 
%     end
% end
% axis equal


%Show step 1
tileNum = 35;
f2 = figure(2); clf
set(f2,'Name',['Step 1, tile ',num2str(tileNum)])

rectangle('Position',[-2,-1,rows+5,(2*rows+3+3)],'FaceColor','k') %boundary
rectangle('Position',[-1,0,rows+3,(2*rows+3+1)],'FaceColor','w') %workspace

rectangle('Position',[1,1,rows,rows],'FaceColor',[.9,1,.9],'EdgeColor','none') 

rectangle('Position',[1,rows+2,rows,rows],'FaceColor',[1,.9,.9],'EdgeColor','none') 

%TODO: draw staging and assembly areas
count = 1;

rowCounts = zeros(1,rows);
for r = rows:-1:1
    for c = 1:cols
        % take the next item, and place it in the row of s1M corresponding to the column.
        [i,j] = find(gM==iM(r,c));
        
        if count <= tileNum
            rectangle('Position',[ rows-rowCounts(j), 2*rows+2-j, 1, 1],'FaceColor',image(i,j,:))  
            rowCounts(j) = rowCounts(j)+1;  
        else
            rectangle('Position',[ c,rows+1-r,1,1],'FaceColor',image(i,j,:)) 
        end
        count = count+1;


    end
end
axis equal


%Show step 2
f3 = figure(3); clf
set(f3,'Name',['Step 2, tile ',num2str(tileNum)])

rectangle('Position',[-2,-1,rows+5,(2*rows+3+3)],'FaceColor','k') %boundary
rectangle('Position',[-1,0,rows+3,(2*rows+3+1)],'FaceColor','w') %workspace

rectangle('Position',[1,1,rows,rows],'FaceColor',[.9,1,.9],'EdgeColor','none') 

rectangle('Position',[1,rows+2,rows,rows],'FaceColor',[1,.9,.9],'EdgeColor','none') 

%TODO: draw staging and assembly areas
count = 1;

rowCounts2 = zeros(1,rows);
for r = rows:-1:1
    for c = 1:cols
        % take the next item, and place it in the correct row of s1M.
        [i,j] = find(gM==s1M(r,c));
        
        if count <= tileNum
            %rowCounts(j) = rowCounts(j)+1;    
            rectangle('Position',[ rows-rowCounts2(i), 2*rows+2-i, 1, 1],'FaceColor',image(i,j,:))
            
           % s2M(  i, rows-rowCounts2(i)) = s1M(r,c);
             rowCounts2(i) = rowCounts2(i)+1;      
        else
            rectangle('Position',[ c,rows+1-r,1,1],'FaceColor',image(i,j,:)) 
        end
        count = count+1;


    end
end
axis equal

