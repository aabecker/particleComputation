function varargout=loadMaze(mazeName)
% LOADMAZE--> helper function to pick maze from Maze folder in 
% Blind Maze solving directory regardless of the current working directory. 
% Michael Umeano 5/09/2015

path=fileparts(mfilename('fullpath'));
if nargout==0
    evalin('caller',['load(''' fullfile(path,'mazes',mazeName) ''');']);
else
    P = load(fullfile(path,'mazes',mazeName));
    varargout{1} = P;
end
    
