%function [output] = quilt_simple(sample,outsize,patchsize,overlap,tol)
clear all;
sample = imread('circuit.jpg');

outsize = [400,400];
patchsize = [33,33];
overlap = 10;
tol = 0.01;
[a1,b1,c1] = size(sample);
patch_row = patchsize(1);
patch_col = patchsize(2);
first_x = round(rand(1,1)*(a1-patch_row-1))+1; 
out_row = outsize(1);
out_col = outsize(2);
first_y = round(rand(1,1)*(b1-patch_col-1))+1;
%We frist get the top left corner of the image
patch = sample(first_x:first_x+patch_row-1,first_y:first_y+patch_col-1,:);
output(1:patch_row,1:patch_col,:) = patch;

%This loop is for building up the first row of the images
i = 1;
for j = patch_col-overlap+1:patch_col-overlap:out_col-patch_col+1
     %The only thing we cared about right now is the right overlapping area
     template(1:patch_row,1:overlap,1) = output(i:patch_row,j:j+overlap-1,1);
     template(1:patch_row,overlap+1:patch_col,1) = 0;
     template(1:patch_row,1:overlap,2) = output(i:patch_row,j:j+overlap-1,2);
     template(1:patch_row,overlap+1:patch_col,2) = 0;
     template(1:patch_row,1:overlap,3) = output(i:patch_row,j:j+overlap-1,3);
     template(1:patch_row,overlap+1:patch_col,3) = 0;
     mask(1:patch_row,1:overlap) = 1;
     mask(1:patch_row,overlap+1:patch_col) = 0;
     ssd1 = ssd_patch(sample(:,:,1),mask,template(:,:,1));
     ssd2 = ssd_patch(sample(:,:,2),mask,template(:,:,2));
     ssd3 = ssd_patch(sample(:,:,3),mask,template(:,:,3));
     ssd = ssd1+ssd2+ssd3;
     patch = choose_sample(tol,ssd,patch_row,patch_col,sample,a1,b1);
     output(i:i+patch_row-1,j:j+patch_col-1,:) = patch;
end

for i = patch_row-overlap+1:patch_row-overlap:out_row-patch_row+1
    for j = 1:patch_col-overlap:out_col-patch_col+1
        if j == 1
            %If we are at the start of the column, with row number bigger 
            %than 1, we just care about the top overlapping patch
            template(1:overlap,1:patch_col,:) = output(i:i+overlap-1,j:j+patch_col-1,:);
            template(overlap+1:patch_row,1:patch_col,:) = 0;
            mask(1:overlap,1:patch_col) = 1;
            mask(overlap+1:patch_row,1:patch_col) = 0;
        end
        if j>1
            %Otherwise, we have to consider both top and left overlapping
            template(1:overlap,1:patch_col,:) = output(i:i+overlap-1,j:j+patch_col-1,:);
            template(overlap+1:patch_row,1:overlap,:) = output(i+overlap:i+patch_row-1,j:j+overlap-1,:);
            template(overlap+1:patch_row,overlap+1:patch_col,:) = 0;
            mask(1:overlap,1:patch_col) = 1;
            mask(overlap+1:patch_row,1:overlap) = 1;
            mask(overlap+1:patch_row,overlap+1:patch_col) = 0;
        end
        ssd1 = ssd_patch(sample(:,:,1),mask,template(:,:,1));
        ssd2 = ssd_patch(sample(:,:,2),mask,template(:,:,2));
        ssd3 = ssd_patch(sample(:,:,3),mask,template(:,:,3));
        ssd = ssd1+ssd2+ssd3;
        patch = choose_sample(tol,ssd,patch_row,patch_col,sample,a1,b1);
        output(i:i+patch_row-1,j:j+patch_col-1,:) = patch;
    end
end
if i<out_row-patch_row+1
    output(i+patch_row:out_row,:,:) = 0;
end
if j<out_col-patch_col+1
    output(:,j+patch_col:out_col,:) = 0;
end

imshow(output)
imwrite(output, 'circuit_overlapping.jpg')