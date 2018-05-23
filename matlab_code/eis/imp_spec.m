function [ imp_data ] = imp_spec(freqs, ampl, samples, n_period)
%This function takes in a list of frequency as arguments
% frequency:    a list of frequencies to be generated
% samples:  the number of samples for a period of the signal (granularity)
% n_period: the number of periods to be generated (hence also acquired)

% to do
n_freq = length(freqs);

%% initialize output
imp_data = zeros(n_freq, 5);
thd_data = zeros(n_freq, 3);
volt_data = zeros(samples * n_period, n_freq);
curr_data = zeros(samples * n_period, n_freq);
volt_mag_data = zeros(samples*n_period/2+1, n_freq);
curr_mag_data = zeros(samples*n_period/2+1, n_freq);

freq_array_data = zeros(samples*n_period/2+1, n_freq);
%%
for i = 1:n_freq
    
    freq = freqs(i);
    data = ampl*sin(linspace(0, 2*pi, samples+1))'; 
    data(end) = [];     % remove the last point to terminate period
    
    %% daq setup

    s = daq.createSession('ni');
    dev = daq.getDevices().ID;
    addAnalogOutputChannel(s, dev, 'ao0','Voltage'); 
    addAnalogInputChannel(s, dev, 'ai0', 'Voltage');
    addAnalogInputChannel(s, dev, 'ai1', 'Voltage'); % current
    s.Rate = freq * samples;    % gets the required rate for a given freq
    %Fs = s.Rate;
    %todo uncomment below and clear above
    Fs = freq * samples;
    queueOutputData(s, repmat(data, n_period, 1));    % queue n_periods of data
    
    % start activity
    dt_out = s.startForeground();
    size(dt_out);
    
    figure(1)
    plot(dt_out(1:end, 1))
    
    figure(2)
    plot(dt_out(1:end, 2))
    %% calulate impedance
    
    [z_mag, z_ph, z_re, z_im, ...
        thd_v, thd_i, freq_array, v_mag, i_mag] = get_imp(dt_out(1:end, 1), ...
                                         dt_out(1:end, 2), ...
                                         freq, Fs, n_period);
    
    imp_data(i, 1:end) = [freq, z_mag, z_ph, z_re, z_im];
    thd_data(i, 1:end) = [freq, thd_v, thd_i];
    
    volt_data(1:end, i) = dt_out(:, 1);
    curr_data(1:end, i) = dt_out(:, 2);
   
    volt_mag_data(1:end, i) = v_mag';
    curr_mag_data(1:end, i) = i_mag';
    
    freq_array_data(1:end, i) = freq_array';
    % pause iteration
    %pause(10);
end
% write impedance to csv
time = datestr(datetime);
time = strrep(time, ':', '-');
filename = strcat(time, string(-ampl), string(-n_period), '.csv');
csvwrite(filename, imp_data);

%% write thd to csv
filename_thd = strcat(time,'-thd', string(-ampl),string(-n_period), '.csv');
csvwrite(filename_thd, thd_data);

%% write volt and curr data
filename_volt = strcat(time,'-volt', string(-ampl),string(-n_period), '.csv');
csvwrite(filename_volt, volt_data);

filename_curr = strcat(time,'-curr', string(-ampl),string(-n_period), '.csv');
csvwrite(filename_curr, curr_data);

%% write fft data
filename_volt_mag = strcat(time,'-volt_mag', string(-ampl),string(-n_period), '.csv');
csvwrite(filename_volt_mag, volt_mag_data);

filename_curr_mag = strcat(time,'-curr_mag', string(-ampl),string(-n_period), '.csv');
csvwrite(filename_curr_mag, curr_mag_data);

filename_freq_array = strcat(time,'-freq_array', string(-ampl),string(-n_period), '.csv');
csvwrite(filename_freq_array, freq_array_data);
% A_narrow = cat(1, A(:,1:256,:), A(:,257:end,:));
% for i = 1:size(A,3)
%   xlswrite('myfile.xls',A_narrow(:,:,i),['page_' num2str(i)], 'A1')
% end
end

