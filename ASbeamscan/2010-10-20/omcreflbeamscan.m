% beam scan fit for omc refl scan data (Oct 19 2010)

m_in = 0.0254; % meters per inch
m_um = 1e-6;
w_omc=4.96e-4;

% distance from 0 on beam scan to OMC input mirror

originshift = (-1.5+6+21+6+4.25) + 24.6 + (2.8+10+23+7) ;
            % ^from 0 to viewport
            %                      ^from viewport to ISI edge
            %                             ^ from edge of isi to omc input

% same for ITMX single bounce "trial 1"

scanITMX.pos = (0:20)+originshift; % 1 inch spaced measurements, 0 to 20 inches.

% scan data A1 is horizontal. Units are um diameter beam width
scanITMX.A1 = [4156.0 4178.7 4200.5 4224.5 4251.1 4283.5 4331.1 4347.8...
    4363.7 4383.2 4407.8 4431.3 4447.0 4462.7 4488.0 4518.0 4535.5...
    4551.7 4567.6 4585.2 4610.1];

scanITMX.A2 = [4219.3 4226.2 4270.3 4310.3 4360.0 4382.7 4415.4 4489.8...
    4512.2 4536.4 4592.1 4637.5 4651.4 4679.0 4722.8 4760.5 4779.1...
    4804.4 4825.6 4875.3 4893.2];

% first ITMY single bounce "trial 2"

scanITMY.pos = (0:20)+originshift;

% scan data 
scanITMY.A1  = [4369.7 4390.7 4408.8 4429.8 4452.8 4489.6 4513.2 4531.6...
    4550.1 4572.4 4612.0 4632.8 4644.5 4664.2 4682.4 4719.6 4750.9...
    4766.5 4781.4 4806.6 4828.8];

scanITMY.A2  = [4258.1 4313.3 4360.5 4389.6 4424.1 4500.7 4529.6 4558.7...
    4612.1 4662.6 4692.8 4719.9 4748.4 4811.6 4829.2 4838.8 4875.3...
    4925.0 4926.0 4963.6 4987.7];
           
% finally, IFO AS port with DARM offset "trial 3"

scanAS.pos = (0:20)+originshift;

scanAS.A1 = [3796.6 3825.4 3835.0 3866.6 3885.4 3890.8 3921.8 3933.3...
    3952.4 3974.2 3988.3 4005.1 4029.0 4063.1 4052.8 4070.8 4082.6...
    4099.3 4115.4 4135.5 4146.9];

scanAS.A2 = [4041.8 4130.5 4122.9 4232.0 4264.1 4207.6 4285.6 4311.4...
    4365.3 4412.0 4448.0 4451.1 4455.5 4470.9 4496.5 4557.4 4628.9...
    4609.7 4643.8 4790.6 4727.9];
         

% We need a starting point to try to fit the beam to
initialPath = beamPath;
initialPath.seedWaist(5e-4,0);%-2+originshift*m_in);
initialPath.targetWaist(w_omc,0)

% add components

% TT distances are all Zemaxed
OMC2TT2=.3510;%0.27;
TT1_TT2=1.84;
TT0_TT1=.76;

TT2 = component.curvedMirror(2,-OMC2TT2,'TT2');
TT1 = component.curvedMirror(-0.5,-OMC2TT2-TT1_TT2,'TT1');
TT0 = component.curvedMirror(2,-OMC2TT2-TT1_TT2-TT0_TT1,'TT0');

% BRT components
ROT1=3.048;
ROT2=-0.381;

OBS_TT0 = 15.3; % not sure, but it should be close enough.
OT2_OBS=1;
OT1_OT2=1.3335;

OBS = component.flatMirror(TT0.z-OBS_TT0,'OBS');
BRT2 = component.curvedMirror(ROT2,OBS.z-OT2_OBS,'BRT2');
BRT1 = component.curvedMirror(ROT1,BRT2.z-OT1_OT2,'BRT1');

initialPath.addComponent([TT0,TT1,TT2,OBS,BRT2,BRT1]);


% now fit beam to data
scanITMY.horzpath = initialPath.fitBeamWidth(scanITMY.pos*m_in,scanITMY.A1*m_um/2);
scanITMY.vertpath = initialPath.fitBeamWidth(scanITMY.pos*m_in,scanITMY.A2*m_um/2);
scanITMX.horzpath = initialPath.fitBeamWidth(scanITMX.pos*m_in,scanITMX.A1*m_um/2);
scanITMX.vertpath = initialPath.fitBeamWidth(scanITMX.pos*m_in,scanITMX.A2*m_um/2);
scanAS.horzpath = initialPath.fitBeamWidth(scanAS.pos*m_in,scanAS.A1*m_um/2);
scanAS.vertpath = initialPath.fitBeamWidth(scanAS.pos*m_in,scanAS.A2*m_um/2);


% plots

plotdomain = -25:.01:4;

figure(786)
clf
hold on
plot(scanITMY.pos*m_in,scanITMY.A1*m_um/2,'r^')
plot(scanITMY.pos*m_in,scanITMY.A2*m_um/2,'rv')
plot(scanITMX.pos*m_in,scanITMX.A1*m_um/2,'b^')
plot(scanITMX.pos*m_in,scanITMX.A2*m_um/2,'bv')
plot(scanAS.pos*m_in,scanAS.A1*m_um/2,'g^')
plot(scanAS.pos*m_in,scanAS.A2*m_um/2,'gv')

scanITMY.horzpath.plotBeamWidth(plotdomain,'r--')
scanITMY.vertpath.plotBeamWidth(plotdomain,'r-.')
scanITMX.horzpath.plotBeamWidth(plotdomain,'b--')
scanITMX.vertpath.plotBeamWidth(plotdomain,'b-.')
scanAS.horzpath.plotBeamWidth(plotdomain,'g--')
scanAS.vertpath.plotBeamWidth(plotdomain,'g-.')

legend('IY H','IY V','IX H','IY V','AS H','AS V','Location','E')
title('OMC REFL beamscan')
ylabel('Beam Width (m)')
xlabel('Beam Axis (m)')

hold off