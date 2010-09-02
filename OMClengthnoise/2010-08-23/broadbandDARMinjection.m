% look at broadband OMC length injection to DARM

% load spectra

[PZTOUTnoinj,DARMnoinj] = DTTloadspec('07-noexcitation-pztlscout-darmerr.txt');

[PZTOUTinj,DARMinj] = DTTloadspec('08-biggerexcitation-pztlscout-darmerr.txt');

% load DARM calibration

load('../../DCnoisecouplings/DARMcalib.mat')

% calibrate DARM to meters

DARMnoinj = abs(calTF(DARMnoinj,DARMcalib));
DARMinj = abs(calTF(DARMinj,DARMcalib));

% make plot

figure(43)

subplot(2,1,1)
SRSspec(PZTOUTnoinj,PZTOUTinj)

subplot(2,1,2)
SRSspec(DARMnoinj,DARMinj)

% make subtractions

DARMex = quadsubtract(DARMinj,DARMnoinj);%[DARMnoinj(:,1),realsqrt(DARMinj(:,2).^2 - DARMnoinj(:,2).^2)]; % USE QUADSUBTRACT HERE
PZTOUTex = quadsubtract(PZTOUTinj,PZTOUTnoinj);%[PZTOUTnoinj(:,1),realsqrt(PZTOUTinj(:,2).^2 - PZTOUTnoinj(:,2).^2)];

figure(44)
subplot(2,1,1)
SRSspec(PZTOUTex)

subplot(2,1,2)
SRSspec(DARMex)

darmpztratio = [DARMex(:,1),DARMex(:,2)./PZTOUTex(:,2)];

figure(45)
SRSspec(darmpztratio)
ylabel('m[DARM]/ct[PZTOUT]')