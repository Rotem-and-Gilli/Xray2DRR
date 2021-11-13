close all;
clear;
clc;

%% comparing a DRR made by cycGAN to a DRR made by the improved cycGAN
%page 11

name = 'comparing a DRR made by cycGAN to a DRR made by cycGAN + EAD';

% individual examples
% chosen examples 4,5,7,9
for i=[4,5,7,9]
    path_cycGAN_DRR_ex = '.\results\for_code\cycGAN_DRR_examples\'+string(i);
    path_improved_cycGAN_DRR_ex = '.\results\for_code\cycGAN_EAD_DRR_examples\'+string(i);
    path_original_xray_ex = '.\results\for_code\real_XR_examples\'+string(i);
    
    % on these paths there is a dir for each example, so example_num=1
    [im_cycGAN,im_improved_cycGAN]=extract_image_example(path_cycGAN_DRR_ex,path_improved_cycGAN_DRR_ex,1);
    create_diff_im(0.5*im_cycGAN,'cycGAN',0.5*im_improved_cycGAN,'improved cycGAN',name,path_original_xray_ex,path_original_xray_ex,1);
end

% overall diff
path_cycGAN_DRR_overall = '.\results\for_code\cycGAN_DRR';
path_improved_cycGAN_DRR_overall = '.\results\for_code\cycGAN_EAD_DRR';
calc_overall_diff_results(name,path_cycGAN_DRR_overall,path_improved_cycGAN_DRR_overall,10);

%% comparing an XRAY made by pix2pix to a real XRAY
% page 15
name = 'comparing an XRAY made by pix2pix to a real XRAY';

% individual examples
% chosen examples 4,6
for i=[4,6]
    path_real_XR_ex = '.\results\for_code\real_XR_examples\'+string(i);
    path_pix2pix_XR_ex = '.\results\for_code\p2p_XR_examples\'+string(i);
    path_pix2pix_drr_ex = '.\results\for_code\cycGAN_EAD_DRR_examples\'+string(i);
    
    % on these paths there is a dir for each example, so example_num=1
    [im_real,im_pix2pix]=extract_image_example(path_real_XR_ex,path_pix2pix_XR_ex,1);
    %gamma correction
    im_pix2pix = im2double(im_pix2pix);
    im_pix2pix = im_pix2pix.^(1.65);
    
    %contrast
    im_real = im2double(im_real);
    im_pix2pix = contrast_GR(im_pix2pix);
    im_real = contrast_GR(im_real);
    
    im_pix2pix = im2uint8(im_pix2pix);
    im_real = im2uint8(im_real);

    create_diff_im(0.5*im_real,'real XRAY',0.5*im_pix2pix,'pix2pix XRAY',name,path_pix2pix_drr_ex,path_pix2pix_drr_ex,1);
end

% overall diff
path_real_XR = '.\results\for_code\real_XR';
path_pix2pix_XR = '.\results\for_code\p2p_XR'; 
calc_overall_diff_results(name,path_real_XR,path_pix2pix_XR,10);

%% comparing an XRAY made by pix2pix to an XRAY made by cycleGAN
% page 16

name = 'comparing an XRAY made by pix2pix to an XRAY made by cycleGAN';

% individual examples
% chosen examples A,B,C,D
for i=1:4
    path_XR_cycleGAN = '.\results\for_code\cycGAN_XR_examples\'+string(i);
    path_XR_pix2pix = '.\results\for_code\p2p_XR_c_cycGAN\'+string(i);
    path_real_drr = '.\results\for_code\real_DRR4XR_examples\'+string(i);
    
    % on these paths there is a dir for each example, so example_num=1
    [im_cyc,im_p2p]=extract_image_example(path_XR_cycleGAN,path_XR_pix2pix,1);
    
    %contrast
    im_p2p = im2double(im_p2p);
    im_cyc = im2double(im_cyc);
    
    im_p2p = im_p2p.^(1.65);
    im_cyc = im_cyc.^(1.65);

    im_p2p = contrast_GR(im_p2p);
    im_cyc = contrast_GR(im_cyc);
    
    im_p2p = im2uint8(im_p2p);
    im_cyc = im2uint8(im_cyc);
    
    % on these paths there is a dir for each example, so example_num=1
    create_diff_im(0.5*im_cyc,'Xray cycleGAN',0.5*im_p2p,'Xray - pix2pix',name,path_real_drr,path_real_drr,1);
end

%% comparing real bones extracted from CT to bones extracted from DRR using pix2pix
name = 'comparing real bones extracted from CT to bones extracted from DRR using pix2pix';

