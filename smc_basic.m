%% Sliding mode basic mfile

t = 0:0.01:50; % set simulaiton time 50s
c0 = [-3 0];   % initial condition c(t)=-3, dc(t) = 0;

[t,c] = ode45(@fun1, t, c0); % resolve diffirential equation under initial condition

figure(1)
plot(c(:,1),c(:,2), 'LineWidth', 2); % draw the phase plane
grid

figure(2)
plot(t,c(:,1), 'LineWidth', 2); % time response curve
grid
xlabel('t(s)');
ylabel('c(t)');

function dc = fun1(t,c)
% coefficients = 1, 0.5, 0.7, constant = 2
dc(1,1) = c(2);
if (0.5 * c(1) + c(2) < 0)
    dc(2,1) = 2 - 0.7*c(2);
else
    dc(2,1) = -2 - 0.7*c(2);
end

end



