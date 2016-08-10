% This connects the matlab to arduino, change the com number to the correct
% one connected to your arduino module
clc
clear all
a=arduino('COM5','Mega2560','libraries','Servo'); 

servo1=servo(a,'D9', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
servo2=servo(a,'D10', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);

prompt1='What angle for Servo 1?';
prompt2='What angle for Servo 2?';

bob = 1;

while(bob == 1)
    %The maximum value is 180 degrees, do not put more
    angle1=input(prompt1)/180;
    angle2=input(prompt2)/180;
    
    writePosition(servo1,angle1);
    writePosition(servo2,angle2);
    
    %bob = 0;
end