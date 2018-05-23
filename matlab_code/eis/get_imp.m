function [z_mag, z_ph, z_re, z_im, thd_v, ...
    thd_i, freq_array, v_mag, i_mag] = get_imp(volt, curr, freq,...
                                            Fs, n_period)

% This function returns the complex impedance from voltage and current
% input
% volt:     voltage signal in time domain
% curr:     current signal in time domain
% freq:     frequency of the signals
% FS:       sampling frequecny for clocking calculation
% the impedance type may be specified as an optional argument

% % imp_type = 'nyq';   % sets the default data type generated to nyquist
% % 
% % if nargin > 3, imp_type = varargin{1}; end

% clean and orient input data
if size(volt, 2) > 1
    volt = volt';   % make column vector
end

if size(curr, 2) > 1
    curr = curr';   % make column vector
end

% remove DC component from signal
volt = volt - mean(volt);
curr = curr - mean(curr);

t_period = 1/freq; % signal period
n_samp_period = t_period*Fs; % sample period of signal (samples in one period)
%N = 3 * n_samp_period; % this is confusing and redundant here
%N = int64(n_samp_period*n_period);
N = n_samp_period * n_period;
n = double(N); % maybe not needed
% get signal length
% % N = length(volt);

% fft of signals
% todo vectorize as in https://www.mathworks.com/help/matlab/ref/fft.html
v_fft = fft(volt, N);
i_fft = fft(curr, N);

% Frequency Mapping for first half of signal
freq_array = Fs * (0:(N/2))/N;
%[~, freq_indx] = find(freq_array == freq);   % index of req'd freq in array
%[~, freq_ind_v] = max(abs(v_fft));
%[~, freq_ind_c] = max(abs(i_fft));
%% special arrangement for bode plot

% Getting the magnitudes
v_mag = abs(v_fft/n);
i_mag = abs(i_fft/n);

% fft rituals
v_mag = v_mag(1: N/2+1); % taking the necessary half
i_mag = i_mag(1: N/2+1);

v_mag(2:end-1) = 2 * v_mag(2:end-1);    % adding up the mirrored magnitudes
i_mag(2:end-1) = 2 * i_mag(2:end-1);

figure(3)
Fs
N
freq_array(1:10)
plot(freq_array, v_mag);

figure(4)
plot(freq_array, i_mag);
%% select the required frequency

v_resp = v_mag(n_period+1);
i_resp = i_mag(n_period+1);

v_ph = angle(v_fft(n_period+1));
i_ph = angle(i_fft(n_period+1));

%% output results

% for bode
z_mag = v_resp/i_resp;
z_ph = (180/pi) * (v_ph - i_ph); 
z_ph = 180 - z_ph; %new correction

% for nyquist
%[z_re, z_im] = pol2cart((z_ph * pi/180), z_mag);

imp_cmplx = v_fft(n_period+1)/(i_fft(n_period+1));
z_re = -real(imp_cmplx); % the impedance gotten is negative (already)
z_im = imag(imp_cmplx);

%% thd
harm_freq_indx = 1:n_period:N/2+1; % indices of DC (1) and harmonics
harm_freq_indx = int32(harm_freq_indx);
v_freqs = v_mag(harm_freq_indx);       % gets the harmonic values
v_fund = v_freqs(2);                % the fundamental comes out in the first harmonic after dc since that is the resolution from calc
v_harm = v_freqs(3:5);

thd_v = 100 * sqrt(sum(v_harm.^2))/v_fund;

i_freqs = i_mag(harm_freq_indx);       % gets the harmonic values
i_fund = i_freqs(2);
i_harm = i_freqs(3:5);

thd_i = 100 * sqrt(sum(i_harm.^2))/i_fund;

end