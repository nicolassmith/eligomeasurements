% calibration of mod drive

f_cal1 = 967.5 ;

% first the ETM injection
darm_etm1 = -9.73376e-05 +1i* 7.30334e-05;

refl_etm1 = -0.000372109 +1i* -0.00359332;

load('../DARMcalib.mat')
meters_darm1 = calTF([f_cal1,1],DARMcalib);

c = 299792458;
lambda = 1064e-9;
L = 3995;
hz_meters = c/(lambda*L);

hz_refl_atfcal1 = hz_meters * meters_darm1(2) * darm_etm1 / refl_etm1;

% then the MOD readback cal (REFL2 in this case)

mod_resp1 = 14.712 +1i* -14.6437;

refl_resp1 = -0.0286712 +1i* 0.0828364;

mod_refl1 = mod_resp1 / refl_resp1;

% put it together 

hz_mod_atfcal1 = hz_refl_atfcal1 / mod_refl1 ; % .* modpermod(:,2)]; removed mod per mod

% second frequency

f_cal2 = 522.6 ; 

darm_etm2 = 5.71184e-05 +1i* 0.000144502;

refl_etm2 = -0.00110862 +1i* -0.000497388;

meters_darm2 = calTF([f_cal2,1],DARMcalib);

hz_refl_atfcal2 = hz_meters * meters_darm2(2) * darm_etm2 / refl_etm2;

% then the MOD readback cal (REFL2 in this case)

mod_resp2 = -8.10891 +1i* 19.0345;

refl_resp2 = 0.0129492 +1i* -0.0218396;

mod_refl2 = mod_resp2 / refl_resp2;

% put it together 

hz_mod_atfcal2 = hz_refl_atfcal2 / mod_refl2 ;

save REFL2RBcalib.mat hz_mod_atfcal1 f_cal1 hz_mod_atfcal2 f_cal2

