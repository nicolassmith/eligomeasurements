% HAM6 ISI scattering test
%
% Described in LLO elog on 2009-01-25
%
% This script reads the data from a text file (exported from DTT), plots
% it, and integrates the power under the scattering shelf.

data = dlmread('OMCscatter2.txt');

f = data(:,1);      % Column 1: frequency
x_a = data(:,2);    % Column 2: Ambient OMC-READOUT spectrum (no excitation)
x_b = data(:,3);    % Column 3: READOUT spectrum with 16 um exc on ISI
x_0 = data(:,4);    % Column 4: READOUT spectrum with 33 um exc on ISI
clear data;

% Plot everything
loglog(f, x_0, '.-');
hold all
plot(f, x_a, '.-');
plot(f, x_b, '.-');
hold off;

legend('Ambient OMC-READOUT spectrum (no excitation)', ...
       'READOUT spectrum with 16 um exc on ISI', ...
       'READOUT spectrum with 33 um exc on ISI');

axis tight
grid on
xlim([20 160])
ylim([2e-5 0.04]);

% Compute the integrals

ii = (x_a ./ x_0) > 2;  % Find points where the spectrum is elevated
jj = (x_b ./ x_0) > 2;

bw = f(2) - f(1);       % Find the FFT resolution
a_rms = sqrt(bw * sum(x_a(ii).^2 - x_0(ii).^2))
b_rms = sqrt(bw * sum(x_b(jj).^2 - x_0(jj).^2))

