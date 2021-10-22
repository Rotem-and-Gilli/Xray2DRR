"""General-purpose training script for image-to-image translation.

This script works for various models (with option '--model': e.g., pix2pix, cyclegan, colorization) and
different datasets (with option '--dataset_mode': e.g., aligned, unaligned, single, colorization).
You need to specify the dataset ('--dataroot'), experiment name ('--name'), and model ('--model').

It first creates model, dataset, and visualizer given the option.
It then does standard network training. During the training, it also visualize/save the images, print/save the loss plot, and save models.
The script supports continue/resume training. Use '--continue_train' to resume your previous training.

Example:
    Train a CycleGAN model:
        python train.py --dataroot ./datasets/maps --name maps_cyclegan --model cycle_gan
    Train a pix2pix model:
        python train.py --dataroot ./datasets/facades --name facades_pix2pix --model pix2pix --direction BtoA

See options/base_options.py and options/train_options.py for more training options.
See training and test tips at: https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix/blob/master/docs/tips.md
See frequently asked questions at: https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix/blob/master/docs/qa.md
"""
import time
from options.train_options import TrainOptions
from data import create_dataset
from models import create_model
from util.visualizer import Visualizer
import util.util
import numpy as np
import shutil
from torch.utils.tensorboard import SummaryWriter

import matplotlib.pyplot as plt

import os
from help_rename import *

if __name__ == '__main__':

    x_epoch = []
    y_fid = []
    y_kid_mean = []
    y_kid_std = []
    y_is_mean = []
    y_is_std = []

    opt = TrainOptions().parse()   # get training options
    dir_tensorboard = './tensorboard/' + opt.name
    os.makedirs(dir_tensorboard, exist_ok=True)
    writer = SummaryWriter('./tensorboard/' + opt.name)
    dataset = create_dataset(opt)  # create a dataset given opt.dataset_mode and other options
    dataset_size = len(dataset)    # get the number of images in the dataset.
    print('The number of training images = %d' % dataset_size)

    model = create_model(opt)      # create a model given opt.model and other options
    model.setup(opt)               # regular setup: load and print networks; create schedulers
    visualizer = Visualizer(opt)   # create a visualizer that display/save images and plots
    total_iters = 0                # the total number of training iterations

    for epoch in range(opt.epoch_count, opt.n_epochs + opt.n_epochs_decay + 1):    # outer loop for different epochs; we save the model by <epoch_count>, <epoch_count>+<save_latest_freq>

        # Gilli & Rotem are having FUN
        if opt.model == 'cycle_gan':
            dir_img_train = f'./results/train_img_F/{epoch}'
            os.makedirs(dir_img_train, exist_ok=True)

        epoch_start_time = time.time()  # timer for entire epoch
        iter_data_time = time.time()    # timer for data loading per iteration
        epoch_iter = 0                  # the number of training iterations in current epoch, reset to 0 every epoch
        visualizer.reset()              # reset the visualizer: make sure it saves the results to HTML at least once every epoch
        model.update_learning_rate()    # update learning rates in the beginning of every epoch.
        for i, data in enumerate(dataset):  # inner loop within one epoch
            iter_start_time = time.time()  # timer for computation per iteration
            if total_iters % opt.print_freq == 0:
                t_data = iter_start_time - iter_data_time

            total_iters += opt.batch_size
            epoch_iter += opt.batch_size
            model.set_input(data)         # unpack data from dataset and apply preprocessing
            model.optimize_parameters()   # calculate loss functions, get gradients, update network weights

            if total_iters % opt.display_freq == 0:   # display images on visdom and save images to a HTML file
                save_result = total_iters % opt.update_html_freq == 0
                model.compute_visuals()
                visualizer.display_current_results(model.get_current_visuals(), epoch, save_result)

            if total_iters % opt.print_freq == 0:    # print training losses and save logging information to the disk
                losses = model.get_current_losses()
                t_comp = (time.time() - iter_start_time) / opt.batch_size
                visualizer.print_current_losses(epoch, epoch_iter, losses, t_comp, t_data)
                if opt.display_id > 0:
                    visualizer.plot_current_losses(epoch, float(epoch_iter) / dataset_size, losses)
                for item in losses:
                    writer.add_scalar(item, losses[item], total_iters)

            if total_iters % opt.save_latest_freq == 0:   # cache our latest model every <save_latest_freq> iterations
                print('saving the latest model (epoch %d, total_iters %d)' % (epoch, total_iters))
                save_suffix = 'iter_%d' % total_iters if opt.save_by_iter else 'latest'
                model.save_networks(save_suffix)

            iter_data_time = time.time()

            # Gilli & Rotem are having FUN
            # save images to the disk
            if opt.model == 'cycle_gan' and epoch_iter % 10 == 0:
                for label, image in model.get_current_visuals().items():
                    if label == 'fake_B':
                        image_numpy = util.util.tensor2im(image)
                        img_path = os.path.join(dir_img_train, 'epoch%.3d_iter%.4d_%s.png' % (epoch, epoch_iter, label))
                        util.util.save_image(image_numpy, img_path)

        # Gilli & Rotem are having FUN
        # Metric calcs
        if opt.model == 'cycle_gan':
            metric_dict = calculate_metrics(dir_img_train, './datasets/XR2DRR/trainB', cuda=True, isc=True, fid=True,
                                            kid=True, verbose=False, kid_subset_size=250)
            print(metric_dict)
            x_epoch.append(epoch)
            y_fid.append(metric_dict['frechet_inception_distance'])
            writer.add_scalar('fid', metric_dict['frechet_inception_distance'], epoch)
            y_kid_mean.append(metric_dict['kernel_inception_distance_mean'])
            writer.add_scalar('kid_mean', metric_dict['kernel_inception_distance_mean'], epoch)
            y_kid_std.append(metric_dict['kernel_inception_distance_std'])
            writer.add_scalar('kid_std', metric_dict['kernel_inception_distance_std'], epoch)
            y_is_std.append(metric_dict['inception_score_std'])
            writer.add_scalar('is_std', metric_dict['inception_score_std'], epoch)
            y_is_mean.append(metric_dict['inception_score_mean'])
            writer.add_scalar('is_mean', metric_dict['inception_score_mean'], epoch)
            shutil.rmtree(dir_img_train)


        if epoch % opt.save_epoch_freq == 0:              # cache our model every <save_epoch_freq> epochs
            print('saving the model at the end of epoch %d, iters %d' % (epoch, total_iters))
            model.save_networks('latest')
            model.save_networks(epoch)

        print('End of epoch %d / %d \t Time Taken: %d sec' % (epoch, opt.n_epochs + opt.n_epochs_decay, time.time() - epoch_start_time))

        # Gilli & Rotem are having FUN
        # Metric save
        if opt.model=='cycle_gan':
            x_epoch_np = np.array(x_epoch)
            y_fid_np = np.array(y_fid)
            y_kid_mean_np = np.array(y_kid_mean)
            y_kid_std_np = np.array(y_kid_std)
            y_is_mean_np = np.array(y_is_mean)
            y_is_std_np = np.array(y_is_std)
            np.savez('./results/CycleGANorig_metadata.npy', x_epoch_np, y_fid_np, y_kid_mean_np, y_kid_std_np, y_is_mean_np, y_is_std_np)

    writer.close()
