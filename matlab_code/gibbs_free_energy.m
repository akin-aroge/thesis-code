% heat of formation at 25 degrees celcius
hf_hydrogen = 0;
hf_oxygen = 0;
hf_water_l = -286.02;
hf_water_g = -241.98;

%entropy information at 25 degrees celcius
sf_hydrogen = 0.13066;
sf_oxygen = 0.20517;
sf_water_l = 0.06996;
sf_water_g = 0.18884;

tmp = 273 + 25;
gibbs_energy = hf_water_l - tmp*(sf_water_l - sf_hydrogen- 0.5*sf_oxygen)