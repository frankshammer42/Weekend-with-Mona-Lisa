%The thing different here is that we are using two images one source
%and one target to guide us synthesize the images

target = imread('MonaLisa.jpg');
source = imread('board1.jpg');

patchsize = [33,33];
overlap = 11;
tol = 0.08;
%Alpha will be used to control the weight of using source more or target
%more
alpha =0.5;
source1 = source;
filter1 = fspecial('gaussian',[7,7],1);
filtered_target = imfilter(target,filter1);

[a1,b1,c1] = size(source1);
patch_row = patchsize(1);
patch_col = patchsize(2);
[x2,y2,z3] = size(filtered_target);
piece = filtered_target(1:patch_row,1:patch_col,:);
mask = ones(patch_row,patch_col);
ssdR = ssd_patch(source1(:,:,1),mask,piece(:,:,1));
ssdG = ssd_patch(source1(:,:,2),mask,piece(:,:,2));
ssdB = ssd_patch(source1(:,:,3),mask,piece(:,:,3));
ssd = ssdR+ssdG+ssdB;
patch = choose_sample(tol,ssd,patch_row,patch_col,source,a1,b1);
%Just like what we did before, we first grab a piece from the topleft
%corner, we found the source that has the closes relation with the target
output(1:patch_row,1:patch_col,:) = patch(:,:,:);

i = 1;
for j = patch_col-overlap+1:patch_col-overlap:y2-patch_col
     %ssd2 will be used for matching the target
     mask = ones(patch_row,patch_col);
     template(:,:,:) = filtered_target(i:i+patch_row-1,j:j+patch_col-1,:);
     ssd2R = ssd_patch(source1(:,:,1),mask,template(:,:,1));
     ssd2G = ssd_patch(source1(:,:,2),mask,template(:,:,2));
     ssd2B = ssd_patch(source1(:,:,3),mask,template(:,:,3));
     ssd2 = ssd2R+ssd2G+ssd2B;
     
     %ssd1 will be used for matching the source
     mask(1:patch_row,1:overlap) = 1;
     mask(1:patch_row,overlap+1:patch_col) = 0;
     template(1:patch_row,1:overlap,:) = output(i:patch_row,j:j+overlap-1,:);
     template(1:patch_row,overlap+1:patch_col,:) = 0;
     ssd1R = ssd_patch(source1(:,:,1),mask,template(:,:,1));
     ssd1G = ssd_patch(source1(:,:,2),mask,template(:,:,2));
     ssd1B = ssd_patch(source1(:,:,3),mask,template(:,:,3));
     ssd1 = ssd1R+ssd1G+ssd1B;
     
     ssd = alpha*ssd1+(1-alpha)*ssd2;
     patch = choose_sample(tol,ssd,patch_row,patch_col,source,a1,b1);
     patchssd = ssd_patch1(tol,ssd,patch_row,patch_col,a1,b1);
     overlapssd = patchssd(1:patch_row,1:overlap);
     seammask = find_seam_vertical(overlapssd,patch_col);
     seammask1 = ones(patch_row,patch_col)-seammask;
     seammask = uint8(seammask);
     seammask1 = uint8(seammask1);
     patch(:,:,1) = patch(:,:,1).*seammask;
     patch(:,:,2) = patch(:,:,2).*seammask;
     patch(:,:,3) = patch(:,:,3).*seammask;
    
     template(1:patch_row,1:overlap,:) = output(i:i+patch_row-1,j:j+overlap-1,:);
     template(1:patch_row,overlap+1:patch_col,:) = 0;
     template(:,:,1) = template(:,:,1).*seammask1;
     template(:,:,2) = template(:,:,2).*seammask1;
     template(:,:,3) = template(:,:,3).*seammask1;
     output(i:i+patch_row-1,j:j+patch_col-1,:) = template(:,:,:)+patch(:,:,:);
     
end
for i = patch_row-overlap+1:patch_row-overlap:x2-patch_row
    for j = 1:patch_col-overlap:y2-patch_col
        if j == 1
            %Same with the cut, we are dealing with the first column of 
            %each rows
            mask = ones(patch_row,patch_col);
            template = filtered_target(i:i+patch_row-1,j:j+patch_col-1,:);
            ssd2R = ssd_patch(source1(:,:,1),mask,template(:,:,1));
            ssd2G = ssd_patch(source1(:,:,2),mask,template(:,:,2));
            ssd2B = ssd_patch(source1(:,:,3),mask,template(:,:,3));
            ssd2 = ssd2R+ssd2G+ssd2B;
            
            mask(1:overlap,1:patch_col) = 1;
            mask(overlap+1:patch_row,1:patch_col) = 0;
            template(1:overlap,1:patch_col,:) = output(i:i+overlap-1,j:j+patch_col-1,:);
            template(overlap+1:patch_row,1:patch_col,:) = 0;
            ssd1R = ssd_patch(source1(:,:,1),mask,template(:,:,1));
            ssd1G = ssd_patch(source1(:,:,2),mask,template(:,:,2));
            ssd1B = ssd_patch(source1(:,:,3),mask,template(:,:,3));
            ssd1 = ssd1R+ssd1G+ssd1B;     
            
            ssd = alpha*ssd1+(1-alpha)*ssd2;
            patch = choose_sample(tol,ssd,patch_row,patch_col,source,a1,b1);
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
            output(i:i+patch_row-1,j:j+patch_col-1,:) = template(:,:,:)+patch(:,:,:);
            
        end
        if j>1
            mask = ones(patch_row,patch_col);
            template = filtered_target(i:i+patch_row-1,j:j+patch_col-1,:);
            ssd2R = ssd_patch(source1(:,:,1),mask,template(:,:,1));
            ssd2G = ssd_patch(source1(:,:,2),mask,template(:,:,2));
            ssd2B = ssd_patch(source1(:,:,3),mask,template(:,:,3));
            ssd2 = ssd2R+ssd2G+ssd2B;
            
            mask(1:overlap,1:patch_col) = 1;
            mask(overlap+1:patch_row,1:overlap) = 1;
            mask(overlap+1:patch_row,overlap+1:patch_col) = 0;
            template(1:overlap,1:patch_col,:) = output(i:i+overlap-1,j:j+patch_col-1,:);
            template(overlap+1:patch_row,1:overlap,:) = output(i+overlap:i+patch_row-1,j:j+overlap-1,:);
            template(overlap+1:patch_row,overlap+1:patch_col,:) = 0;
            ssd1R = ssd_patch(source1(:,:,1),mask,template(:,:,1));
            ssd1G = ssd_patch(source1(:,:,2),mask,template(:,:,2));
            ssd1B = ssd_patch(source1(:,:,3),mask,template(:,:,3));
            ssd1 = ssd1R+ssd1G+ssd1B;
            
            ssd = alpha*ssd1+(1-alpha)*ssd2;
            patch = choose_sample(tol,ssd,patch_row,patch_col,source,a1,b1);
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
            output(i:i+patch_row-1,j:j+patch_col-1,:) = template(:,:,:)+patch(:,:,:);
           
        end
    end
end
imshow(output)
imwrite(output, 'mona_board.jpg')
