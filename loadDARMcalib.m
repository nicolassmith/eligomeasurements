% loads DTT darm calibration

[head,data] = hdrload('DARMcalib.txt');

DARMcalib = [data(:,1),10.^(data(:,2)/20) .* exp(1i*data(:,3)*pi/180)];

save DARMcalib.mat DARMcalib