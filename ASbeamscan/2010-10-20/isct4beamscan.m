% beam scan fit for isct4 scan data (Oct 18 2010)

m_in = 0.0254; % meters per inch
m_um = 1e-6;

% distance from 0 on beamscan to output beamsplitter on HAM4

originshift = 4.5+7+16+5.4+11.2+23+55+36+42+11.2;

% first ITMY single bounce "trial 2"

scanITMY.pos = (0:9)+originshift; % 1 inch spaced measurements, 0 to 9 inches.

% scan data, A1 is horizontal. Units are um diameter beam width
scanITMY.A1  = [6843.2 6689.2 6546.2 6402.0 6226.8 6005.6 5792.5 5582.8...
                5406.8 5222.1];

scanITMY.A2  = [6237.0 6113.3 5921.8 5702.9 5513.5 5332.9 5154.6 4990.9...
                4816.4 4643.5];
            
% same for ITMX single bounce "trial 3"

scanITMX.pos = (0:9)+originshift;

% scan data
scanITMX.A1 = [6838.8 6706.0 6548.9 6398.7 6227.2 6020.6 5797.0 5591.3...
               5402.0 5220.8];

scanITMX.A2 = [6343.0 6181.8 6007.1 5827.7 5633.4 5410.9 5223.9 5047.1...
               4820.5 4648.2];
           
% finally, IFO AS port with DARM offset

scanAS.pos = (0:9)+originshift;

scanAS.A1 = [6767.2 6576.0 6386.3 6202.6 6020.0 5818.7 5645.7 5415.2...
             5246.7 5048.6];

scanAS.A2 = [6680.5 6589.4 6302.2 6138.0 5917.2 5708.9 5474.6 5304.6...
             5055.5 4868.2];
         

% We need a starting point to try to fit the beam to
initialPath = beamPath;
initialPath.seedWaist(.5e-3,6.3);%.8+originshift*m_in);
initialPath.addComponent(component.lens(1.1456,(-12+originshift)*m_in,'ISCT4 Lens'));




% now fit beam to data
scanITMY.horzpath = initialPath.fitBeamWidth(scanITMY.pos*m_in,scanITMY.A1*m_um/2);
scanITMY.vertpath = initialPath.fitBeamWidth(scanITMY.pos*m_in,scanITMY.A2*m_um/2);
scanITMX.horzpath = initialPath.fitBeamWidth(scanITMX.pos*m_in,scanITMX.A1*m_um/2);
scanITMX.vertpath = initialPath.fitBeamWidth(scanITMX.pos*m_in,scanITMX.A2*m_um/2);
scanAS.horzpath = initialPath.fitBeamWidth(scanAS.pos*m_in,scanAS.A1*m_um/2);
scanAS.vertpath = initialPath.fitBeamWidth(scanAS.pos*m_in,scanAS.A2*m_um/2);


% plots

plotdomain = -1:.01:7.5;

figure(757)
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

legend('IY H','IY V','IX H','IY V','AS H','AS V')
title('ISCT4 beamscan')
ylabel('Beam Width (m)')
xlabel('Beam Axis (m)')

hold off