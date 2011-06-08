% make ISS plots.

load('../../DARMcalib.mat')
load('../REFL2RBcalib_07_07.mat')

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
                                   ['x0' offstring 'pm8Whf.txt']};
    
    tempTF = [];                           
    for jj = 1:length(dataStructure(kk).filenames)
        if exist(dataStructure(kk).filenames{jj},'file')
            tempTF = specpatch(tempTF,DTTloadTF(dataStructure(kk).filenames{jj}));
        end
    end
    
    f_data = tempTF(:,1);
    meanmodcal = mean([hz_mod_atfcal1/f_cal1  hz_mod_atfcal2/f_cal2  hz_mod_atfcal3/f_cal3]);
    MODcalib = [f_data , (1i * f_data)*meanmodcal];
    
    dataStructure(kk).fTF = calTF(tempTF,DARMcalib,MODcalib);
    dataStructure(kk).legend = [num2str(dataStructure(kk).offset*1e12) 'pm offset'];
end


figure(142)
SRSbode(dataStructure.fTF)
legend(dataStructure.legend)

title('measured frequency noise coupling for DC readout')
ylabel('m/Hz')