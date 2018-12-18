function [out] = edit_frame(frame,marker, texture)

disp('Getting marker homography...')

transform = get_marker_homography(frame, marker);
T = transform.T;

disp('Compositing...')

out = composite_images(frame, texture, T);
end

