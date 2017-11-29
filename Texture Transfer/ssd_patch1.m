function [patchssd] = ssd_patch1(tol,ssd,x1,y1,a1,b1)
%ssd = ssd;
mm = 0.5*(x1-1);
nn = 0.5*(y1-1);
ssd1 = ssd(mm+1:a1-mm,nn+1:b1-nn);
minc = min(min(ssd1));
if minc <= 0
    minc = 100;
   
end

[row,column] = find(ssd1<minc*(1+tol));


ii = size(row);
if ii(1)==1
    jj = ii;
end
if ii(1)>1
jj = round(rand(1,1)*ii(1));
if jj==0
    jj=1;
end
end
kk = row(jj);
ll = column(jj);


%patch = sample(kk:kk+x1-1,ll:ll+y1-1);
patchssd = ssd(kk:kk+x1-1,ll:ll+y1-1);

end