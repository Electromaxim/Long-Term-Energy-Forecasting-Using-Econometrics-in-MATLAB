function meantempmax = dataprep3_weather(ds,dE)
%
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.
importweather
count = 1;
dvecstr = [num2str(meantempmax1.Month),repmat(',',length(meantempmax1.Month),1),num2str(meantempmax1.Year)];
dvec = [datenum(dvecstr(1,:),'mm,yyyy'):1:datenum(dvecstr(end,:),'mm,yyyy')+31]';
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
meantempmax = meantempmax1(dm:dM,3:end);
save meantempmax meantempmax