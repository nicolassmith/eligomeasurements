% first let's double check our length noise measurement



PDSUM1 = DTTloadspec('01-pdsum-trans1.txt');
dt = PDSUM1(2,1) - PDSUM1(1,1);
fs = round(1/dt);


t = PDSUM1(:,1);
offsettrans = PDSUM1(:,2);

% this is locked with no offset

P_t0 = 14.684;
P_i0 = 373.246;

% now locked with offset (2mA transmission on short side)

P_t = 1.99881;
P_i = 356.746;


% get calibration coefficient to calibrate trans power into meters

Finesse = 370;
lambda = 1064e-9;

Pin = P_i * P_t0/P_i0 ;

Ptrans = P_t ;

delta = sqrt(Pin/Ptrans - 1); %detuning

calcoefficient = Pin / Ptrans^2 / (4 * Finesse) / (2 * delta) * lambda;

% apply calibration

lengthnoise = calcoefficient * offsettrans ;

% use asd.m to make asd

addpath('/home/nicolas/Documents/MATLAB/mDV/extra');


% add length control filter

lengthloopOLG = zpkf([-20],[0,0],-600); % 50Hz UGF, boost below 20Hz

% wonderful help from tobin: http://nibot-lab.livejournal.com/95199.html

lengthCLGdiscreet = c2d(1/(1-lengthloopOLG), 1/fs, 'tustin');

[b, a] = tfdata(lengthCLGdiscreet, 'v');
lengthnoiseinloop = filter(b, a, lengthnoise);


% check calibration

noloopASD = asd(lengthnoise,fs,1/2^2);
inloopASD = asd(lengthnoiseinloop,fs,1/2^2);

figure(323)
SRSspec([noloopASD.f,noloopASD.x],[inloopASD.f,inloopASD.x])  % looks ok



% now change into equivilant RIN of no offset lock

RINseries = 1 - (lengthnoise-mean(lengthnoise)).^2 / lambda ^ 2 * ( 4 * Finesse ) ^2;
RINinloop = 1 - (lengthnoiseinloop-mean(lengthnoiseinloop)).^2 / lambda ^ 2 * ( 4 * Finesse ) ^2;


% now look at RIN spectrum

RINspec = asd(RINseries,fs,1/2^2);
RINspecinloop = asd(RINinloop,fs,1/2^2);


figure(324)
SRSspec([RINspec.f,RINspec.x],[RINspecinloop.f,RINspecinloop.x])

% calibrate to DARM

% from /users/nsmith/measurements/OMClengthnoise/07-06/ on lho, meas 07

PDSUMavg = 35.7656;
DARMoverPDSUM = 8.27513e-9/1.17891e-7;

calRINtoDARM = PDSUMavg * DARMoverPDSUM ;

% load a calibrated DARM
[PZTOUTnoinj,DARMnoinj] = DTTloadspec('../2010-08-23/07-noexcitation-pztlscout-darmerr.txt');
load('../../DCnoisecouplings/DARMcalib.mat')
DARMnoinj = abs(calTF(DARMnoinj,DARMcalib));

% make noise budget like plot

figure(325)
SRSspec(abs(calTF([RINspec.f,calRINtoDARM*RINspec.x],DARMcalib)),abs(calTF([RINspecinloop.f,calRINtoDARM*RINspecinloop.x],DARMcalib)),DARMnoinj)