# Sensor Camera Source Identification

Code from Bernat G. Skrabec

## Relevant Files

The relevant code of the latest versions are comprised in the following three notebooks:

* generate_strips.ipynb
	* Generates the strips dataset from the Socrates dataset. To run it you need a directory with all images to be used from the socrates dataset in a single directory (ori datadir). It generates the dataset on out datadir with the described structre. Best ensure that there are no videos. 
	* Creates a json file used to navigate the dataset and retrieve strips as requested. The structure is explained on the following notebook

* get_characteristic.ipynb 
	* Substitutes the previously generated strips by their characterstic noise as described by Lukas et al. 

Please not that the above processes may take an awful long amount of time if using the whole socrates dataset. (10h+)

* siamese_model.ipynb
	* The definition of the siamese model, as well as the training and evaluation routines. The training checkpoint for the latest version of the model can be found under the checkpts directory. Training may take unreasonable amount of time wihtout a GPU, restore the model checkpt with load_weights instead. 


## Source dataset and distribution
The dataset used is SOCRatES [Galdi et al. 2019], the following numbers are the student ID's used to identify each device.
For the included checkpoint, the train-valid-test split was the following:

* Train: `['204', '101', '198', '155', '129', '136', '121', '111', '165', '191', '102', '118', '217', '170', '211', '183', '145', '190', '112', '195', '108', '174', '199', '184', '185', '159', '197', '150', '146', '210', '194', '202', '119', '161', '157', '144', '142', '126', '167', '219', '220', '179', '148', '115', '216', '147', '212', '166', '186', '163', '200', '189', '168', '156', '104', '107']`

* Validation `['100', '132', '214', '215', '133', '120', '177']`

* Test `[103, 123, 125, 128,  140,  152,  160,  173,  187,  213,  114,  124,  127,  130,  149,  154,  172,  176,  193,  224]`

All other devices on the SOCRatES dataset (Note that there is still quite a few) have not been used for anything. Additionally, some have been dismissed because of incompatibility with our code: For each device, all images of a different resolution than the maxmium of the rest of their own images have been deleted (There's about 5 cases of such devices). Devices which as a result of this have less than 10 images have been dropped. Devices from which we can only extract less than 10 patches have been dropped as well. 

## Requirements

The code was developed under a docker environment and is highly recommended to run it so. The Dockerfile is included, but it was reversed-engineered from the image, so it may be unstable. If facing problems, the image is derived from https://hub.docker.com/layers/tensorflow/tensorflow/latest-gpu-jupyter/images/sha256-c3b4e83edf14b282902c80e0ef245115736ce4c91eabc39c93f51ca56508e504?context=explore , with the addition of:

* opencv-python 4.4.0.46
* pywt 1.1.1
* scipy 1.5.4
* sklearn 0.24.1

If you do not wish to use docker, the bare minimum requirements are (probably) the mentioned before and:
* tensorflow >= 2.4.0
* python >= 3.7
