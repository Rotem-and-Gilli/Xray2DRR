% function params:
%   1. im1 = image from domain 1 corresponding to im2 in the other domain
%   2. im2 = image from domain 2 corresponding to im1 in the other domain
%   3. im1_name = the name of the domain im1 belongs to (module name / real)
%   4. im2_name = the name of the domain im2 belongs to (module name / real)
%   5. name = a name describing the two domains being compared
%
% return values:
%   None. it just prints:
%                       -- both of the original images (right column)
%                       -- the diff between the two images (middle column)
%                       -- the diff marked on im1 (top left column)
%                       -- the diff marked on im2 (bottom left column)
%
function []=create_diff_im(im1,im1_name,im2,im2_name,name,path_orig1,path_orig2,num_of_example)
    
    %normalizing the image relative to the std
    normalized_im1 = im1./std2(im1);
    normalized_im2 = im2./std2(im2);
% 	diff = normalized_im1-normalized_im2;
    diff_im1_mask = uint8((normalized_im1-normalized_im2)>0);
	diff_im2_mask = uint8((normalized_im2-normalized_im1)>0);
    diff_im1 = (normalized_im1-normalized_im2).*diff_im1_mask;
	diff_im2 = (normalized_im2-normalized_im1).*diff_im2_mask;
    
    %creating a greyscale image of each version
%     grey_diff = rgb2gray(diff);
    grey_diff_im1 = rgb2gray(diff_im1);
    grey_diff_im2 = rgb2gray(diff_im2);
    
    figure()
    %showing origin for both dimensions
    im_dom1 =imageDatastore(path_orig1);
    im_origin1 = imread(im_dom1.Files{num_of_example});
    im_dom2 =imageDatastore(path_orig2);
    im_origin2 = imread(im_dom2.Files{num_of_example});
    
    subplot(2,5,1);
    imshow(im_origin1,[]);
    %title('origin');
    title('1');
    
    subplot(2,5,6);
    imshow(im_origin2,[]);
    %title('origin');
    title('6');
    
    %showing diff on im1
    subplot(2,5,2);
    imshow(2*im1,[]);
    %title(im1_name);
    title('2');
    
    subplot(2,5,3);
    diff1 = zeros(size(im1));
    diff1(:,:,2) = grey_diff_im1;
    imshow(diff1,[]);
    %title(sprintf('diff+ from %s',im1_name));
    title('3');
    
    subplot(2,5,4);
    im1_w_diff = im1;
    %im1_w_diff(:,:,2) = 2*im1_w_diff(:,:,2) + 200*grey_diff_im1;
    im1_w_diff(:,:,1) = 1.7*im1_w_diff(:,:,1);
    im1_w_diff(:,:,2) = 1.7*im1_w_diff(:,:,2) + 200*grey_diff_im1;
    im1_w_diff(:,:,3) = 1.7*im1_w_diff(:,:,3);
    imshow(im1_w_diff,[]);
    %title(sprintf('diff+ on %s',im1_name));
    title('4');
    
    %showing diff on im2
    subplot(2,5,7);
    imshow(2*im2,[]);
    %title(im2_name);
    title('7');
    
    subplot(2,5,8);
    diff2 = zeros(size(im2));
    diff2(:,:,3) = grey_diff_im2;
    imshow(diff2,[]);
    %title(sprintf('diff+ from %s',im2_name));
    title('8');
    
    subplot(2,5,9);
    im2_w_diff = im2;
    %im2_w_diff(:,:,3) = 2*im2_w_diff(:,:,3) + 200*grey_diff_im2;
    im2_w_diff(:,:,1) = 1.7*im2_w_diff(:,:,1);
    im2_w_diff(:,:,2) = 1.7*im2_w_diff(:,:,2);
    im2_w_diff(:,:,3) = 1.7*im2_w_diff(:,:,3) + 200*grey_diff_im2;
    imshow(im2_w_diff,[]);
    %title(sprintf('diff+ on %s',im2_name));
    title('9');
    
    sgtitle(name);
    
    subplot(2,5,5);
    %in green - where cycGAN drew a bone but improve did not
    %in blue - where improved drew a bone but cycGAN did not
	im_w_diff = im1;
    im_w_diff(:,:,1) = 1.7*im_w_diff(:,:,1);
	im_w_diff(:,:,2) = 1.7*im_w_diff(:,:,2) + 200*grey_diff_im1;
    im_w_diff(:,:,3) = 1.7*im_w_diff(:,:,3) + 200*grey_diff_im2;
    imshow(im_w_diff,[]);
	%title(sprintf('diffs on %s - green(+) - blue(-)',im1_name));
    title('5');
    
    subplot(2,5,10);
    %in green - where cycGAN drew a bone but improve did not
    %in blue - where improved drew a bone but cycGAN did not
	im_w2_diff = im2;
    im_w2_diff(:,:,1) = 1.7*im_w2_diff(:,:,1);
	im_w2_diff(:,:,2) = 1.7*im_w2_diff(:,:,2) + 200*grey_diff_im1;
    im_w2_diff(:,:,3) = 1.7*im_w2_diff(:,:,3) + 200*grey_diff_im2;

    imshow(im_w2_diff,[]);
    %title(sprintf('diffs on %s - green(+) - blue(-)',im2_name));
    title('10');
end