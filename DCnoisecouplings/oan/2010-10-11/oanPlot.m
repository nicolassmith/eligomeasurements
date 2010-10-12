% make oscillator amplitude noise plots.

load('../../DARMcalib.mat')
load('../SBint_cal.mat')

clear dataStructure;

% organize data
offsets = [15];
offstring = '';

offsetCalib = 9.6/15;

for kk = 1:length(offsets)
    offstring = num2str(abs(offsets(kk)),'%02d');
    if offsets(kk)<0
        offstring = ['-' offstring];
    end
    
    dataStructure(kk).offset = offsets(kk)*1e-12*offsetCalib;
    dataStructure(kk).filenames = {['x0' offstring 'pm8Wlf.txt'],...
                                   ['x0' offstring 'pm8Wmf.txt'],...
                                   ['x0' offstring 'pm8Whf.txt']};
    
    tempTF = [];                           
    for jj = 1:length(dataStructure(kk).filenames)
        if exist(dataStructure(kk).filenames{jj},'file')
            tempTF = specpatch(tempTF,DTTloadTF(dataStructure(kk).filenames{jj}));
        end
    end
    
    dataStructure(kk).fTF = calTF(tempTF,DARMcalib,SBint_cal);
    dataStructure(kk).legend = [num2str(dataStructure(kk).offset*1e12) 'pm offset'];
end


figure(120)
SRSbode(dataStructure.fTF)
legend(dataStructure.legend)

title('measured oscillator amplitude noise coupling for DC readout')
ylabel('m/Sideband RIN')