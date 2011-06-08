function [f, calib] = get_darm_calib(ifo, gpstime, f)
% GET_DARM_CALIB Get DARM_ERR calibration for some IFO at some time
%
%   [f, calib] = get_darm_calib(ifo, gpstime, f)
%

switch (ifo)
    case 'L1',
        filename = 'L1-darm-calib.txt';
    otherwise
        error('Unknown interferometer');
end

data = textread(filename, '', 'commentstyle', 'shell');
loaded_calib_f = data(:,1);
loaded_calib = 10.^(data(:,2)/20) .* exp(1i*data(:,3)*pi/180);

calib = interp1(loaded_calib_f, loaded_calib, f, 'linear');

end
