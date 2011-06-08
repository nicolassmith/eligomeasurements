% Load a time series
data = dlmread('OMCtimeseries.txt');

t = data(:,1);
x = data(:,2);
clear data;

% Load some spectra
data = dlmread('OMCscatter2.txt');

f_0 = data(:,1);      % Column 1: frequency
x_a = data(:,2);    % Column 2: Ambient OMC-READOUT spectrum (no excitation)
x_b = data(:,3);    % Column 3: READOUT spectrum with 16 um exc on ISI
x_0 = data(:,4);    % Column 4: READOUT spectrum with 33 um exc on ISI
clear data;

OMC_READOUT_GAIN = -73.245;
OMC_READOUT_OFFSET = -71.276;

x = x/OMC_READOUT_GAIN - OMC_READOUT_OFFSET;

x_0 = x_0 / abs(OMC_READOUT_GAIN);
x_a = x_a / abs(OMC_READOUT_GAIN);
x_b = x_b / abs(OMC_READOUT_GAIN);
%%
close all 

fs = 32768;
nfft = fs;
[pxx, f] = pwelch(x, hanning(nfft), nfft/2, nfft, fs);

alpha = 18e-6;

Omega  = 2*pi*0.3;
lambda = 1064e-9;
A      = 33.0e-6;
Gamma  = 4*pi*A/lambda;

%y = (1 - alpha)*sqrt(x) + alpha * sqrt(x) .* exp(1i * Gamma * sin(Omega *
%t));
y = x .* abs(1 + alpha  * exp(1i * Gamma * cos(Omega * t))).^2;
[pyy, f] = pwelch(y, hanning(nfft), nfft/2, nfft, fs);


loglog(f, sqrt(pxx), '-', ...
       f, sqrt(pyy), '-', ...
       f_0, x_a, ...
       f_0, x_b);
%axis tight;
xlim([10 1000]);
%ylim([
ylabel('mA / rtHz');
xlabel('frequency');
