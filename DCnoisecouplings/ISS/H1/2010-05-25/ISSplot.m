% make ISS plots.

load('../../DARMcalib.mat')
%DARMcalib = tfinv(DARMcalib);

filenames = {'20pm8W.txt','15pm8W.txt'};
offsets =   { 20,          15};

num = length(filenames);

clear datas
datas(num) = struct;

for jj = 1:num
    loaded = load(filenames{jj});
    datas(jj).f = loaded(:,1);
    datas(jj).TF = loaded(:,2)+1i*loaded(:,3);
    datas(jj).offset = offsets{jj};
end

TF20pm = [datas(1).f,datas(1).TF];

TF20pmcal = calTF(TF20pm,DARMcalib);

TF15pm = [datas(2).f,datas(2).TF];

TF15pmcal = calTF(TF15pm,DARMcalib);

figure(332)
SRSbode(TF20pmcal,TF15pmcal)

% figure(333)
% SRSbode(TF20pm,TF15pm)