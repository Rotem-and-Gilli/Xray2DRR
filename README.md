# Image-to-image transfer between Xray and DRR

## Who are we?

Hello! We are Rotem and Gilli, students at the EE faculty of the Technion Israel Institute of Technology.
This is our final project in the CGM Technion Lab.

## Introduction

This project aims to succeed doing image-to-image translate between a veraiety of domains: Xray images, Digitally Reconstructed Radiograph (DRR), Bones Images and Lungs images. The DRR, bones and lung 2D images are created from a CT 3D imaging.

In this project, we invastigate the folowing image-to-image tansfers:

1. Xray --> DRR
2. DRR --> Xray
3. DRR --> Bones image
4. DRR --> Lungs image

We choosed using the cycleGAN and pix2pix models for this assigments. This code is mainly taken from theirs, with minor changes to the model architure.
You can find the cycleGAN and pix2pix code in the folowing link: https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix

## Dataset

We used the dataset of the DecGAN model. You can find the model and its dataset in here: https://github.com/ZerojumpLine/DecGAN

## Xray -> DRR

We tried 2 different models for this assiments:
1. CycleGAN model
2. CycleGAN+EAD model: To improve the previuse results, we changed Discrimnator B (our DRR descriminator) to Edge Aware Descriminator (EAD). If you want to activate it, add to your CycleGAN training the folowing parameter: `--discriminator_type new`.

Here is EAD architure:

<img src="./images/3.png" width="500">

We added 1 channel to the original descriminator input channels: 2D gray scale edge image of the original image, created using Differnce of Gaussian filter (DoG).
  
results:

<img src="./images/4.PNG" width="400">


## DRR -> Xray

We tried 2 different models for this assiments:
  1. CycleGAN model
  2. pix2pix model, on pairs of Xray and DRR images created with the CycleGAN+EAD model (Xray--> DRR direction).
  
1.
<img src="./images/7.png" width="300">

2.
<img src="./images/8.png" width="300">


## DRR -> Bones and DRR -> Lungs

We used pix2pix for these assiments.
  
results:

<img src="./images/9.PNG" width="500">

## Xray -> Bones and Xray -> Lungs

This assiment can be achived using a inbetween domain: the DRR image domain.

First, we usd the CycleGAN+EAD model to transfer from Xray domain to DRR domain. then, we used pix2pix to transfer from DRR domain to bones image domain or lungs image domain.

<img src="./images/5.png" width="500">


## Evaluate results codes
We used Matlab codes in order to make diff images for better understanding of our results. These codes can be found under the `visual_evaluation_code` folder.
In order to run the script `projectA_results_code`, you must [download](https://drive.google.com/drive/folders/1BtN4qs6c5QY8cKbbn0syeqhozMMR0fva?usp=sharing) a folder named `results`, containing images for display, and save it in the same directory as the codes. Besides the script `projectA_results_code`, the folder containes helper functions the script is using.

<img src="./images/6.PNG" width="500">

## Links to our organised folders

[our model's checkpoints](https://drive.google.com/drive/folders/1PSRrbg0OcSF3qIfkiapvns4LwdJ0xSOs?usp=sharing),
[our results](https://drive.google.com/drive/folders/1TnKYJ8oe-hJk1heF0PuzV_p5iUZiOmQC?usp=sharing),
[our data](https://drive.google.com/drive/folders/10YdnX1XX2C--PVAQo-iqZPlj-JH_R9ie?usp=sharing)


