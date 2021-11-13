function [im]=contrast_GR(im)
	max_im_R = max(im(:,:,1),[],'all');
    min_im_R = min(im(:,:,1),[],'all');
    
    max_im_G = max(im(:,:,2),[],'all');
    min_im_G = min(im(:,:,2),[],'all');
    
    max_im_B = max(im(:,:,3),[],'all');
    min_im_B = min(im(:,:,3),[],'all');
    
    im(:,:,1) = (im(:,:,1)-min_im_R)./(max_im_R-min_im_R);
    im(:,:,2) = (im(:,:,2)-min_im_G)./(max_im_G-min_im_G);
	im(:,:,3) = (im(:,:,3)-min_im_B)./(max_im_B-min_im_B);

end
