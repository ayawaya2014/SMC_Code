%%------sliding mode formation control------
% Y coordinates generator for the right follower.
% Author: Xin Li
% SHMTU
% Modified 2019.06 2019.05
%             2019.04
%             2018.09
%             2018.03
%--------------------------------------------

%% The control rate is designed in both directions of the x-y-z plane, and the propeller control quantity is calculated according to the specific arrangement of AUV thrusters
% Linear transformation between mission space and propeller space
% Super-twist

a = 5;
b = 11;
% xk=zeros(2,1);
xk = [1.0; 0.3];
% xk = [c_r(1,1),c_r(2,1)-c_r(1,1)]; % Initial[Position;Speed] % right side follower 
% xk expands to 1x4 accelerated speed
ut_1 = 0;
de(1) = 0;
c = 6;
% T = 0.2;
% T=0.25;
% the best parameter.
T = 0.26;
lambda = 0.9;

for k = 1:1:length(c_r)
    time(k)=k*T;
    thd(k)=c_r(k,1);
end

dthd(1)=0;

for k = 2:1:length(c_r)
    dthd(k)=thd(k)-thd(k-1);
end

% dthd(end+1)=dthd(end);
ddthd(1)=0;

for k = 2:1:length(c_r)
    ddthd(k)=dthd(k)-dthd(k-1);
end
% ddthd(end+1)=ddthd(end);
for k = 1:1:length(c_r)
    
    tSpan=[0:0.001:T];
    
    para=ut_1;      % D/A
    
     options=odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
%     [t,x]=ode45(@match,[0 20],[1,1,1,5],options);

%     [tt,xx]=ode45('auv_plant',tSpan,xk,options,para);
    [tt,xx]=ode45('AUV_plant_2',tSpan,xk,options,para,de(end));
    xk=xx(length(xx),:);    % A/D solve results the state matrix
    th(k)=xk(1);
    dth(k)=xk(2);
    
    e(k)=thd(k)-th(k);
    de(k)=dthd(k)-dth(k);
    
%     s(k)=c*e(k)+de(k);
    s(k)=lambda*(c*e(k)+de(k));
    
    xite=2.3;  % xite>max(dt)
    
    M=2;
    % M=1;
    if M==1
        ut(k)=1/b*(a*dth(k)+ddthd(k)+c*de(k)+xite*sign(s(k)));
    elseif M==2                  %Saturated function
        delta=0.5;   % The larger the amplitude of the control oscillation, the smaller the oscillation. Default:0.05.
        % delta = 0.05; % Comparison parameters
        kk=1/delta;
        if abs(s(k))>delta
            sats=sign(s(k));
        else
            sats=kk*s(k);  % sk<=delta, -> sk*(1/delta)<=1, -> sk*kk<=1;
        end
         ut(k)=1/b*(a*dth(k)+ddthd(k)+c*de(k)+xite*sats);
        %ut(k)=1/b*(a*dth(k)^0.5+ddthd(k)+c*de(k)+xite*sats^0.5); % Integral sliding mode: eliminate arrival segment and improve robustness.
    end
    ut_1=ut(k);
end
c_rx = th';

figure(1);

subplot(211);
plot(time,thd,'k-.',time,th,'r','linewidth',2);
xlabel('time(s)');ylabel('trajectory');
legend('virtual target x coordinate','path tracking points');

subplot(212);
plot(time,dthd,'k-.',time,dth,'r','linewidth',2);
xlabel('time(s)');ylabel('speed tracking');
legend('expected speed','actual speed');

figure(2);
plot(thd-th,dthd-dth,'r:','linewidth',2)
hold on
plot(thd-th,-c*(thd-th),'k:','linewidth',2);    %Draw line(s=0) s=0. That is, the line DE (t) with slope -c =-ce(t), i.e., the sliding surface/switching surface (approaching to this surface)
xlabel('e');ylabel('de');
legend('error phase','sliding mode surface');
hold off

figure(3);
plot(time,ut,'r','linewidth',2);
xlabel('time(s)');ylabel('control input');
% 
% figure(4)
% plot(c*e,de,'b.','linewidth',2);

