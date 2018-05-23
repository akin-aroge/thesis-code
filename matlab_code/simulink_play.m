%for vdp
simOut = sim('vdp', 'SaveOutput', 'on')
results = simOut.get('yout');

T = 300;
for i = 1:3
    T = T+10;
    simOut{i} = sim('fuel', 'SaveOutput', 'on');
    results = simOut.get('yout', 'tout');
    
end

T = 400;
simOut = sim('fuel', 'SaveOutput', 'on');