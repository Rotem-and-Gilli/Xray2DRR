% function params:
%   1. name = a name describing the two domains being compared
%   2. path_domain1 = path to the folder containing images from 1st domain
%   3. path_domain2 = path to the folder containing images from 2nd domain
%   4. num_of_images = the number of images in the dataset
%                      (should be identical in both domains)
%
% return values:
%   1. im1 = image from domain 1 corresponding to im2 in the other domain
%   2. im2 = image from domain 2 corresponding to im1 in the other domain
%
function calc_overall_diff_results(name,path_domain1,path_domain2,num_of_images)
    
    %var declarations
    im_domain1 = {};
    im_domain2 = {};
    diff = {};

    %load paths to all domain 1 images
    im_dom1 = imageDatastore(path_domain1);
    %oad paths to all domain 2 images
    im_dom2 = imageDatastore(path_domain2);

    %normalizing the images by deducting the mean of the image
    for i=1:num_of_images
         im_domain11{i} = imread(im_dom1.Files{i})./std2(imread(im_dom1.Files{i}));
         im_domain21{i} = imread(im_dom2.Files{i})./std2(imread(im_dom2.Files{i}));
         im_domain12{i} = imread(im_dom1.Files{i})./mean(imread(im_dom1.Files{i}),'all');
         im_domain22{i} = imread(im_dom2.Files{i})./mean(imread(im_dom2.Files{i}),'all');

        %creating a vec of the diff images named res
        diff1{i} = abs(im_domain11{i}-im_domain21{i}).*10;
        diff2{i} = abs(im_domain12{i}-im_domain22{i}).*10;

%         diff_domain1{i} = ((im_domain1{i}-im_domain2{i})>0).*10;
%         diff_domain2{i} = ((im_domain2{i}-im_domain1{i})>0).*10;       
    end
    
    %std
    %summing all the diff images and normalizing by num of images
    %to get mean diff image
    std_diff_image = diff1{1};
    mean_diff_image = diff2{1};
    if (num_of_images>1)
        figure()
        for a=2:num_of_images
            std_diff_image = std_diff_image + diff1{a};
            mean_diff_image = mean_diff_image + diff2{a};
        end
        std_diff_image = std_diff_image./ num_of_images;
        mean_diff_image = mean_diff_image./ num_of_images;

        subplot(1,2,1);
        imshow(rgb2gray(std_diff_image),[]); title('1');
        subplot(1,2,2);
        imshow(rgb2gray(mean_diff_image),[]); title('2');
        sgtitle(name);

    end
end