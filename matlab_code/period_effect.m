% script for process
%% from simulink
X = ScopeData.signals.values;
Fs = 1/0.0001; % sampling frequency from simulink
freq = 100; % frequency of sinusoid
%% 
% compute fft for increasing periods
t_period = 1/freq; % signal period
n_samp_period = t_period*Fs; % sample period of signal (samples in one period)1
n = 1 * n_samp_period;  % number of periods (in samples)
Y = my_fft(X, Fs, n);

%%
p2 = abs(Y/n);
p1 = p2(1:n/2+1);
p1(2:end-1) = 2*p1(2:end-1);

%% plot
f = Fs*(0:(n/2))/n;
figure(2)
stem(f, p1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')