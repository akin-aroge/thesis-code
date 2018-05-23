function err  = simple_fitness( x, exp_data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Params contain variables r1,r2,c1 in that order

r_1 = x(1); r_2 = x(2); c_1 = x(3);

sys = tf([r_1*r_2*c_1, r_1+r_2], [r_2*c_1, 1]);

%opt = stepDataOptions('InputOffset',0, 'StepAmplitude',1);
t = (0:0.001:2)';
y = step(sys, t);

% error function
n = size(y, 1); % no of rows in the output y
err = sum((y - exp_data).^2)/n;

end

