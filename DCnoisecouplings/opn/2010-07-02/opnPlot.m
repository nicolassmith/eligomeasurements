% make oscillator phase noise plots.

load('../../DARMcalib.mat')
load('../phimod_cal.mat')

clear dataStructure;

% organize data
offsets = [-07 -15 -27 07 15 27];
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
    
    dataStructure(kk).fTF = calTF(tempTF,DARMcalib,phimod_cal);
    dataStructure(kk).legend = [num2str(dataStructure(kk).offset*1e12) 'pm offset'];
end


figure(122)
SRSbode(dataStructure.fTF)
legend(dataStructure.legend)

title('measured oscillator phase noise coupling for DC readout')
ylabel('m/radian')