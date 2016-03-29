function T = dataprep1_convert_monthly(ds,dE)
%
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.
import_load_price
DATES = NSW.SETTLEMENTDATE;
[Y,M,D,h,m] = datevec(DATES,'yyyy/mm/dd HH:MM');

Yu = unique(Y);
Mu = unique(M);
MonthlyMaxDemand = zeros(length(Yu),length(Mu));
MonthlyMaxPrice = zeros(length(Yu),length(Mu));
MonthlyMinDemand = zeros(length(Yu),length(Mu));
MonthlyMinPrice = zeros(length(Yu),length(Mu));
MonthlyAvgDemand = zeros(length(Yu),length(Mu));
MonthlyAvgPrice = zeros(length(Yu),length(Mu));
MonthlyTotalDemand = zeros(length(Yu),length(Mu));
for i = 1:length(Yu)
    for j = 1:length(Mu)
        I = (Y == Yu(i))&(M == Mu(j));
        temp = NSW(I,:);
        if ~isempty(temp)
            MonthlyMaxDemand(i,j) = max(temp.TOTALDEMAND);
            MonthlyMaxPrice(i,j) = max(temp.RRP);
            if min(temp.TOTALDEMAND) == 0
                ii = find(temp.TOTALDEMAND == 0);
                temp.TOTALDEMAND(ii) = temp.TOTALDEMAND(ii-1);
            end
            MonthlyMinDemand(i,j) = min(temp.TOTALDEMAND);
            MonthlyMinPrice(i,j) = min(temp.RRP);
            MonthlyAvgDemand(i,j) = mean(temp.TOTALDEMAND);
            MonthlyAvgPrice(i,j) = mean(temp.RRP);
            MonthlyTotalDemand(i,j) = sum(temp.TOTALDEMAND);
        end
    end
end



MonthlyMinDemand = MonthlyMinDemand';
MonthlyMinDemand = MonthlyMinDemand(:);
MonthlyMaxDemand = MonthlyMaxDemand';
MonthlyMaxDemand = MonthlyMaxDemand(:);
MonthlyAvgDemand = MonthlyAvgDemand';
MonthlyAvgDemand = MonthlyAvgDemand(:);
MonthlyTotalDemand = MonthlyTotalDemand';
MonthlyTotalDemand = MonthlyTotalDemand(:);
MonthlyAvgPrice = MonthlyAvgPrice';
MonthlyAvgPrice = MonthlyAvgPrice(:);
MonthlyMaxPrice = MonthlyMaxPrice';
MonthlyMaxPrice = MonthlyMaxPrice(:);
MonthlyMinPrice = MonthlyMinPrice';
MonthlyMinPrice = MonthlyMinPrice(:);
Months = repmat(Mu,length(Yu),1);
Years = [];
for k = 1:length(Yu)
    temp = repmat(Yu(k),length(Mu),1);
    Years = [Years;temp];
end
T = table(Years,Months,MonthlyMinDemand,MonthlyMaxDemand,...
    MonthlyAvgDemand,MonthlyTotalDemand,MonthlyAvgPrice,MonthlyMaxPrice,MonthlyMinPrice);

count = 1;
dvecstr = [num2str(T.Months),repmat(',',length(T.Months),1),num2str(T.Years)];
dvec = [datenum(dvecstr(1,:),'mm,yyyy'):1:datenum(dvecstr(end,:),'mm,yyyy')]';
% dmonthvec = datenum(dvec,'mm,yyyy');
[Y,M,D] = datevec(dvec);
Yu = unique(Y);
Mu = unique(M);
count = 1;
for i = 1:length(Yu)
    for j = 1:length(Mu)
        I = find((Y == Yu(i))&(M == Mu(j)));
        if ~isempty(I)
            dmonthvec(count,:) = dvec(I(end));
            count = count +1;
        end
        
    end
end
l = length(dmonthvec);


dm = find(datenum(ds,'dd-mmm-yyyy') == dmonthvec);
dM = find(datenum(dE,'dd-mmm-yyyy') == dmonthvec);
T = T(dm:dM,:);
save T T
