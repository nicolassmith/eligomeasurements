%%% what is the contrast defect?
function getContrast
%% load
PDsum = load('20-PDsum.txt');
DARM = load('20-DARM.txt');
QPDsum = load('20-QPD3sum.txt');

% downsample PDsum

PDsum16 = [DARM(:,1),interp1(PDsum(:,1),PDsum(:,2),DARM(:,1))];

%% plots
% choose only PDsum < 2
figure(1)
plot(PDsum16(:,1),PDsum16(:,2))

DARM_DC_cal_strain = 1.0419515e+15;%cts/strain

DARM_DC_cal_m = DARM_DC_cal_strain / 3995; %cts/m

t = PDsum16(:,1);
PDsum16y = PDsum16(:,2);
DARMy = DARM(:,2)/DARM_DC_cal_m*1e12;

subset = PDsum16y < .4;

% plot this set

figure(2)
hold on
plot(DARMy(subset),PDsum16y(subset))

PDsumavg = 103.877;


[Xs,Ys] = separate(DARMy,PDsum16y,0.4);
[xmins,ymins] = getmins(Xs,Ys);

%figure(3)
plot(xmins,ymins,'r*')
plot(mean(xmins),mean(ymins),'g.','MarkerSize',50)
ylim([0 .4])
xlabel('DARM (pm)')
ylabel('OMC PD\_SUM (mA)')
legend('sweep data','minima','mean of minima','Location','SW')
hold off

disp(['At 8W input the CD is about ' num2str(mean(ymins)) 'mA'])
disp(['Scaled for 20W, and given the total DC current of ' num2str(PDsumavg) 'mA in lock,'])
disp(['the CD is ' num2str(mean(ymins)*20/8/PDsumavg*100) '%'])
end

function [Xs,Ys] = separate(Xin,Yin,upperlimit)
Ys = {};
Xs = {};

if length(Yin)~=length(Xin)
    error('shit length not same')
end


lastputtingflag = 0;

Xholder = [];
Yholder = [];

for kk = 1:length(Yin)
    if Yin(kk)<upperlimit
        Yholder = [Yholder,Yin(kk)]; %#ok
        Xholder = [Xholder,Xin(kk)]; %#ok
        lastputtingflag = 1;
    else
        if lastputtingflag
            Ys = [Ys,{Yholder}]; %#ok
            Xs = [Xs,{Xholder}]; %#ok
            Xholder = [];
            Yholder = [];
        end
        lastputtingflag = 0;
    end
end
    
    
end

function [xmins,ymins] = getmins(Xs,Ys)
    if length(Xs)~=length(Ys)
        error('what crap?')
    end
    
    ymins = zeros(length(Xs),1);
    xmins = ymins;
    
    
    for ll = 1:length(Ys)
        [ymins(ll),index] = min(Ys{ll});
        xmins(ll) = Xs{ll}(index);
        
    end

end