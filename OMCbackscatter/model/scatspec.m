
% creates a scattering spectrum

omega = .3;%Hz
A = .409e4*1e-9;%m
lambda = 1064e-9;%m
fmax = 300;%Hz
BW = 0.3;%Hz


f = omega:omega:fmax;

A = sqrt((sqrt(2)*besselj(f/omega,4*pi*A/lambda)).^2/BW);

figure(2)
loglog(f,A)
ylim([1e-4 1])