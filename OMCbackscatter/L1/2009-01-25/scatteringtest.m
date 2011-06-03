data = dlmread('OMCtimeseries.txt');

t = data(:,1);
x = data(:,2);
clear data;

OMC_READOUT_GAIN = -73.245;
OMC_READOUT_OFFSET = -71.276;
x = x/OMC_READOUT_GAIN - OMC_READOUT_OFFSET;
%%

fs = 32768;
nfft = fs;
[pxx, f] = pwelch(x, hanning(nfft), nfft/2, nfft, fs);

alpha = 1e-1;

Omega  = 0.3;
lambda = 1064e-9;
A      = 15.6e-6;
Gamma  = 4*pi*A/lambda;

y = (1 - alpha)*x + alpha * x .* sin( Gamma * sin(Omega * t));
[pyy, f] = pwelch(y, hanning(nfft), nfft/2, nfft, fs);

%%

loglog(f, pxx, '-', ...
       f, pyy, '-');
axis tight;