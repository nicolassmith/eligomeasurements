% loads calibration for excitation channel to sideband RIN
% this was with amplitude 5% depth on IFR

SBint_TF = DTTloadTF('MC_1_EXCcal0.5dramp.txt');

% now divide by the average power to get RIN

P_upperSB = 0.754073; % taken from notes.txt

SBint_cal = colmult(SBint_TF,[1,1/P_upperSB]);

save SBint_cal.mat SBint_cal