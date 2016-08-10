clc
clear all
a=arduino('COM5','Mega2560','libraries','Servo');

servo1=servo(a,'D9', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
servo2=servo(a,'D10', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);

%Sets Table to Equilibrium
angle1= 100/180;
angle2= 85/180;
writePosition(servo1,angle1);
writePosition(servo2,angle2);
%Sliders in Start Position

pause(5);

%Tilts Table Down and back to Equilibrium
angle1 = 140/180;
writePosition(servo1,angle1);
pause(2.5);
angle1 = 90/180;
writePosition(servo1,angle1);

pause(3);

%Tilts Table Left and back to Equilibrium
angle2 = 25/180;
writePosition(servo2,angle2);
pause(2.5);
angle2 = 90/180;
writePosition(servo2,angle2);
pause(1.5);
angle2 = 95/180;
writePosition(servo2,angle2);

pause(3);

%Tilts Table Up and back to Equilibrium
angle1 = 50/180;
writePosition(servo1,angle1);
pause(2.5);
angle1 = 95/180;
writePosition(servo1,angle1);
pause(1.5);
angle1 = 105/180;
writePosition(servo1,angle1);

pause(3);

%Tilts Table Right and back to Equilibrium
angle2 = 140/180;
writePosition(servo2,angle2);
pause(2.5);
angle2 = 75/180;
writePosition(servo2,angle2);

pause(3);

%Tilts Table Down and back to Equilibrium
angle1 = 140/180;
writePosition(servo1,angle1);
pause(2.5);
angle1 = 90/180;
writePosition(servo1,angle1);

%Sliders are now in Goal Position