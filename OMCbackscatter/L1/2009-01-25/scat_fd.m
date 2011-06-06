% HAM6 ISI scattering test
%
% Described in LLO elog on 2009-01-25
%
% This script reads the data from a text file (exported from DTT), plots
% it, and integrates the power under the scattering shelf.

%% Load the scattering spectra
data = dlmread('OMCscatter2.txt');

f = data(:,1);      % Column 1: frequency
x_a = data(:,2);    % Column 2: Ambient OMC-READOUT spectrum (no excitation)
x_b = data(:,3);    % Column 3: READOUT spectrum with 16 um exc on ISI
x_0 = data(:,4);    % Column 4: READOUT spectrum with 33 um exc on ISI
clear data;

OMC_READOUT_GAIN = -73.245;
OMC_READOUT_OFFSET = -71.276;

%% Load the Open Loop Gain

calib_path = '/data/dtt/Calibration/CVS/calibration/';
if ~exist('DARMmodel'),
    addpath(path, [calib_path 'frequencydomain/runs/S6/MatlabScripts']);
    addpath(path, [calib_path 'frequencydomain/runs/S6/L1/model/V2/']);
end
%%
ifo = L1DARMparams_934487415;
[G,~,~,~,~,~,~,~,~,~] = DARMmodel(ifo, f);

%%
% Plot everything
subplot(1,1,1);
loglog(f, x_0 .* abs(1+G), '.-');
hold all
plot(f, x_a .* abs(1+G), '.-');
plot(f, x_b .* abs(1+G), '.-');
hold off;

legend('Ambient OMC-READOUT spectrum (no excitation)', ...
       'READOUT spectrum with 16 um exc on ISI', ...
       'READOUT spectrum with 33 um exc on ISI');

axis tight
grid on
xlim([20 300])
ylim([1e-5 1]);

%%
subplot(1,1,1);

ii = (x_a.^2 > 4*x_0.^2) & (f>40);
results(1).X = sqrt(x_a(ii).^2 - x_0(ii).^2) .* abs(1 + G(ii)) / ...
    abs(OMC_READOUT_OFFSET);
results(1).f = f(ii);


ii = (x_b.^2 > 4*x_0.^2) & (f>40);
results(2).X = sqrt(x_b(ii).^2 - x_0(ii).^2) .* abs(1 + G(ii)) / ...
    abs(OMC_READOUT_OFFSET);
results(2).f = f(ii);

% try to fill in the low-frequency contribution
for ii=1:2,
    dcval = mean(results(ii).X(1:10));
    results(ii).X = [dcval; results(ii).X];
    results(ii).f = [1; results(ii).f];
end

clear ii;

loglog(results(1).f, results(1).X, '.-');
hold all
title('Loop-corrected RIN due to scattering');
plot(results(2).f, results(2).X, '.-');
hold off
xlim([10 300]);
% Compute the integrals
%%

for ii=1:2,
    results(ii).rms = trapz(results(ii).f, results(ii).X);
end
