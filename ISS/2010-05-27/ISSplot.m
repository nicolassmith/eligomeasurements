% make ISS plots.

load('../../DARMcalib.mat')
load('../OLMONcalib.mat')

TF07pm = specpatch(DTTloadTF('x007pm8wlf.txt'),DTTloadTF('x007pm8whf.txt'));

TF07pmcal = calTF(TF07pm,DARMcalib,OLMONcalib);

TFm15pm = specpatch(DTTloadTF('x0-15pm8wlf.txt'),DTTloadTF('x0-15pm8whf.txt'));

TFm15pmcal = calTF(TFm15pm,DARMcalib,OLMONcalib);

figure(335)
SRSbode(TF07pmcal,TFm15pmcal)
title('Intensity Noise Coupling')
legend('7pm','-15pm')
ylabel('m/RIN')

% figure(333)
% SRSbode(TF20pm,TF15pm)