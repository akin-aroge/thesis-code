% minimizing
r1 = 0.2; r2 = 0.4; c1 = 0.5;

sys = tf([r1*r2*c1, r1+r2], [r2*c1, 1]);

% step response to get the example transient that ga needs to match
t = (0:0.001:2)';
[y, t] = step(sys, t);
step(sys, t);
hold on
exp_data = y;
clearvars('r1','r2','r3','c1', 'y', 't', 'sys')

objective = @(x)simple_fitness(x, exp_data);
nvars = 3;
lb = [0.0001 0.000001 0.0000001];
ub = [1 1 1];

%options = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotmaxconstr},'Display','iter');

%options = gaoptimset(options, 'Display','iter');
n = 10; % number of iterations
pred = zeros(n, 3);
fval = zeros(n, 1);
% running the ga a number of times
for i = 1:n
   [x, fval] = ga(objective, nvars, [], [], [], [], lb, ub,[]);
   pred(i,:) = x;
   fval(i,1) = fval;
end

% plot the ga generated result
%figure('Name','different step response')
for i = 1:n
    if i <= 5 % just 5 step response plots plus the oroginal
        x = pred(i,:);
        r_1 = x(1); r_2 = x(2); c_1 = x(3);
        sys = tf([r_1*r_2*c_1, r_1+r_2], [r_2*c_1, 1]);
        t = (0:0.001:2)';
        step(sys, t);
        hold on
    else
        break
    end
end
% distribution of the results
figure('Name', 'Distribution of the generated R1')
hist(pred(:,1));
% hold on
% hist(pred(:,2));
% hold on
% hist(pred(:,3));



