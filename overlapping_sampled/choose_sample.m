function [patch] = choose_sample(tol,ssd,patch_row,patch_col,sample,sample_row,sample_col)
patch_row_half = 0.5*(patch_row-1);
patch_col_half = 0.5*(patch_col-1);
ssd1 = ssd(patch_row_half+1:sample_row-patch_row_half,patch_col_half+1:sample_col-patch_col_half);
minc = min(min(ssd1));
if minc <= 0
    minc = 1000000;
end

[row_index,column_index] = find(ssd1<minc*(1+tol));

result_shape = size(row_index);

% If we only have one result d
 if result_shape(1)==1
     patch_location = result_shape(1);
 end


%If we have multiple results, we just randomly chose one
if result_shape(1)>1
    patch_location = round(rand(1,1)*result_shape(1));
    if patch_location==0
        patch_location=1;
    end
end

result_row = row_index(patch_location);
result_col = column_index(patch_location);
patch = sample(result_row:result_row+patch_row-1,result_col:result_col+patch_col-1,:);
end
