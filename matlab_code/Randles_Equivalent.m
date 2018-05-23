%% ==== The Randles Equivalent electrochemical circuit ====

Rel = 0.4; Rct = 0.09; Cdl = 0.0003;
H = tf([Rel*Rct*Cdl, Rel+Rct],[Rct*Cdl, 1]); % the transfer function
nyquist(H)
bode(H)