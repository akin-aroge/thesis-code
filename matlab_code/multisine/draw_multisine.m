function [ t, y ] = draw_multisine( freqs, phases, amp, sampling_freq,...
    period, n_period )
%DRAW_MULTISINE Summary of this function goes here
%   Detailed explanation goes here

% convenience in case I jhave to change the frequency
% so I don't have to change the phase too

if isempty(phases)
    phases = zeros(1, length(freqs));
end

t = 0:1/sampling_freq:n_period*period;
y = sum(amp*sin(2 * pi * freqs' * t + phases(1:length(freqs))'), 1);

end

