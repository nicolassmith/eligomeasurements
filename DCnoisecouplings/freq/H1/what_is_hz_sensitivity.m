% what is the transfer function?

hz_mod_data = [abs(hz_mod_atfcal1),abs(hz_mod_atfcal2),abs(hz_mod_atfcal3)];

fcal = [f_cal1,f_cal2,f_cal3];

largenum = 1e12; % so that the min search doesn't give up to early
fitparams = fminsearch(@(b) largenum * sum( (hz_mod_data - b * fcal).^2 ),0);

f_fit = linspace(0,2200);
cal_fit = f_fit*fitparams;

plot(fcal,hz_mod_data,'r*',f_fit,cal_fit,'b')

xlim([0 2200])
ylim([0 6e-3])