# image-to-image transfer between Xray and DRR

## who we are?
Hello! We are Rotem and Gilly, students at the EE faculty of the Technion Israel Institute of Technology, and this is our final project.

## Introduction
This project aims to succeed doing image-to-image translate between a veraiety of domains: Xray images, Digitally Reconstructed Radiograph (DRR), Bones Images and Lungs images.
the DRR, bones and lung 2D images are created from a CT 3D imaging.
In this project, we invastigate the folowing image-to-image tansfers:
1. Xray --> DRR
2. DRR --> Xray
3. DRR --> Bones image
4. DRR --> Lungs image
We choosed using the cycleGAN and pix2pix models for this assigments. This code is mainly taken theirs, with some changes to the model architure.
Tou can find the cycleGAN and pix2pix code in the folowing link: https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix

## dataset
We used the dataset of the DecGAN model, which you can find documented here: https://github.com/ZerojumpLine/DecGAN

## Xray -> DRR
We tried 2 different models for this assiments:
1. CycleGAN model
2. CycleGAN+EAD model: To improve the previuse results, we changed Discrimnator B (our DRR descriminator) to Edge Aware Descriminator (EAD). If you want to activate it, add to your CycleGAN training the folowing parameter: `--discriminator_type new`.

Here is EAD architure:
<image goes here>
We added 1 channel to the original descriminator input channels: 2D gray scale edge image of the original image, created using Differnce of Gaussian filter (DoG).
  
results:
  <image goes here>

## DRR -> Xray
We tried 2 different models for this assiments:
  1. CycleGAN model
  2. pix2pix model, on pairs of Xray and DRR images created with the CycleGAN+EAD model (Xray--> DRR direction).
  
results:
<image goes here>
 
## DRR -> Bones and DRR -> Lungs
We used pix2pix for these assiments.
  
results:
  <image goes here>

## Xray -> Bones and Xray -> Lungs
This assiment can be achived using a inbetween domain: the DRR image domain.
  First, we usd the CycleGAN+EAD model to transfer from Xray domain to DRR domain. then, we used pix2pix to transfer from DRR domain to bones image domain or lungs image domain.
  <image of model goes here>

## Evaluate results codes
We used Matlab codes in order to make diff images for better understanding our results.
  Those code can be found under the matlab folder.
    
here are some examples:
    <image goes here>
