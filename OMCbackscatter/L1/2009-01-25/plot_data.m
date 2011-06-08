% This Matlab script loads the data from the 2009-01-25 LLO OMC scattering
% test (from .txt files extracted from the .xml files) and plots the
% spectra.  It also tries to reproduce the scattering shelf by taking a
% "background" time series
%
% Tobin Fricke 2011-03-22

%% Plot the data we have

% Load a time series
data = dlmread('OMCtimeseries.txt');
t = data(:,1);
x = data(:,2);
clear data;

% Load some spectra
data = dlmread('OMCscatter2.txt');

f_0 = data(:,1);    % Column 1: frequency
x_a = data(:,2);    % Column 2: Ambient OMC-READOUT spectrum (no excitation)
x_b = data(:,3);    % Column 3: READOUT spectrum with 16 um exc on ISI
x_0 = data(:,4);    % Column 4: READOUT spectrum with 33 um exc on ISI
clear data;

% Turn OMC-READOUT back into a PD signal, in mA
OMC_READOUT_GAIN = -73.245;
OMC_READOUT_OFFSET = -71.276;

x = x/OMC_READOUT_GAIN - OMC_READOUT_OFFSET;

x_0 = x_0 / abs(OMC_READOUT_GAIN);
x_a = x_a / abs(OMC_READOUT_GAIN);
x_b = x_b / abs(OMC_READOUT_GAIN);

loglog(f_0, x_0, ...
       f_0, x_a, ...
       f_0, x_b);
xlim([10 1000]);
ylabel('mA / rtHz');
xlabel('frequency');

%%  Try to reproduce the scattering shelf
close all

fs = 32768;
nfft = fs;

% First, make a spectrum of the 'background' signal:
[pxx, f] = pwelch(x, hanning(nfft), nfft/2, nfft, fs);

alpha = 18e-6;              % hypothesized scatterer amplitude refl coeff

Omega  = 2*pi*0.3;          % source oscillation frequency [Hz]
A      = 33.0e-6;           % amplitude of scattering oscillation [m]
lambda = 1064e-9;           % wavelength [m], duh
Gamma  = 4*pi*A/lambda;     % scattered field phase modulation depth

% Make up a time series of the power with simulated scattering
%y = (1 - alpha)*sqrt(x) + alpha * sqrt(x) .* exp(1i*Gamma*sin(Omega*t));
y = x .* abs(1 + alpha  * exp(1i * Gamma * cos(Omega * t))).^2;

% Make a spectrum of background+scattering
[pyy, f] = pwelch(y, hanning(nfft), nfft/2, nfft, fs);

% Plot it!
loglog(f, sqrt(pxx), '-', ...
    f, sqrt(pyy), '-', ...
    f_0, x_a, ...
    f_0, x_b);

xlim([10 1000]);
ylabel('mA / rtHz');
xlabel('frequency');
title('scattering test');
legend('DARM with no scattering', ...
    sprintf(['DARM with simulated scattering\n'...
             ' BUT NO LOOP SUPPRESSION!!!']), ...
    'scattering run #1', 'scattering run #2');
%end