%% Shot-noise-limited sensitivity prediction
% This script predicts the shot noise limited sensitivity of each detector,
% based on the input power and measured input and output efficiencies.
% This prediction is compared to the calibrated DARM spectrum, which is
% obtained through NDS2.  We get the calibrated h(t) time series, take the
% spectrum, and multiply by 3995 meters to get DARM meters.
%
% Tobin Fricke - March 2011

dur = 128;       % duration of data to get [s]
    
ifo = 'H1';

if strcmp(ifo, 'L1'),
    t0 = 965543700;  % Aug 11 2010 06:34:45 UTC -- best L1 range
    % L1:PSL-PWR_PWRSET = 14.13 W
    % L1:IOO-MC_PWR_IN  =  9.89 W
    % L1:DMT-SNSM_EFFECTIVE_RANGE_MPC = 20 MPc
    P_IN = 9.89;
    range = 20;
elseif strcmp(ifo,  'H1'),
    t0 = 962268780;  % Jul 04 2010 08:52:45 UTC -- best H1 range
    % Saving data to "H1-STRAIN-962268780.bin"...
    % <H1:PSL-PWR_PWRSET> = 20.00
    % <H1:IOO-MC_PWR_IN> = 20.27
    % <H1:DMT-SNSM_EFFECTIVE_RANGE_MPC.mean> = 21.37
    P_IN = 20.27;
    range = 21.37;
end

filename = sprintf('%s-STRAIN-%u.bin', ifo, t0);

server = 'ldas-pcdev1.ligo.caltech.edu:31200';


c = 299792458;  % m/s
h_planck = 6.62606896e-34; % J*s

%% Get the data

fd = fopen(filename, 'r');
if fd < 0,
    fprintf('Getting data using NDS2...\n');
    result = NDS2_GetData({[ifo ':DMT-STRAIN']; [ifo ':PSL-PWR_PWRSET']; ...
        [ifo ':IOO-MC_PWR_IN']; [ifo ':DMT-SNSM_EFFECTIVE_RANGE_MPC.mean']}, ...
        t0, dur, server);
    
    fprintf('Saving data to "%s"...\n', filename);
    fd = fopen(filename, 'w');
    
    for kk=2:4,
        fprintf('<%s> = %0.2f\n', result(kk).name, mean(result(kk).data));
    end
    
    P_IN = mean(result(3).data);

    if fd < 0,
        fprintf('Error: could not save data to file.\n');
    else
        fwrite(fd, result(1).data, 'double');
        fclose(fd);
    end
else
    fprintf('Getting data from cache...\n');
    result.data = fread(fd, inf, 'double');
    result.rate = 16384;
    fclose(fd);
end

%%
% Make a power spectrum
bw = 2;  % resolution [Hz]
nfft = 2^nextpow2(result(1).rate/bw);
navg = 2 * length(result(1).data)/nfft;

[result(1).Pxx, result(1).f] =  pwelch(detrend(result(1).data), ...
    hanning(nfft), nfft/2, nfft, result(1).rate);

%% Plot it

lambda = 1064e-9;             % wavelength [m]



if strcmp(ifo, 'H1'),     
    rcp = 137;                % arm cavity phase gain      tradition
    fc  = 85;                 % arm cavity pole            guess
    gcr = sqrt(59);           % carrier recycling gain     ilog 2008-12-14           
    input_eff =  ...          % input power efficiency     
       besselj(0,0.34)^2* ... % carrier fraction           ilog 2008-11-18
                 0.776 * ...  % Input optics efficiency    ilog 2008-07-23
                 0.935;       % coupling into IFO          LLO value
    % output optics efficiency
    omc_mm = 0.70;            % OMC mode-matching          ilog 2010-07-19
    output_eff = 0.98 * ...   % Output FI transmission     LLO value
                 0.97 * ...   % AS port pick-off           LLO value
                 omc_mm * ... % OMC mode-matching         
                 0.97 * ...   % OMC transmission           LLO value
                 0.97;        % OMC PD QE                  guess
    pwr_calib = 1;            % MC_PWR_IN calibration      
elseif strcmp(ifo, 'L1'),    
    rcp = 137;                % arm cavity phase gain      tradition    
    fc = (85.1 + 82.3)/2;     % arm cavity pole [Hz]       ilog 2010-06-24
    gcr = sqrt(43);           % carrier recycling gain     ??? 
    % input optics efficiency         
    input_eff =  ...          
       besselj(0,0.33)^2* ... % carrier fraction           ilog 2009-06-09
                 0.70 * ...   % Input optics efficiency    LIGO-G080490-00
                 0.935;       % coupling into IFO          ilog 2008-10-11
    % output optics efficiency
    output_eff = 0.9805 * ... % Output FI transmission     ilog 2008-08-17
                 0.972 * ...  % AS port pick-off           ilog 2009-05-11
                 0.95  * ...  % OMC mode-matching          ilog 2009-09-18
                 0.954;       % OMC trans & PD QE          ilog 2009-09-18
    % power calibration
    pwr_calib = (8.6/7.3);    % MC_PWR_IN calibration      ilog 2010-04-21
else
    error('Unknown IFO');
end

%sens = sqrt(h_planck * c / lambda) ./ (sqrt(2)* sqrt(P_IN * input_eff) * gcr * 137 * abs(1./(1+1i*f/85)) * 2*pi/lambda);

shot_noise_analytic =  sqrt(2 * h_planck * c / lambda)./ ...
        (2 * sqrt(P_IN * pwr_calib * input_eff * output_eff) * gcr * rcp * (2*pi/lambda) * abs(1./(1 + 1i*result(1).f./fc)));

if strcmp(ifo, 'H1'),
    color = [1,0,0];
elseif strcmp(ifo, 'L1'),
    color = [0,0.7,0];
else
    color = [1,0,1];
end

loglog(result(1).f, 3995*sqrt(result(1).Pxx), 'linewidth', 2.5, 'color', color);
hold all
loglog(result(1).f, shot_noise_analytic, 'k--', 'linewidth', 2.5);
hold off
xlim([20 7444]);
ylim([1e-20 1e-16]);
xlabel('frequency [Hz]');
ylabel('m/rtHz');

t_matlab = (t0 - 15)/(60*60*24) + datenum('1980-01-06 00:00');
grid on;
legend(sprintf('%s UTC (%0.1f Mpc)', datestr(t_matlab), range), ...
       sprintf('shot noise prediction with PIN = %0.1f W, Gcr = %0.0f', P_IN * pwr_calib, gcr^2));
title(sprintf('%s displacement spectrum', ifo));
% make the fonts bigger
set([gca; findall(gca, 'Type','text')], 'FontSize', 16);

if strcmp(ifo, 'H1'),
    text(0.513382, 0.104736, ...
        sprintf('OMC MM = %0.2f\n', omc_mm), ...
        'fontsize', 24, 'units', 'normalized');
end

orient landscape
print(gcf, '-dpdf', sprintf('%s-%u.pdf', ifo, t0));

% %%
% semilogx(result(1).f, db(3995*sqrt(result(1).Pxx) ./ shot_noise_analytic));
% grid on;
% ylim([-1 6]);
% xlim([400 7444]);
% line(get(gca,'xlim'), [1 1], 'color', [0 0 0]);