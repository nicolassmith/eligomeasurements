f_probe = 7300;

%% Load CM OLG
undb = @(mag_db) 10.^(mag_db/20);

foo = textread('CM000.ASC', '', 'headerlines', 17);
CM_f   = foo(:,1);
CM_OLG = undb(foo(:,2)) .* exp(1i * foo(:,3) * pi / 180);

% Plot it
subplot(2,1,1);
semilogx(CM_f, db(CM_OLG));
grid on
title('COMMON MODE OLG');
subplot(2,1,2);
semilogx(CM_f, angle(CM_OLG)*180/pi);
set(gca,'YTick', 45*(-4:4));
grid on;

CM_OLG_at_probe = interp1(CM_f, CM_OLG, f_probe);
fprintf('CM OLG at probe freq = %0.1f dB and %0.1f degrees\n', ...
    db(CM_OLG_at_probe), angle(CM_OLG_at_probe)*180/pi);
CM_corr = 1 - CM_OLG_at_probe;
fprintf('CM correction at probe freq = %0.1f dB and %0.1f degrees\n', ...
    db(CM_corr), angle(CM_corr)*180/pi);

%% Load DARM Calibration
data = textread('/data/dtt/tf/notebook/2010/01/darm-calib.txt', '', 'commentstyle', 'shell');
f_DarmCalib = data(:,1);
DarmCalib = 10.^(data(:,2)/20) .* exp(1i*data(:,3)*pi/180);

% Plot it
subplot(2,1,1);
loglog(f_DarmCalib, abs(DarmCalib));
ylabel('meters/count');
grid on
title('DARM CALIBRATION');
subplot(2,1,2);
semilogx(f_DarmCalib, angle(DarmCalib)*180/pi);
set(gca,'YTick', 45*(-4:4));
ylabel('degrees');
grid on;

DARM_Calib_at_probe = interp1(f_DarmCalib, DarmCalib, f_probe);
fprintf('DARM calibration at probe freq = %0.4g meters/count and %0.1f degrees\n', ...
    abs(DARM_Calib_at_probe), angle(DARM_Calib_at_probe)*180/pi);
%% 
close all;
offsets = [-20, -10, -5, 5, 10, 20];

cm = jet();

% subplot(1,1,1);
% hold off
for ii=1:length(offsets),
    offset = offsets(ii);
    filename = sprintf('tf_CM_sweep_x0=%+d.txt', offset);
    data = dlmread(filename);
    f = data(:,1);   
    %  REFL2_I calibration = 1.66e-4 Hz/count * [ f/(7300 Hz) ]
    ReflCalib =  (1.66e-4) .* (f / 7300);
    y = data(:,2) + 1i*data(:,3);
    % Apply the calibration
    y_calib = y .* interp1(f_DarmCalib, DarmCalib, f) ./ ReflCalib
    if offset < 0
        style = '--';
    else 
        style = '-';
    end 
    color = interp1(linspace(-20, 20, 64), cm, offset);
    %subplot(2,1,1);
    loglog(f, abs(y_calib), 'o-', ...
        'Color', color, 'LineWidth', 2);
    hold all
    %subplot(2,1,2);
    %semilogx(f, angle(y_calib)*180/pi, 'o-',  'Color', color, 'LineWidth', 2);
    %hold all
end
% ax(1) = subplot(2,1,1);
hold off
xlim([20 1000]);
grid on;
title('Laser frequency noise \rightarrow DARM ERR');
ylabel('(DARM meters) per (CARM Hz)');
legend(cellfun(@(x) sprintf('x0 = %+0.0f pm', x), num2cell(offsets), 'UniformOutput', 0), ...
    'Location', 'NorthEast');
% ax(2) = subplot(2,1,2);
% hold off
% grid on
%set(gca, 'XTick', [20 30 40 50 60 70 80 90 100 200 300 400 500 600 700 800 900]);
xlabel('frequency [Hz]');
% set(gca, 'YTick', 45*(-4:4));
% linkaxes(ax, 'x');
set(findall(gca, 'Type','text'), 'FontSize', 12);
make_figure_good();
print -dpdf tf_FM.pdf