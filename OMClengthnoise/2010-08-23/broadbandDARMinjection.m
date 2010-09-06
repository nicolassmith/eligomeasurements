% look at broadband OMC length injection to DARM

% load spectra

[PZTOUTnoinj,DARMnoinj] = DTTloadspec('07-noexcitation-pztlscout-darmerr.txt');

[PZTOUTinj,DARMinj] = DTTloadspec('08-biggerexcitation-pztlscout-darmerr.txt');

PZTOUTinj2 = DTTloadspec('06-pztoutspec.txt');
DARMinj2 = DTTloadspec('06-DARMspec.txt');

% load DARM calibration

load('../../DCnoisecouplings/DARMcalib.mat')

% calibrate DARM to meters

DARMnoinj = abs(calTF(DARMnoinj,DARMcalib));
DARMinj = abs(calTF(DARMinj,DARMcalib));
DARMinj2 = abs(calTF(DARMinj2,DARMcalib));

% make plot

figure(63)

subplot(2,1,1)
SRSspec(PZTOUTnoinj,PZTOUTinj,PZTOUTinj2)

subplot(2,1,2)
SRSspec(DARMnoinj,DARMinj,DARMinj2)

% make subtractions

DARMex = quadsubtract(DARMinj,DARMnoinj);
PZTOUTex = quadsubtract(PZTOUTinj,PZTOUTnoinj);
DARMex2 = quadsubtract(DARMinj2,DARMnoinj);
PZTOUTex2 = quadsubtract(PZTOUTinj2,PZTOUTnoinj);

figure(64)
subplot(2,1,1)
SRSspec(PZTOUTex,PZTOUTex2)

subplot(2,1,2)
SRSspec(DARMex,DARMex2)

darmpztratio = [DARMex(:,1),DARMex(:,2)./PZTOUTex(:,2)];
darmpztratio2 = [DARMex2(:,1),DARMex2(:,2)./PZTOUTex2(:,2)];

figure(65)
SRSspec(darmpztratio,darmpztratio2)
ylabel('m[DARM]/ct[PZTOUT]')