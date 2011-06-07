
%% Load the DARM calibration
[f_DarmCalib, DarmCalib] = get_darm_calib('L1', 962679241, []);

%% Load the oscillator AM calibration
temp = dlmread('../06/OSCAM_SBSB_amp=1.4142.txt');
f_AMcalib = temp(:,1);
AMcalib = (temp(:,2*4+2) + 1i*temp(:,2*4+3)) /  0.2234;  % Gives RIN per count of EXC

semilogx(f_AMcalib, abs(AMcalib), 'o-');
%% Come up with an oscillator FM calibration
%  Keita's LHO elog of January 25, 2007 indicates 7.2 Hz/V measured, but
%  I'll use the indicated (10 Hz)/(1 Vrms) = 7.07 Hz/V.
%
f_FMcalib = f_AMcalib;
FMcalib = (10 / sqrt(2)) ./ f_FMcalib;

f_PMcalib = f_AMcalib;
PMcalib =   (AMcalib / mean(AMcalib(1:10))) * (0.01 / sqrt(2));   % radians/count


%% Oscillator PM
close all
filenames= {'OSCPM_RF',     'OSCPM_x0=+20', 'OSCPM_x0=+15',  'OSCPM_x0=+13', ...
            'OSCPM_x0=+10', 'OSCPM_x0=+05', 'OSCPM_x0=-05',  'OSCPM_x0=-10', ...
            'OSCPM_x0=-13', 'OSCPM_x0=-15',	'OSCPM_x0=-20'};
         
offsets = [0, 20, 15, 13, 10, 5, -5, -10, -13, -15, -20];
cm = jet();
hold off
for ii=1:length(filenames)
    filename = filenames{ii};    
    data(ii).filename = filename;
    temp = dlmread([filename '.txt']);
    data(ii).f   = temp(:,1);
    data(ii).Txy = temp(:,(1:7)*2) + 1i* temp(:,(1:7)*2+1);
    temp = dlmread([filename '.coh']);
    data(ii).coh = temp(:,2:end);
    
    color = interp1(linspace(-20, 20, length(cm)), cm, offsets(ii));
    
    trace = abs(data(ii).Txy(:,1) ...
                .* interp1(f_DarmCalib, DarmCalib, data(ii).f) ...
                ./ interp1(f_PMcalib,   PMcalib,   data(ii).f));

    kk = (data(ii).coh(:,1) > 0.8);
    trace(~kk) = NaN;              
    
%    subplot(2,1,1);
    loglog(data(ii).f,  trace, 'o-', 'color', color, 'LineWidth', 2);
    hold all
%     subplot(2,1,2);
%     plot(data(ii).f, data(ii).coh(:,1), 'o-', 'color', color);
%     hold all;
end

% ax = subplot(2,1,1);
set(findall(gca, 'Type','text'), 'FontSize', 12)
ylabel('(DARM meters) / (oscillator radians) ');
title('Oscillator \Phi{}M coupling to DARM');
grid on;
xlim([40 8000]);

legend('RF', 'DC +20pm', 'DC +15pm','DC +13pm', 'DC +10pm', 'DC +5pm',...
             'DC -5pm', 'DC -10pm', 'DC -13pm','DC -15pm', 'DC -20pm', ...
        'Location', 'NorthWest');
% 
% ax(2) = subplot(2,1,2);
% set(findall(gca, 'Type','text'), 'FontSize', 12)
% set(gca, 'xscale', 'log')
% xlabel('frequency [Hz]');
% ylabel('Coherence');
% xlim([40 8000]);
% grid on;
% linkaxes(ax, 'x');
%set(gcf, 'PaperSize', [7.5 4], 'PaperUnits', 'Inches');    
%orient landscape
make_figure_good();
print -dpdf tf_OSCFM.pdf

%% Oscillator AM
close all
filenames = {
    'OSCAM_RF_amp=0.010', 'OSCAM_x0=+20_amp=0.001',  'OSCAM_x0=+15_amp=0.001', 'OSCAM_x0=+10_amp=0.001', ...
    'OSCAM_x0=+05_amp=0.001',  'OSCAM_x0=-10_amp=0.001',  'OSCAM_x0=-13_amp=0.001', 'OSCAM_x0=-20_amp=0.001',...
    'OSCAM_x0=-20_amp=0.010'
    };
         
cm = jet();
        
offsets = [0, 20, 15, 10, 5, -10, -13, -20, -20];

% subplot(2,1,2);
% hold off
% subplot(2,1,1)
% subplot(1,1,1);
% hold off

for ii=1:length(filenames)
    filename = filenames{ii};    
    data(ii).filename = filename;
    temp = dlmread([filename '.txt']);
    data(ii).f   = temp(:,1);
    data(ii).Txy = temp(:,(1:7)*2) + 1i* temp(:,(1:7)*2+1);
    temp = dlmread([filename '.coh']);
    data(ii).coh = temp(:,2:end);

    color = interp1(linspace(-20, 20, length(cm)), cm, offsets(ii));

    trace = abs(data(ii).Txy(:,1)  ...
               .* interp1(f_DarmCalib, DarmCalib, data(ii).f) ...
               ./ interp1(f_AMcalib, AMcalib, data(ii).f));

   % subplot(2,1,1);
    kk = (data(ii).coh(:,1)>0.80);
    plot(data(ii).f(kk), trace(kk), 'o-', 'LineWidth', 2, 'color', color); 
    hold all
   % subplot(2,1,2);
   % plot(data(ii).f, data(ii).coh(:,1), 'o-', 'color', color);
   % hold all;
end

% ax = subplot(2,1,1);
set(findall(gca, 'Type','text'), 'FontSize', 12)
set(gca, 'xscale', 'log', 'yscale', 'log')
ylabel('(DARM meters) / (sideband RIN) ');
xlabel('frequency [Hz]');
title('Oscillator AM coupling to DARM');
grid on;
xlim([40 8000]);
 legend('RF', 'DC x0= +20', 'DC x0= +15', 'DC x0= +10', 'DC x0= +5',...
              'DC x0= -10', 'DC x0= -13', 'DC x0= -20', ...
        'Location', 'NorthWest');
      
% ax(2) = subplot(2,1,2);
% set(findall(gca, 'Type','text'), 'FontSize', 12)
% set(gca, 'xscale', 'log')
% ylabel('Coherence');
% xlim([40 8000]);
% grid on;
% linkaxes(ax, 'x');
%set(gcf, 'PaperSize', [7.5 4], 'PaperUnits', 'Inches');    
%orient landscape
make_figure_good();
print -dpdf tf_OSCAM.pdf


% 

