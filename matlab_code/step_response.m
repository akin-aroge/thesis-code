% typical randles
r1 = 0.1; r2 = 0.1; c1 = 0.001;

sys = tf([r1*r2*c1, r1+r2], [r2*c1, 1]);

opt = stepDataOptions('InputOffset',0, 'StepAmplitude',1);
step(sys, 0.001)
t = (0:0.001:5)';
[y, t] = step(sys, t);


