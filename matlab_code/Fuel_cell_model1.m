%% =====================Fuel Cell Modelling============================= %%


%Set variables

R =  8.314;     %ideal gas constant
F = 96487;      %Faraday's constant (coulombs)
T_c = 90;       %Temperature in degrees celsius        
p_h2 = 3;       %Hydrogen Pressure in atm
p_air = 3;      %Air Pressure
A_cell = 100;   % Area of cell
N_cells = 90;   % Number of cells
r = 0.19;       % internal resistance
alpha = 0.5;    % Transfer co-efficient
Alpha1 = 0.085;   % Amplification constant
i_o = 10^-6.912;% exchange current density
i_l = 1.4;      % limiting current density
Gf_liq = -228170;   %Gibbs function in liquid form(lower heating value)
k = 1.1;

%Temperature conversion
T_k = T_c + 273.15;

%loop current

loop = 1;

v_out = zeros(151);
i_out = zeros(151);
count = 0;
i = 0.0;
for N = 0:150
    count = count+1;
    i = i + 0.01;
    i_out(count) = i;
    % calculating Partial Pressures
    
    % saturation Pressure of Water
    x = -2.1794 + 0.02953 .* T_c-9.1837 .* (10.^-5) .* (T_c.^2) ...
        + 1.4454 .* (10.^-7) .* (T_c.^3);
    p_h2o = (10.^x);
    
    % Calculation of partial pressure of hydrogen
    pp_h2 = 0.5 .* ((p_h2)./(exp(1.653 .* i./(T_k.^1.334)))-p_h2o);
    
    % Calculating partial pressure of oxygen
    pp_o2 = (p_air./exp(4.192 .* i/(T_k.^1.334)))-p_h2o;
    
    %Activation Losses
    b = R .* T_k./(2 .*alpha .* F); %tafel slope
    v_act = -b .* log(i./i_o); % Tafel equation
    
    % Ohmic Losses
    v_ohmic = -(i*r);
    
    %Mass Transport Losses
    term = 1- (i./i_l);
    if term > 0
        v_conc = Alpha1 .* (i.^k) .* log(1-(i./i_l));
    else
        v_conc = 0;
    end
    
    % Calculation of Nernst voltage
    E_nernst = -Gf_liq./(2 .* F) - ((R .* T_k) .* ...
        log(p_h2o./(pp_h2 .* (pp_o2.^0.5))))./(2 .* F);
   
    % Calculation of output voltage
    v_out(count) = E_nernst + v_ohmic + v_act + v_conc;
    if term < 0
        v_conc = 0;
        break
    end
    if v_out(count) < 0
        v_out(count) = 0;
        break
    end
    
end
v_out = v_out(1:count);
i_out = i_out(1:count);
figure(1)
    title('Fuel cell polarization curve')
    xlabel('Current density (A/cm^2)');
    ylabel('Output voltage (Volts)');
    plot(i_out,v_out,'*')
    grid on
    hold on
    
    hline = refline(0, E_nernst);
    set(hline, 'Color', 'r');
legend('i-v curve', 'thermo. potential')