% function []= RedHopper (NumCopies,NumRedTiles)
function [Hopper]= RedHopper ()
% This function makes the red hopper in the factory
NumCopies=8; %Number of copies of the polyomino
NumRedTiles=8; %Number of red tiles in one polyomino
obs=1;
rows=(NumRedTiles*2)+3; %Initialize rows and columns of the hopper
columns=(NumRedTiles*3)+1+NumCopies;
Hopper=obs*ones(rows,columns);
Hopper(3+NumRedTiles:end-1,2:1+NumCopies)=2; %Place red tiles inside the hopper
Hopper(2+NumRedTiles,2)=0; %Output shoot of the hopper
Hopper(2:NumRedTiles+1,2:NumCopies+2)=0; %Add white space on top of the hopper

%Make vertical white columns
cols=1;
rho=NumRedTiles+1;
for i=1:NumRedTiles
Hopper(rho:end,NumCopies+2+cols)=0;
Hopper(rho,2:NumCopies+2+cols)=0;
rho=rho-1;
cols=cols+3;
end

Hopper=vertcat(Hopper,ones(NumRedTiles*8,size(Hopper,2))); %Concatenate the bottom outlets to the hopper

rho1=(NumRedTiles*2)+3;
rho2=(NumRedTiles*2)+3;
cols1=1;
for j=1:NumRedTiles %Make the outlets below the hopper
Hopper(rho1:rho2+2,end-cols1)=0;
Hopper(rho2+2,end-cols1-1:end)=0;
Hopper(rho2+4,1:end)=0; %Add intersecting white lines
rho2=rho2+8;
cols1=cols1+3;
end

% DisplayFactory(Hopper);
end