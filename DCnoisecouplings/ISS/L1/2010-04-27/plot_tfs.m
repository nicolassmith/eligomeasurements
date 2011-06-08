% Error bars
%  s.d.(|Hxy|) = sqrt((1-Cxy)/(2Cxy Navg)) * |Hxy|
%  s.d.(phi of Hxy) = sqrt( (1-Cxy)/(2 Cxy Navg))

Navg = 30;

%% Load the DARM calibration

data = textread('/data/dtt/tf/notebook/2010/01/darm-calib.txt', '', 'commentstyle', 'shell');
f_DarmCalib = data(:,1);
DarmCalib = 10.^(data(:,2)/20) .* exp(i*data(:,3)*pi/180);

% The whitened channel has a gain of 1000, and the mean DC is 17486 counts
ISS_Calib = (1/1000)*(1/17486);  

%%
close all;

filenames = {'tf_ISS_sweep_x0=-15B.txt',  'tf_ISS_sweep_x0=15C.txt',   'tf_ISS_sweep_x0=-20.txt',   'tf_ISS_sweep_x0=5.txt', ...
    'tf_ISS_sweep_x0=-10.txt', 'tf_ISS_sweep_x0=15B.txt',   'tf_ISS_sweep_x0=15D.txt',  'tf_ISS_sweep_x0=20.txt', ...
    'tf_ISS_sweep_x0=10.txt',	 'tf_ISS_sweep_x0=-15C.txt',  'tf_ISS_sweep_x0=-15.txt',  'tf_ISS_sweep_x0=-5.txt'};

offsets = [-15, 15, -20, 5, -10, 15, 15, 20, 10, -15, -15, -5];
[foo, jj] = sort(offsets);

cm = jet();

hold off
for ii=1:length(filenames),
    data = dlmread(filenames{jj(ii)});
    f = data(:,1);   
    y2 = data(:,4) + 1i*data(:,5);
    
    % fix up the filename to get the coherence
    filename = filenames{jj(ii)};
    filename((end-2):end)='coh';
    data = dlmread(filename);
    f_coh = data(:,1);
    coh = data(:,3);
    
    if ~all(f_coh == f),
      error('Coherence and transfer function frequency vectors disagree!');
    end

    % Apply the calibration
    y2_calib = y2 .* interp1(f_DarmCalib, DarmCalib, f) / ISS_Calib;
    
    % Select points with good enough coherence
    sel = (coh > 0.2);
    % Throw away data that is not good enough
    f = f(sel);
    y2 = y2(sel);
    coh = coh(sel);
    y2_calib = y2_calib(sel);

    % compute the fractional error
    err =  sqrt((1-coh)./(2*coh*Navg));
    
    % For purposes of insanity, try to fit the data
%     [b, a] = invfreqs(y2_calib, 2*pi*f, 4, 4, abs(err .* y2_calib).^(-2));    
%     [model, model_w] = freqs(b, a, 2*pi*logspace(log10(min(f)), log10(max(f)), 505));
    
    color = interp1(linspace(-20, 20, 64), cm, (offsets(jj(ii))));
    err =  sqrt((1-coh)./(2*coh*Navg));
    figure(1)
    loglog(f, abs(y2_calib), 'o-', 'Color', color, 'LineWidth', 2);
    hold all
%     loglog(model_w/(2*pi), abs(model), '-', 'Color', color, 'LineWidth', 2);
    figure(2)
    semilogx(f, coh, 'color', color);
    hold all
end
figure(1);
hold off
%set(gca, 'xscale', 'log', 'yscale', 'log')
xlim([20 1000]);
grid on;
title('Laser intensity noise \rightarrow DARM ERR');
ylabel('(DARM meters) per RIN');
legend(cellfun(@(x) sprintf('x0 = %0.0f pm', x), num2cell(offsets(jj)), 'UniformOutput', 0), ...
    'Location', 'SouthEast');
%set(gca, 'XTick', [20 30 40 50 60 70 80 90 100 200 300 400 500 600 700 800 900 1000]);
xlabel('frequency [Hz]');

set(findall(gca, 'Type','text'), 'FontSize', 12)
make_figure_good();
print -dpdf tf_AM.pdf
