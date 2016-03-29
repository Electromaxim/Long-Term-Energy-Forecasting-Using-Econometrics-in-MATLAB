function econ2 = dataprep2_econimicmonthly(ds,dE)
%
% David Willingham, MathWorks
% Copyright 2015 The MathWorks, Inc.
importeconomicnsw
dvec = [econdates(1):1:econdates(end)]';
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

[r,c] = size(econ);
econ2 = zeros(l,c);
for j = 1:c
    
    econ2(:,j) = interp1(econdates , econ(:,j),dmonthvec,'pchip');
end

dm = find(datenum(ds,'dd-mmm-yyyy') == dmonthvec);
dM = find(datenum(dE,'dd-mmm-yyyy') == dmonthvec);

econ2 = econ2(dm:dM,:);
dmonthvec = dmonthvec(dm:dM,:);
econ2 = array2table(econ2,'VariableNames',headers(2,:));
save econData econ2
% save econdata headers econ2 dmonthvec