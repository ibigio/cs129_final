function out = generate_fill_texture(image, marker)

transform = get_marker_homography(image,marker);

mask = zeros(size(image));  
one = ones(size(marker));
comp = logical(composite_images(mask, one, transform.T));
totalArea = bwarea(comp(:,:,1));
halfWindowWidth = floor(1.3*sqrt(totalArea)/2);
stats = regionprops(comp(:,:,1),'centroid');

 center= stats.Centroid;
 centerX = center(1);
 centerY = center(2);
 
 rect = [centerX-halfWindowWidth, centerY-halfWindowWidth, halfWindowWidth*2, halfWindowWidth*2];
 
 cutout = imcrop(image, rect);
 
 figure(111)
 imshow(cutout);

output_size = [size(marker,1) size(marker,2)];
tilesize = round(size(marker,1) / 6);
overlap_size = round(tilesize / 6);
border_size = round(tilesize * 1.5);

out = image_synthesis( cutout, output_size, tilesize, overlap_size, 3, 0, border_size);

end

