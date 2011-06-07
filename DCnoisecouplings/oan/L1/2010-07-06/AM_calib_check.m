%%

%%
set(0 ,'DefaultLineLineWidth', 2)

filenames = {'OSCAM_SBSB_amp=0.14142', 'OSCAM_SBSB_amp=1.4142'};
         
cm = jet();
hold off

exc_calib = 0.05 / sqrt(2); % RAM / volts
omc_calib = 1/0.405;          % RIN / count

for ii=1:length(filenames)
    filename = filenames{ii};    
    data(ii).filename = filename;
    temp = dlmread([filename '.txt']);
    data(ii).f   = temp(:,1);
    data(ii).Txy = temp(:,(1:7)*2) + 1i* temp(:,(1:7)*2+1);
    temp = dlmread([filename '.coh']);
    data(ii).coh = temp(:,2:end);
end

Txy = data(1).Txy(:,5) * omc_calib / exc_calib;
coh = data(1).coh(:,5);
Navg = 10;
err = sqrt((1 - coh)./(2 * Navg * coh));

plot(data(1).f, db(Txy),'o-', 'color',[0.5 1 0.5 ])
hold all

Txy = data(2).Txy(:,5) * omc_calib / exc_calib;
coh = data(2).coh(:,5);
Navg = 10;
err = sqrt((1 - coh)./(2 * Navg * coh));
plot(data(1).f, db(Txy),'o-', 'color', [0 0.5 0])

set(gca, 'xscale', 'log');
xlabel('frequency');
ylabel('(sideband RIN)/(oscillator AM) [dB]');
grid on;

Gamma = 0.32; 
expected_level = Gamma * (besselj(0, Gamma) - besselj(2, Gamma))/besselj(1, Gamma);

line(get(gca,'xlim'), db(expected_level)  * [ 1 1], 'color', [0.1 0.88 0.1]);
legend('exc amp 0.1 volts RMS', 'exc amp 1.0 volts RMS', '\Gamma \cdot ( \partial/\partial\Gamma J_1(\Gamma)) / J_1(\Gamma) with \Gamma = 0.32');  
xlim([20 8000])
hold off