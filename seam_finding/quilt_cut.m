clear all
%function [output]=quilt_cut(sample,outsize,patchsize,overlap,tol)
sample = imread('autumn.jpg');


%Just like what we did in overlapping patch, we fill the top left corner
outsize = [400,400];
patchsize = [33,33];
overlap = 11;
tol = 0.01;
[a1,b1,c1] = size(sample);
patch_row = patchsize(1);
patch_col = patchsize(2);
a2 = round(rand(1,1)*(a1-patch_row-1))+1; 
out_row = outsize(1);
out_col = outsize(2);
b2 = round(rand(1,1)*(b1-patch_col-1))+1;
patch = sample(a2:a2+patch_row-1,b2:b2+patch_col-1,:);

% figure('Name', 'first_patch'), imshow(patch);

output(1:patch_row,1:patch_col,:) = patch;

i = 1;
for j = patch_col-overlap+1:patch_col-overlap:out_col-patch_col+1
     %We build the first row first 
     %This part has the same structure with overlapping
     mask(1:patch_row,1:overlap) = 1;
     mask(1:patch_row,overlap+1:patch_col) = 0;
     template(1:patch_row,1:overlap,:) = output(i:patch_row,j:j+overlap-1,:);
     template(1:patch_row,overlap+1:patch_col,:) = 0;
     ssd1 = ssd_patch(sample(:,:,1),mask,template(:,:,1));
     ssd2 = ssd_patch(sample(:,:,2),mask,template(:,:,2));
     ssd3 = ssd_patch(sample(:,:,3),mask,template(:,:,3));
     ssd = ssd1+ssd2+ssd3;
     patch = choose_sample(tol,ssd,patch_row,patch_col,sample,a1,b1);
    
     
     patchssd = ssd_patch1(tol,ssd,patch_row,patch_col,a1,b1);
     overlapssd = patchssd(1:patch_row,1:overlap);
    
     
     seammask = find_seam_vertical(overlapssd,patch_col);
     seammask1 = ones(patch_row,patch_col)-seammask;
     seammask = uint8(seammask);
     seammask1 = uint8(seammask1);
     
%       if j == patch_col-overlap+1
%          figure('Name', 'second_patch'), imshow(patch);
%          figure, imagesc(overlapssd);
%          path_figure = zeros(patch_row, patch_col);
%          disp(size(overlapssd));
%          disp(size(path_figure));
%          x = [];
%          y = [];
%          for ii=1:patch_row
%              for jj = 1:patch_col
%                   if seammask(ii,jj) == 1
%                       path_figure(ii,jj) = 1;
%                       x = [x jj];
%                       y = [y ii];
%                       break;
%                   end         
%              end
%          end
%          
%          disp(seammask)
%          hold on
%          plot(x,y, 'LineWidth',5);
%          hold off
%       end
     
     
     patch(:,:,1) = patch(:,:,1).*seammask;
     patch(:,:,2) = patch(:,:,2).*seammask;
     patch(:,:,3) = patch(:,:,3).*seammask;
    
     template(1:patch_row,1:overlap,:) = output(i:i+patch_row-1,j:j+overlap-1,:);
     template(1:patch_row,overlap+1:patch_col,:) = 0;
    
     template(:,:,1) = template(:,:,1).*seammask1;
     template(:,:,2) = template(:,:,2).*seammask1;
     template(:,:,3) = template(:,:,3).*seammask1;
     output(i:i+patch_row-1,j:j+patch_col-1,:) = template+patch;
     
     
