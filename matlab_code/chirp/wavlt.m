function [wt_x,f_x, wt_y, f_y] = wavlt(x, y, t, gamma, tbw_start,...
    tbw_end, fs)
    
    nv = 48;    % numberof Voices
    tbws = tbw_start:2:tbw_end;
    gammas = repmat(gamma, [length(tbws), 1]);
    wvparams = [gammas tbws'];
    
    %% absolutely useless stuff I've done here loop should be in main
    for i = 1:size(wvparams,1)
        
        wvparam = wvparams(i,:);
        %% for x
        [wt_x, f_x] = cwt(x,fs,  'VoicesPerOctave', nv,...
                    'WaveletParameters',wvparam);
        xrec = icwt(wt_x,  'VoicesPerOctave', nv,...
                    'WaveletParameters',wvparam);
        figure(i)
        plot(t, xrec);
        
        %% for y
        [wt_y, f_y] = cwt(y,10000,  'VoicesPerOctave', nv,...
                'WaveletParameters',wvparam);
        yrec = icwt(wt_y,  'VoicesPerOctave', nv,...
                'WaveletParameters',wvparam);
        figure(i+1)
        plot(t, yrec)
    end
        
    
    
    
end