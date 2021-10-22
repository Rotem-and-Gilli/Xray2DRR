import os
from torch_fidelity import calculate_metrics
from shutil import copyfile

def rename():
    #drrPath = 'datasets/DRRBONES/A/train'
    #bonePath = 'datasets/DRRBONES/B/train'
    #lungPath = 'datasets/DRRLUNGS/B/val'
    drrPath_pix = 'datasets/DRR2XR_pix2pix/B/train'
    #drrFiles = os.listdir(drrPath)
    #boneFiles = os.listdir(bonePath)
    drrFiles = os.listdir(drrPath_pix)

    #for file in drrFiles:
    #    os.rename(drrPath + '/' + file, drrPath + '/' + file[:-6] + '.png')

    #for file in boneFiles:
    #    os.rename(bonePath + '/' + file, bonePath + '/' + file[:-6] + '.png')

    #for file in lungFiles:
    #    os.rename(lungPath + '/' + file, lungPath + '/' + file[:-6] + '.png')

    for file in drrFiles:
        os.rename(drrPath_pix + '/' + file, drrPath_pix + '/' + file[:-11] + '.png')

def move_files():
    dir_s = './checkpoints/XR2DRR_cyclegan/web/images/'
    dir_d = './results/real_drr_train/'
    file_list = os.listdir(dir_s)
    for file in file_list:
        if 'real_B' in file:
            copyfile(dir_s+file, dir_d+file)


def get_metric_dists(dir1, dir2):
    metric_dict = calculate_metrics(dir1, dir2, cuda=True, isc=True, fid=True, kid=True, verbose=False,
                                    kid_subset_size=200)
    print(metric_dict)

def calc_kid_fid(dir1, dir2):
    metric_dict = calculate_metrics(dir1, dir2, cuda=True, isc=False, fid=True, kid=True, verbose=False,
                                    kid_subset_size=100)
    fid = metric_dict['frechet_inception_distance']
    kid_mean = metric_dict['kernel_inception_distance_mean']
    kid_std = metric_dict['kernel_inception_distance_std']
    return fid, kid_mean, kid_std

def remove_unwanted_files(path, sintax):
    files = os.listdir(path)
    files_to_remove = [f for f in files if sintax not in f]
    for f in files_to_remove:
        os.remove(path+'/'+f)

def help_pix2pix():
    my_path = '/home/rotemgilli/Desktop/pytorch-CycleGAN-and-pix2pix/results/XR2DRR_F_cyclegan_4pix2pix/'
    end_s = 'all'
    end_s2 = 'all/'
    end_a = 'A/'
    end_b = 'B/'
    files = os.listdir(my_path+end_s)
    a_files = [f for f in files if 'fake_A' in f]
    b_files = [f for f in files if 'real_B' in f]
    for file in a_files:
        copyfile(my_path+end_s2+file, my_path+end_a+file)
    for file in b_files:
        copyfile(my_path+end_s2+file, my_path+end_b+file)

def clc_metriecs_for_Xray():
    print("cycleGAN results VS real pics:")
    fid, kid_m, kid_s = calc_kid_fid('results/metrices/cycleGAN', 'results/metrices/real')
    print('fid: ' + str(fid) + '    kid_mean: ' + str(kid_m) + '    kid_std: ' + str(kid_s))
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`")
    print("pix2pix results VS real pics:")
    fid, kid_m, kid_s = calc_kid_fid('results/metrices/pix2pix', 'results/metrices/real')
    print('fid: ' + str(fid) + '    kid_mean: ' + str(kid_m) + '    kid_std: ' + str(kid_s))


if __name__ == '__main__':
    print("cycleGAN results VS real pics")
    fid, kid_m, kid_s = calc_kid_fid('results/metrices/cycleGAN', 'results/metrices/real')
    print('fid: ' + str(fid) + '    kid_mean: ' + str(kid_m) + '    kid_std: ' + str(kid_s))
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`")
    print("pix2pix results VS real pics")
    fid, kid_m, kid_s = calc_kid_fid('results/metrices/pix2pix', 'results/metrices/real')
    print('fid: ' + str(fid) + '    kid_mean: ' + str(kid_m) + '    kid_std: ' + str(kid_s))
