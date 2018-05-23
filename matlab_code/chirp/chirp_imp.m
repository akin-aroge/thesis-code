function [ z_re, z_im ] = chirp_imp( x, y)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% simulation params
fs = 20000;  % sampling freq
t = 0:1/fs:1; % simulation time

f_0 = 1;    % initial freq
f_t = 10000; % target freq
t_t = 1;   % target time from block

%% params
tbw_start = 20; tbw_end = 20;
gamma = 6;

freqs = [4 5 6 8 10 12 14 16 20  26 32 40 50 64 72 80 90 100 128 150 175 200 230 256 300,...
    350 400 450 512 600 700 800 900 950 990, 1000, 2000, 5000]; % maybe make an argument
%maxmin = [min(freqs), max(freqs)];
%% the chirp nuances
%beta = (f_t - f_0)/t_t^2;     % beta value

beta_log = (f_t/f_0)^(1/t_t);

freq_times = zeros(length(freqs), 1);
for i = 1:length(freqs)
    %freq_time = sqrt((freqs(i) - f_0)/beta); % consider vectorizing
    freq_time = log(freqs(i) / f_0)/(log(beta_log));
    freq_times(i) = freq_time;
end

%% get the coefs with cwt
[wt_x,f_x, wt_y, ~] = wavlt(x, y,t, gamma, tbw_start, tbw_end, fs);

%% locating coeff
x_coeffs = zeros(length(freqs), 1);  %use zeros
y_coeffs = zeros(length(freqs), 1);

for j = 1:length(freqs)
    freq = freqs(i);
    freq_time = freq_times(j); % time when the freq occurs
    [~, f_idx] = min(abs(freq - f_x));  % get freq index
    [~, t_idx] = min(abs(freq_time - t)); %
    
    % remember x is voltage so the current y is sort of the reference
    freq_loc_x = wt_x(f_idx,:); % localize in freq (for all time)
    freq_loc_y = wt_y(f_idx,:);
    
    x_coeff = freq_loc_x(t_idx);  % hmm how do I localize this?
    %x_coeff = max(freq_loc_x);
    y_coeff = freq_loc_y(t_idx);  % localize in time
    
    x_coeffs(j) =  x_coeff;
    y_coeffs(j) = y_coeff;
end

imps = x_coeffs./y_coeffs;
z_re = real(imps);
z_im = imag(imps);
%imp_data = [z_re, -z_im];
figure(3)
plot(z_re, -z_im, '-*');
semilogx(freqs, abs(imps) )
grid('on');

% time = datestr(datetime);
% time = strrep(time, ':', '-');
% filename = strcat(time, string(-fs), string(-maxmin(1)), string(-maxmin(2)),... 
%     string(-gamma), string(-tbw_start), '.csv');
% csvwrite(filename, imp_data);
end
