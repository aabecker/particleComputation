function [IsPossible, factoryLayoutArray]=BuildFactory(partXY)
% Given a polyomino part, constructs a tile factory
% that contains part hoppers for each part, and a fctory floow layout so
% that a repeated sequence of l,r,u,d constructs a new partXY each
% iteration until supplies run out
direction 
%
%Authors: Sheryl Manzoor and Aaron T. Becker, Sep 27, 2016
clc

if nargin <1
% part = [1 2 3;2 2 3;3 2 3;4 3 3;5 3 3;4 2 3]; %contains the item positions for the Part
% part=[7 6;
%       9 6;
%       6 7;
%       7 7;
%       8 7;
%       9 7;
%       10 7;
%       7 8;
%       9 8;
%       6 9;
%       7 9;
%       8 9;
%       9 9;
%       10 9;
%       7 10;
%       9 10];
 
partXY=[4 2;
      5 2; % Spiral part inner node [5 5]
      6 2
      7 2;
      8 2;
      8 3;
      8 4;
      8 5;
      8 6;
      8 7;
      7 7;
      6 7;
      5 7;
      4 7;
      4 3;
      4 4;
      4 5;
      5 5];
end
% Returned variables
IsPossible = false;  % no valid path has been found yet
factoryLayoutArray = [];


%  1.) check for a valid build path.  Is impossible, return false

%  2.)  construct the necessary part hoppers

%  3.)  build a blank factory floor

%  4.)  build fixtures 


