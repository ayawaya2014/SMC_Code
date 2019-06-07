function [sys,x0,str,ts] = hosmc_1(t,x,u,flag)

switch flag
case 0
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];

function sys=mdlOutputs(t,x,u)

persistent e0 de0 dde0
T=1.0;

xd=u(1);
dxd=0.5*2*pi*cos(2*pi*t);
ddxd=-0.5*(2*pi)^2*sin(2*pi*t);

x=u(2:1:3);
dx=u(4:1:5);
if t==0
   e0=x(1);
   de0=x(2)-pi;
   dde0=dx(2);
end

C=[5,1];

e=x(1)-xd;
de=x(2)-dxd;
dde=dx(2)-ddxd;

if t<=T
   A0=-10/T^3*e0-6/T^2*de0-1.5/T*dde0;
   A1=15/T^4*e0+8/T^3*de0+1.5/T^2*dde0;
   A2=-6/T^5*e0-3/T^4*de0-0.5/T^3*dde0;
   p=e0+de0*t+1/2*dde0*t^2+A0*t^3+A1*t^4+A2*t^5;
   dp=de0+dde0*t+A0*3*t^2+A1*4*t^3+A2*5*t^4;
   ddp=dde0+A0*3*2*t+A1*4*3*t^2+A2*5*4*t^3;
else
   p=0;dp=0;ddp=0;
end

rou=(C(1)*e+C(2)*de)-(C(1)*p+C(2)*dp);

delta0=0.03;
delta1=1.5;
delta=delta0+delta1*norm(e);
mrou=norm(rou)+delta;

K=10;
D=3.0;
M=2;
if M==1
    ut=-1/3*(-5*x(2)-ddxd-ddp+inv(C(2))*C(1)*(de-dp))-1/10*sign(C(2)*rou)*(D+K);
elseif M==2
    ut=-1/33*(-5*x(2)-ddxd-ddp+(C(2))\C(1)*(de-dp))-1/6*rou/mrou*(D+K);
elseif M==3
    ut=-1/20*(-5*x(2)-ddxd-ddp+inv(C(2))*C(1)*(de-dp))-1/33*rou/sigmoid(C(2)*rou)*(D+K);
end
sys(1)=ut;
% sys(2)=e;
% sys(3)=de;

