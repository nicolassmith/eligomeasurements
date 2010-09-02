% estimate OMC length contribution to DARM

% load PZT out calibration

PDSUMoverPZTOUT = DTTloadTF('05-pdsumoverpztlscout.txt');

Finesse = 370;
lambda = 1064e-9;
P_t0 = 20.7104; %PDSUM (when locked without offset)
P_i0 = 379.952; %QPD3SUM

Pin = 97.1630 * P_t0 / P_i0; %calibrate QPDsum to PDSUM units
Ptrans = 2.6583;

delta = sqrt(Pin/Ptrans - 1); %detuning
    
calcoefficient = Pin / Ptrans^2 / (4 * Finesse) / (2 * delta) * lambda;

OMClengthoverPZTOUT = colmult(PDSUMoverPZTOUT,[1,calcoefficient]);

figure(55)
SRSbode(OMClengthoverPZTOUT)
ylabel('m[OMC]/ct[PZTOUT]')

cd ../2010-08-23
lengthnoisepowspec
broadbandDARMinjection
cd ../2010-09-01

%close all

% meas5cal.lengthnoisespectrum <- OMC length
% OMClengthoverPZTOUT <- OMClength / PZTOUT
% darmpztratio <- m DARM / PZTOUT

% DARMnoinj <- DARM spectrum

darmOMClengthnoise = applytfinterp(tfinv(OMClengthoverPZTOUT),applytfinterp(darmpztratio,meas5cal.lengthnoisespectrum));

figure(22)
SRSspec(darmOMClengthnoise,DARMnoinj)

ylabel('m/rt(Hz)')
legend('OMC length','DARM')