%% Marconi Oscillator AM modulation-depth calibration check
%
% To check the calibration of the modulation drive, I configured a
% single-bounce off an ITM and locked the OMC to the sideband.  This
% directly measures AM of the RF sideband, which can be easily related to
% the AM on the oscillator.

%%
set(0 ,'DefaultLineLineWidth', 2)

filenames = {'OSCAM_SBSB_amp=0.14142', 'OSCAM_SBSB_amp=1.4142'};
         
cm = jet();
hold off

exc_calib = 0.05 / sqrt(2);   % RAM / volts
omc_calib = 1/0.405;          % RIN / count

% Load the data files
for ii=1:length(filenames)
    filename = filenames{ii};    
    data(ii).filename = filename;
    temp = dlmread([filename '.txt']);
    data(ii).f   = temp(:,1);
    data(ii).Txy = temp(:,(1:7)*2) + 1i* temp(:,(1:7)*2+1);
    temp = dlmread([filename '.coh']);
    data(ii).coh = temp(:,2:end);
end

for ii=1:2,
    Txy{ii}.Txy = data(ii).Txy(:,5) * omc_calib / exc_calib;
    Txy{ii}.f = data(ii).f;
end

%% Amplitude

plot(Txy{1}.f, db(Txy{1}.Txy), 'go-', 'markersize', 10);
hold all
plot(Txy{2}.f, db(Txy{2}.Txy), 'o-', 'color', [0 0.5 0]);
hold off

set(gca, 'xscale', 'log');
xlabel('frequency');
ylabel('(sideband RIN)/(oscillator AM) [dB]');
grid on;

Gamma = 0.32; 
expected_level = Gamma * (besselj(0, Gamma) - besselj(2, Gamma))/besselj(1, Gamma);

line(get(gca,'xlim'), db(expected_level)  * [ 1 1], 'color', [0 0 1]);
legend('exc amp 0.1 volts RMS', 'exc amp 1.0 volts RMS', ...
       '\Gamma \cdot ( \partial/\partial\Gamma J_1(\Gamma)) / J_1(\Gamma) with \Gamma = 0.32', ...
       'Location', 'SouthWest');  
xlim([20 8000])
hold off

%% Phase (unwrapped)
% a delay generates a linear phase:
%
% phase [radians] = tau [s] * f [cycles/second] * (2pi) [radians/cycle]

plot(Txy{2}.f, unwrap(angle(Txy{2}.Txy)) * 180/pi, 'o-', 'color', [0 0.5 0]);

xlabel('frequency');
ylabel('phase[degrees]');
grid on;
title('OH HO HO, LOOKS LIKE THERE''S A DELAY');

%% Delay is about 2 ms

% The delay appears to be very close to 2 ms:
tau_est0 = 2e-3; % [s]

% Here's one way to get the delay:
f_probe = 200;
tau_est1 = interp1(Txy{2}.f, unwrap(angle(Txy{2}.Txy)), f_probe)/(2*pi)/f_probe

% Here is another way, doubltessly overkill:
ii = Txy{2}.f < 2500;
fitfcn = @(tau, f) tau * f * 2*pi;
plot(Txy{2}.f, unwrap(angle(Txy{2}.Txy)), 'o', ...
     Txy{2}.f(ii), fitfcn(tau, Txy{2}.f(ii)), '-');
tau_est2 = lsqcurvefit(fitfcn, tau_est1, ...
    Txy{2}.f(ii), unwrap(angle(Txy{2}.Txy(ii))))

tau = tau_est2;

delay_fix = exp(-1i * 2*pi * tau * Txy{2}.f );
semilogx(Txy{2}.f, angle(Txy{2}.Txy .* delay_fix) * 180/pi, 'o-', 'color', [0 0.5 0]);

%set(gca, 'xscale', 'log');
xlabel('frequency');
ylabel('phase');
grid on;
title('Delay mostly removed');