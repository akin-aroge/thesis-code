% EXAMPLE 3-3: Calculating the Voltage Losses for a

% UnitSystem SI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
R = 8.314; % Ideal gas constant (J/molK)
F = 96487; % Faraday’s constant (Coulombs)

Tc = 80; % Temperature in degrees C
P_H2 = 3; % Hydrogen pressure in atm
P_air = 3; % Air pressure in atm
A_cell=100; % Area of cell
N_cells=90; % Number of Cells
r = 0.19; % Internal Resistance (Ohm-cm^2)
Alpha = 0.5; % Transfer coeffi cient
Alpha1 = 0.085; % Amplifi cation constant
io = 10^-6.912; % Exchange Current Density (A/cm^2)
il = 1.4; % Limiting current density (A/cm2)
Gf_liq = -228170; % Gibbs function in liquid form (J/mol)
k = 1.1; % Constant k used in mass transport
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert degrees C to K
Tk = Tc + 273.15;
% Create loop for current
loop = 1;
i = 0;
for N = 0:150
    i = i + 0.01;
    % Calculation of Partial Pressures
    % Calculation of saturation pressure of water
    x = -2.1794 + 0.02953 .* Tc-9.1837 .* (10.^-5) .* (Tc.^2) + 1.4454 .* (10.^-7) .* (Tc.^3);
    P_H2O = (10.^x)
    % Calculation of partial pressure of hydrogen
    pp_H2 = 0.5 .* ((P_H2)./(exp(1.653 .* i./(Tk.^1.334)))-P_H2O)
    % Calculation of partial pressure of oxygen
    pp_O2 = (P_air./exp(4.192 .* i/(Tk.^1.334)))-P_H2O
    % Activation Losses
    b = R .* Tk./(2 .* Alpha .* F);
    V_act = -b .* log10(i./io); % Tafel equation
    % Ohmic Losses
    V_ohmic = -(i .* r);

    % Mass Transport Losses
    term = (1-(i./il));
    if term > 0
    V_conc = Alpha1 .* (i.^k) .* log(1-(i./il));
    else
    V_conc = 0;
    end
    % Calculation of Nernst voltage
    E_nernst = -Gf_liq./(2 .* F) - ((R .* Tk) .* log(P_H2O./(pp_H2 .* (pp_O2.^0.5))))./(2 .* F);
    % Calculation of output voltage
    V_out = E_nernst + V_ohmic + V_act + V_conc;
    if term < 0
    V_conc = 0;
    break
    end
    if V_out < 0
    V_out = 0;
    break
    end
    figure(1)
    title('Fuel cell polarization curve')
    xlabel('Current density (A/cm^2)');
    ylabel('Output voltage (Volts)');
    plot(i,V_out,'*')
    grid on
    hold on
    disp(V_out)
    % % Calculation of power
    % P_out = N_cells .* V_out .* i .* A_cell;
    % fi gure(2)
    % title('Fuel cell power')
    % xlabel('Current density (A/cm^2)');
    % ylabel(‘Power(Watts)');
    % plot(i,P_out,'*');
    % grid on
    % hold on
    % disp(P_out);
end