%% Ocean Current
%% Matlab R2017A 验证通过
%% 论文中的海流模型

syms Fc y Bt k x c t Bo e w theta Uc Vc Dc Nc alpha

% Fc = 1 - tanh((y-Bt*cos(k*(x-c*t))/sqrt(1+k^2*Bt^2*sin(k*(x-c*t))^2)));
% syms Fc y k x c t Bo Uc Vc Dc Nc Bt %

Bt = Bo+e*cos(w*t+theta);

Dc = sqrt(1+(k*Bt*sin(k*(x-c*t)+alpha))^2);
% Dc = sqrt(1+(k*Bt*sin(k*(x-c*t))).^2);
Nc = y-Bt*cos(k*(x-c*t)+alpha);
% Nc = y-Bt*cos(k*(x-c*t));

Fc = 1-tanh(Dc/Nc);
Uc = -diff(Fc,y);
Vc = diff(Fc,x);

% 变量赋值
Bo = 1.2;
c = 0.12;
k = 0.82;
w = 0.4;
e = 0.3;
theta = pi/2;
alpha = pi/4;
t = 1;
[x,y] = meshgrid(-5:0.2:11,-7:0.2:9);
% 
% Fcct = eval(vpa(subs(Fc))); 
Fcct = eval(subs(Fc)); % 这个计算结果是对的
Ucn = eval(subs(Uc));
Vcn = eval(subs(Vc));
Phi = Fcct;

figure 
C = quiver(Ucn,Vcn);
% X = -10:70;
% Y = -10:70;
% C = quiver(X,Y,Ucn,Vcn,'Displayname','Velocity');
legend(C,'Current');
hold on
contour(Phi,10,'-r','Displayname','Potential \phi');
xlabel('x(m)');
ylabel('y(m)');
