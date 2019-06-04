function dy = AUV_plant_2(t,x,flag,para,para1)

a = 11;
b = -5;
dy = zeros(2,1);
a1 = 0.01;
a2 = 7;
a3 = 0.001;
rho = 0.5;

% p=2*(x(2)^2+2);
%  p = 1.2*a1^2+2;
% u=-x(2)-x(1);
 
% ut=para;
dt=0.1*sin(0.5*pi*t);

% k1=a1+1/a2*(1/(4*a3)*p+2*a3*p+a3+2*a3*(a2+4*a3^2));
k2=a1+1/a2+4*a3^2+2*a3*x(1)^2;

u1 = a*para;

if para1 >= 0   
    u2 = -0.9*k2*abs(para1)^rho;
else
    u2 = 0.9*k2*abs(para1)^rho;
end    

dy(1)=x(2);
% dy(2)=u1+u2-1.2*x(2)+dt;
dy(2)=u1+u2+b*x(2)+dt;
% dy(3)=x(3);
% dy(3)=-k1*((abs(x(3)-x(2)))^(1/2)*sign(x(3)-x(2))+k3*(x(3)-x(2)))+x(4);
% dy(4)=-k2*(1/2*sign(x(3)-x(2))+3/2*k3*(abs(x(3)-x(2)))^(1/2)*sign(x(3)-x(2))+k3^2*(x(3)-x(2)));
end