end
for i = patch_row-overlap+1:patch_row-overlap:out_row-patch_row+1
    for j = 1:patch_col-overlap:out_col-patch_col
        if j == 1
            mask(1:overlap,1:patch_col) = 1;
            mask(overlap+1:patch_row,1:patch_col) = 0;
            template(1:overlap,1:patch_col,:) = output(i:i+overlap-1,j:j+patch_col-1,:);
            template(overlap+1:patch_row,1:patch_col,:) = 0;
          
            ssd1 = ssd_patch(sample(:,:,1),mask,template(:,:,1));
            ssd2 = ssd_patch(sample(:,:,2),mask,template(:,:,2));
            ssd3 = ssd_patch(sample(:,:,3),mask,template(:,:,3));
            ssd = ssd1+ssd2+ssd3;
            patch = choose_sample(tol,ssd,patch_row,patch_col,sample,a1,b1);
            
            patchssd = ssd_patch1(tol,ssd,patch_row,patch_col,a1,b1);
            overlapssd = patchssd(1:overlap,1:patch_col);
            seammask = find_seam_horizental(overlapssd,patch_row);
            seammask1 = ones(patch_row,patch_col)-seammask;
            
            seammask = uint8(seammask);
            seammask1 = uint8(seammask1);
            
            patch(:,:,1) = patch(:,:,1).*seammask;
            patch(:,:,2) = patch(:,:,2).*seammask;
            patch(:,:,3) = patch(:,:,3).*seammask;
            template(:,:,1) = template(:,:,1).*seammask1;
            template(:,:,2) = template(:,:,2).*seammask1;
            template(:,:,3) = template(:,:,3).*seammask1;
            output(i:i+patch_row-1,j:j+patch_col-1,:) = template+patch;
           
        end
        if j>1
            mask(1:overlap,1:patch_col) = 1;
            mask(overlap+1:patch_row,1:overlap) = 1;
            mask(overlap+1:patch_row,overlap+1:patch_col) = 0;
            template(1:overlap,1:patch_col,:) = output(i:i+overlap-1,j:j+patch_col-1,:);
            template(overlap+1:patch_row,1:overlap,:) = output(i+overlap:i+patch_row-1,j:j+overlap-1,:);
            template(overlap+1:patch_row,overlap+1:patch_col,:) = 0;
        
            ssd1 = ssd_patch(sample(:,:,1),mask,template(:,:,1));
            ssd2 = ssd_patch(sample(:,:,2),mask,template(:,:,2));
            ssd3 = ssd_patch(sample(:,:,3),mask,template(:,:,3));
            ssd = ssd1+ssd2+ssd3;
            
            patch = choose_sample(tol,ssd,patch_row,patch_col,sample,a1,b1);
            patchssd = ssd_patch1(tol,ssd,patch_row,patch_col,a1,b1);
            overlapssd1 = patchssd(1:patch_row,1:overlap);
            overlapssd2 = patchssd(1:overlap,1:patch_col);
            seammask1 = find_seam_vertical(overlapssd1,patch_col);
            seammask2 = find_seam_horizental(overlapssd2,patch_row);
            seammask1 = ones(patch_row,patch_col)-seammask1;
            seammask2 = ones(patch_row,patch_col)-seammask2;
            seammask1 = seammask1+seammask2;
            seammask1(1:overlap,1:overlap) = 1;
            
            seammask = ones(patch_row,patch_col)-seammask1;
            seammask = uint8(seammask);
            seammask1 = uint8(seammask1);
            
          
            patch(:,:,1) = patch(:,:,1).*seammask;
            patch(:,:,2) = patch(:,:,2).*seammask;
            patch(:,:,3) = patch(:,:,3).*seammask;
            
            template(:,:,1) = template(:,:,1).*seammask1;
            template(:,:,2) = template(:,:,2).*seammask1;
            template(:,:,3) = template(:,:,3).*seammask1;
            output(i:i+patch_row-1,j:j+patch_col-1,:) = template+patch;
          
        end
    end
end
if i<out_row-patch_row+1
    output(i+patch_row:out_row,:,:) = 0;
end
if j<out_col-patch_col+1
    output(:,j+patch_col:out_col,:) = 0;
end
imshow(output)
imwrite(output, 'autumn_cut.jpg')