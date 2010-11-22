% take a bunch of data from a good locked time.
mDV

tgood = 971396235;

duration = 10*60; %10 minutes of data.

% channels

statechannels = {'H1:DMT-SNSM_RANGE_1MINAVG','H1:LSC-LA_PTRX_NORM','H1:LSC-LA_PTRY_NORM','H1:LSC-LA_SPOB_NORM'};

readoutchannels = {'H1:LSC-DARM_ERR','H1:OMC-PD_SUM_OUT_DAQ',...
    'H1:OMC-PD_TRANS1_OUT_DAQ','H1:OMC-PD_TRANS2_OUT_DAQ'};

omcalignchannels = {'H1:OMC-QPD3_P_OUT_DAQ','H1:OMC-QPD3_Y_OUT_DAQ','H1:OMC-QPD3_SUM_IN1_DAQ',...
    'H1:OMC-QPD4_P_OUT_DAQ','H1:OMC-QPD4_Y_OUT_DAQ','H1:OMC-QPD4_SUM_IN1_DAQ',...
    'H1:OMC-QPD1_P_OUT_DAQ','H1:OMC-QPD1_Y_OUT_DAQ','H1:OMC-QPD1_SUM_IN1_DAQ',...
    'H1:OMC-QPD2_P_OUT_DAQ','H1:OMC-QPD2_Y_OUT_DAQ','H1:OMC-QPD2_SUM_IN1_DAQ'};
                    

allchannels = [statechannels,readoutchannels,omcalignchannels];

lockeddata = get_data(allchannels,'raw',tgood,duration);

save(['lockeddata_' strrep(datestr(now),' ','_') '.mat'])