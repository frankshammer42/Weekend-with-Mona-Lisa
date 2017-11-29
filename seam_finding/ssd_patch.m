function [ssd] = ssd_patch(image,mask,template)

image = double(image);

template = double(template);
mask = double(mask);

ssd = imfilter(image.^2,mask)-2*imfilter(image,mask.*template)+sum(sum((mask.*template).^2));
end