path_real_bones_DRR = '.\results\for_code\real_bones';
path_pix2pix_bones_DRR = '.\results\for_code\p2p_bones';
path_real_DRR = '.\results\for_code\real_DRR_p2p';
% individual examples
% chosen examples 23,28
for i=[23,28]
    [im1,im2]=extract_image_example(path_real_bones_DRR,path_pix2pix_bones_DRR,i);
    create_diff_im(im1,'real',im2,'pix2pix',name,path_real_DRR,path_real_DRR,i);
end

% overall diff
calc_overall_diff_results(name,path_real_bones_DRR,path_pix2pix_bones_DRR,50);

%% comparing real lungs extracted from CT to lungs extracted from DRR using pix2pix
% page 22

name = 'comparing real lungs extracted from CT to lungs extracted from DRR using pix2pix';

path_real_lungs_DRR = '.\results\for_code\real_lungs';
path_pix2pix_lungs_DRR = '.\results\for_code\p2p_lungs';
path_real_DRR = '.\results\for_code\real_DRR_p2p';
% individual examples
% chosen examples 23,28
for i=[23,28]
    [im1,im2]=extract_image_example(path_real_lungs_DRR,path_pix2pix_lungs_DRR,i);
    create_diff_im(10*im1,'real',10*im2,'pix2pix',name,path_real_DRR,path_real_DRR,i);
end

% overall diff
calc_overall_diff_results(name,path_real_lungs_DRR,path_pix2pix_lungs_DRR,50);

%% comparing bones extracted from a DRR made by cycGAN to bones extracted from a DRR made by the cycGAN + EAD
% page 24

name = 'comparing bones based on cycGAN to bones based on cycGAN + EAD';

% individual examples
% chosen examples 4,5,7,9
for i=[4,5,7,9]
    path_cycGAN_bones_DRR = '.\results\for_code\cycGAN_bones_examples\'+string(i);
    path_improved_cycGAN_bones_DRR = '.\results\for_code\cycGAN_EAD_bones_examples\'+string(i);
    path_cycGAN_DRR = '.\results\for_code\cycGAN_DRR_examples\'+string(i);
    path_improved_cycGAN_DRR = '.\results\for_code\cycGAN_EAD_DRR_examples\'+string(i);
    
    % on these paths there is a dir for each example, so example_num=1    
    [im1,im2]=extract_image_example(path_cycGAN_bones_DRR,path_improved_cycGAN_bones_DRR,1);
    create_diff_im(im1,'cycGAN',im2,'cycGAN + EAD',name,path_cycGAN_DRR,path_improved_cycGAN_DRR,1);

end

path_cycGAN_bones_DRR_overall = '.\results\for_code\cycGAN_bones';
path_improved_cycGAN_bones_DRR_overall = '.\results\for_code\cycGAN_EAD_bones';

% overall diff
calc_overall_diff_results(name,path_cycGAN_bones_DRR_overall,path_improved_cycGAN_bones_DRR_overall,10);

%% comparing lungs extracted from a DRR made by cycGAN to lungs extracted from a DRR made by cycGAN + EAD
% page 26

name = 'comparing lungs based on cycGAN to lungs based on cycGAN + EAD';

% individual examples
% chosen examples 4,5,7,9
for i=[4,5,7,9]
    path_cycGAN_lungs_DRR = '.\results\for_code\cycGAN_lungs_examples\'+string(i);
    path_improved_cycGAN_lungs_DRR = '.\results\for_code\cycGAN_EAD_lungs_examples\'+string(i);
    path_cycGAN_DRR = '.\results\for_code\cycGAN_DRR_examples\'+string(i);
    path_improved_cycGAN_DRR = '.\results\for_code\cycGAN_EAD_DRR_examples\'+string(i);
    
    % on these paths there is a dir for each example, so example_num=1    
    [im1,im2]=extract_image_example(path_cycGAN_lungs_DRR,path_improved_cycGAN_lungs_DRR,1);
    create_diff_im(10*im1,'cycGAN',10*im2,'cycGAN + EAD',name,path_cycGAN_DRR,path_improved_cycGAN_DRR,1);

end

path_cycGAN_lungs_DRR_overall = '.\results\for_code\cycGAN_lungs';
path_improved_cycGAN_lungs_DRR_overall = '.\results\for_code\cycGAN_EAD_lungs';
% overall diff
calc_overall_diff_results(name,path_cycGAN_lungs_DRR_overall,path_improved_cycGAN_lungs_DRR_overall,10);

