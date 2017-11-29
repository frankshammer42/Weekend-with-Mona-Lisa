%function [im] = quilt_random(sample,outsize,patchsize)
sample = imread('matrix_kanji.jpg');
imshow(sample);
outsize = [400,400];
patchsize= [33,33];

[a1,b1,c1] = size(sample);
patch_row = patchsize(1);
patch_col = patchsize(2);
out_row = outsize(1);
out_col = outsize(2);
%We Then start from the topleft and fill the image with patch_row and col
%step
for i = 1:patch_row:out_row-patch_row+1
    for j = 1:patch_col:out_col-patch_col+1
    %Make sure we don't go overbound
    a2 = round(rand(1,1)*(a1-patch_row-1))+1; 
    b2 = round(rand(1,1)*(b1-patch_col-1))+1;
    patch = sample(a2:a2+patch_row-1,b2:b2+patch_col-1,:);
    im(i:i+patch_row-1,j:j+patch_col-1,:) = patch;
    end
    %Fill the void zeros for the cols
    im(i:i+patch_row-1,j+patch_col:out_col,:) = 0;
    %end
end
%Fill the void for the rows
im(i+patch_row:out_row,1:out_col,:) = 0;
%end
figure, imshow(im)
imwrite(im, 'matrix_kanji_random.jpg')

    
