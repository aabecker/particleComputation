% Maximum Moves Plot

x=[2 4 6 8 10 20 30 40 50 60 70 80 90 100 110 120];
y=[27 35 43 51 59 99 139 179 219 259 299 339 379 419 459 499];%Row Part
% y=log(y);
y1=[23 27 31 35 39 59 79 99 119 139 159 179 199 219 239 259];%Column Part
% y1=log(y1);
plot(x,y,'m',x,y1,'r','LineWidth',2)
xlabel('Number of Tiles (\it{n})')
ylabel('Maximum Cycle Time (unit distance moves)')
title('Maximum Cycle Plot')
axis tight
hold on
x1=[24 32 42 80 100];
y2=[80 90 120 200 250];
plot(x1,y2,'s','MarkerSize',4,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6])
axis tight
legend('Row Part','Column Part','Arbitrary Shaped Parts','Location','Best')

% % % % Row Part Calculation 
% %  hwidth=4+(2*ceil(10/2)+8);
% % r=((2*9)+hwidth)-3;
% % u=3;
% % d=5;
% % left=(10)*2;
% % sum=r+u+d+left
% % 
% 
% % % Column Part Calculation 
% hwidth=4+(2*ceil(10/2)+8);
% r=2+hwidth;
% u=3;
% d=3+10;
% left=2;
% sum=r+u+d+left;