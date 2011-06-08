% loads DTT OLMON to RIN calib

OLdata = DTTloadTF('OLMONtoOMCPD_20.6dc.txt'); % OLMON / DCPD

DCPDval = 20.6;

OLMONcalib = tfinv(colmult(OLdata,[1,DCPDval]));


save OLMONcalib.mat OLMONcalib