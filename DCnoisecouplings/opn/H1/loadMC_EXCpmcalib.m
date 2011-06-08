% load calibration for excitation channel for oscillator phase noise
% coupling

SBint_TF = DTTloadTF('../oan/MC_1_EXCcal0.5dramp.txt'); % the magnitude is irrelevant, 
                                                        %just the phase will let us 
                                                        %remove the delay in this channel
                                                        
phi_Vpp = 0.0284 ; %taken from my SURF report this value is for 1kHz
f_IFRcal = 1000; %the freq the above number applies to

% what is the value of SBint_TF near 1kHz


delay_ref_mag = abs(interp1(SBint_TF(:,1),SBint_TF(:,2),f_IFRcal));

Vpp_V = 2; % 1V = 2Vpp

% final calibration

phimod_cal = colmult(SBint_TF,[1,phi_Vpp*Vpp_V/delay_ref_mag]);

save phimod_cal.mat phimod_cal
