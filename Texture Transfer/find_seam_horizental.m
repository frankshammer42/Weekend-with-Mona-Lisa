function [seammask]=find_seam_horizental(overlapssd2,x1)
a = size(overlapssd2);
x = a(1);
y = a(2);
E(:,1) = overlapssd2(:,1);
for j=2:1:y
    i = 1;
     E(i,j) = overlapssd2(i,j)+min(E(i,j-1),E(i+1,j-1));
     for i = 2:1:x-1
        l = min(E(i,j-1),E(i-1,j-1));
        E(i,j) = overlapssd2(i,j)+min(E(i+1,j-1),l);
     end
     i = x;
     E(i,j) = overlapssd2(i,j)+min(E(i-1,j-1),E(i,j-1));
end
column = y;
row = find(E(:,column)==min(E(:,column)));
num = size(row);
if num(1)>1
   row = row(1,1);
end

seammask(row:x1,column) = 1;

seammask(1:row-1,column) = 0;

for column = y-1:-1:1
    if row == 1
        row = find(E(:,column)==min(E(row,column),E(row+1,column)));
       
    end
    if row == x
        row = find(E(:,column)==min(E(row,column),E(row-1,column)));
        
    end
    if row>1&&row<x
    row = find(E(:,column)==min(E(row-1,column),min(E(row,column),E(row+1,column))));
      
   
    end
    num = size(row);
    if num(1)>1
    row = row(1,1);
    end
    seammask(row:x1,column) = 1;
    seammask(1:row-1,column) = 0;
    
end

     