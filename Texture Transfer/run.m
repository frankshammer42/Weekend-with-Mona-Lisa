%target = imread('Einstein1.jpg');
%source = imread('toast.png');
%output = texture_transfer(target,source,[15,15],5,0.4,0.7);
%figure;
%imshow(output);
%background = imread('toast_whole.jpg');
%figure;
%imshow(output);
output =  imread('result3.jpg');
background = imread('toast_whole.jpg');
[output1,background1] = align_images(output,background);
[a1,b1,c1] = size(output1);
mask1(1:a1,1:b1) = 0;
mask1(69:180,32:171) = 1;

mask2 = ones(a1,b1)-mask1;
filter = 1/9*[1 1 1;1 1 1;1 1 1];
mask1 = uint8(mask1);
mask2 = uint8(mask2);
mask1 = imfilter(mask1,filter);
mask2 = imfilter(mask2,filter);

output1(:,:,1) = output1(:,:,1).*mask1;
output1(:,:,2) = output1(:,:,2).*mask1;
output1(:,:,3) = output1(:,:,3).*mask1;
background1(:,:,1) = background1(:,:,1).*mask2;
background1(:,:,2) = background1(:,:,2).*mask2;
background1(:,:,3) = background1(:,:,3).*mask2;
output = output1+background1;
figure,
imshow(output)

