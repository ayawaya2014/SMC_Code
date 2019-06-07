close all;
clear all;

%% state equation parameters for simulink
A1=[1 1 1;3 4 5;6 12 20];
b1=[-1;0;0];
x1=A1\b1;
A2=[1 1 1;3 4 5;6 12 20];
b2=[-1;-1;0];
x2=A2\b2;
A3=[1 1 1;3 4 5;6 12 20];
b3=[-1/2;-1;-1];
x3=A3\b3;

%% AUV followers' trajectories
a = 0:0.1:6*pi;
aa = 1.5 * cos(a);
% a=0:0.1:3*pi;
% b=0.3*sin(a);
% b=0.5*sin(0.1*a); 
b = 0.5 * sin(a);
bb = 1.2 * sin(a);
% z axis parameters
c = 0.22 * a.^1.5;
cc = 0.09 * a.^1.5; 
Ki = 10; % Graph scaling factor
% plot(a,b);
% plot3(a,b,c); % plot test
% axis equal

ccc = [aa;bb;cc]'*[cos(pi/4) sin(pi/4) 0;-sin(pi/4) cos(pi/4) 0; 0 0 1]; % Leader coordinate sequence
                                                       
%  ccc = [a;b;c]'*[cos(pi/4) sin(pi/4) 0;-sin(pi/4) cos(pi/4) 0; 0 0 1];  % n*3 matrix                                      
                                                
%% Followers' path data
c_r = [ccc(:,1)+0.2  ccc(:,2)-0.7 ccc(:,3)-0.1]; % Right follower of follower1
c_l = [ccc(:,1)-0.5  ccc(:,2)+0.2 ccc(:,3)-0.1]; % Left follower or follower2

%% for simulink
t = 0:1:188;
t_sim = t'/10;

%% use following mfiles to caculte the xyz of the formation
follower_rx; 
follower_ry2;
follower_rz;
follower_lx;
follower_ly;
follower_lz;
