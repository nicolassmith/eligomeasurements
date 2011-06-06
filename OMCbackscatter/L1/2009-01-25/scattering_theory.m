
Omega  =    0.3 * 2 * pi;  % Phase modulation frequency (radians/second)
A      =   33.0e-6; % Excitation amplitude (meters)
lambda = 1064e-9; % Laser wavelength (meters)

% Find the modulation index
Gamma = 4*pi*A/lambda

% Plot the resulting spectrum
N = 3000;
f = Omega*(1:N)/(2*pi);
spectrum = abs(besselj(1:N,Gamma));
semilogy(f, spectrum,'o')
ylim([1e-2 2e-1])
xlim([20 160])
fmax = 4*pi*(A/lambda)*Omega / (2*pi)

xlabel('frequency (Hz)');
ylabel('relative spectral amplitude');
line([fmax fmax], get(gca,'YLim'));
%axis tight;
grid on;

L = findobj(gcf, 'Tag', 'legend');
s = get(L, 'String');

s = [s, ...
     {sprintf('predicted scattering shelf (J_N(\\Gamma) for N=f/\\Omega) for \\Omega = %0.2f Hz, A = %0.2f {\\mu}m', ...
     Omega/(2*pi), A/1e-6)}, ...
     {sprintf('predicted knee frequency f = \\Gamma \\Omega = %0.2f Hz', fmax)}];
 
legend(s)

hold all
