function [ Y ] = my_fft( X, Fs, n )
%this is a wrapper for the Matlab fft
% len: specifies len of signal to perform fft on
% Fs: sampling frequency from simulation
n = int16(n);
T = 1/Fs;
L = length(X);        % length of the signal

t = (0:L-1)*T;  % Time vector
%t = (0:l-1)*T*100; % in milliseconds

figure(1)
plot(t(1:n), X(1:n))
title('')
xlabel('')
ylabel('')

Y = fft(X, n);

end

