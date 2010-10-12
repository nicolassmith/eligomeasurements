% calibration of mod drive for july 7 2010 measurement

f_cal1 = 953.6 ;

% first the ETM injection
darm_etm1 = -9.6483e-05 +1i* 0.000163299; %coherence 1

refl_etm1 = -0.00237927 +1i* -0.00378346; %coherence .973

load('../DARMcalib.mat')
meters_darm1 = calTF([f_cal1,1],DARMcalib);

c = 299792458;
lambda = 1064e-9;
L = 3995;
hz_meters = c/(lambda*L);

hz_refl_atfcal1 = hz_meters * meters_darm1(2) * darm_etm1 / refl_etm1;

% then the MOD readback cal (REFL2 in this case)

mod_resp1 = 7.40905 +1i* -19.4112; %coh 1 % this is the refl2_I (readback of mod) channel

refl_resp1 =  0.0153899 +1i* 0.256181; % coh .995 % this is the actual refl1_1

mod_refl1 = mod_resp1 / refl_resp1;

% put it together 

hz_mod_atfcal1 = hz_refl_atfcal1 / mod_refl1 ; % .* modpermod(:,2)]; removed mod per mod

% second frequency

f_cal2 = 2101.1 ; 

darm_etm2 = -4.23319e-05 +1i* 5.41204e-05;% coh 1

refl_etm2 = -0.000428278 +1i* -0.00269626;% coh .973

meters_darm2 = calTF([f_cal2,1],DARMcalib);

hz_refl_atfcal2 = hz_meters * meters_darm2(2) * darm_etm2 / refl_etm2;

% then the MOD readback cal (REFL2 in this case)

mod_resp2 = 7.73496 +1i* -19.0531;% coh 1 %-8.10891 +1i* 19.0345;

refl_resp2 = 0.157784 +1i* 0.651717;% coh 1.000 %0.0129492 +1i* -0.0218396;

mod_refl2 = mod_resp2 / refl_resp2;

% put it together 

hz_mod_atfcal2 = hz_refl_atfcal2 / mod_refl2 ;

% third frequency

f_cal3 = 1385.2 ; 

darm_etm3 = 8.83128e-05 +1i* 0.000240518;% coh 1 

refl_etm3 = -0.00842992 +1i* -0.000330097;% coh .983

meters_darm3 = calTF([f_cal3,1],DARMcalib);

hz_refl_atfcal3 = hz_meters * meters_darm3(2) * darm_etm3 / refl_etm3;

% then the MOD readback cal (REFL2 in this case)

mod_resp3 = 13.2171 +1i* 15.9365;% coh 1 

refl_resp3 = -0.416978 -0.081162;% coh .9996 

mod_refl3 = mod_resp3 / refl_resp3;

% put it together 

hz_mod_atfcal3 = hz_refl_atfcal3 / mod_refl3 ;

save REFL2RBcalib.mat hz_mod_atfcal1 f_cal1 hz_mod_atfcal2 f_cal2 hz_mod_atfcal3 f_cal3

