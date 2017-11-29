function [seammask]=find_seam_vertical(overlapssd,y1)
a = size(overlapssd);
x = a(1);
y = a(2);
E(1,:) = overlapssd(1,:);
for i=2:1:x
    j=1;
    E(i,j) = overlapssd(i,j)+min(E(i-1,j),E(i-1,j+1));
    for j = 2:1:y-1
        l = min(E(i-1,j-1),E(i-1,j));
        E(i,j) = overlapssd(i,j)+min(E(i-1,j+1),l);
    end
    j = y;
    E(i,j) = overlapssd(i,j)+min(E(i-1,j-1),E(i-1,j));
end
row = x;
column = find(E(row,:)==min(E(row,:)));
num = size(column);
if num>1
   column = column(1,1);
end
seammask(row,column:y1) = 1;
seammask(row,1:column-1) = 0;
%filter = fspecial('Gaussian',[4,4],0.5);
%seammask = imfilter(seammask,filter);
for row = x-1:-1:1
    if column == 1
        column = find(E(row,:)==min(E(row,column),E(row,column+1)));
    end
    if column == y
        column = find(E(row,:)==min(E(row,column),E(row,column-1)));
    end
    if (column>1) && (column<y)
    column = find(E(row,:)==min(E(row,column-1),min(E(row,column),E(row,column+1))));
    num = size(column);
    end
    if num>1
    column = column(1,1);
    end
    seammask(row,column:y1) = 1;
    seammask(row,1:column-1) = 0;
    
end

    
    

