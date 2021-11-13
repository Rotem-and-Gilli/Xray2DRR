% function params:
%   1. path_domain1 = path to the folder containing images from 1st domain
%   2. path_domain2 = path to the folder containing images from 2nd domain
%   5. example_num = the serial number of image in the dataset we want to
%                    export
%
% return values:
%   1. im1 = image from domain 1 corresponding to im2 in the other domain
%   2. im2 = image from domain 2 corresponding to im1 in the other domain
%
function[im1,im2]=extract_image_example(path_domain1,path_domain2,example_num)

    %load paths to all domain 1 images
    im_dom1 = imageDatastore(path_domain1);
    %load paths to all domain 2 images
    im_dom2 = imageDatastore(path_domain2);

    %now showing the diff on an example image (example)
    im1 = imread(im_dom1.Files{example_num});
    im2 = imread(im_dom2.Files{example_num});
end
