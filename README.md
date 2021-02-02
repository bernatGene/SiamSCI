# Sensor Camera Source Identification

Code from Bernat G. Skrabec

## Relevant Files

The relevant code of the latest versions are comprised in the following three notebooks:

* generate_strips.ipynb
	* Generates the strips dataset from the Socrates dataset. To run it you need a directory with all images to be used from the socrates dataset in a single directory (ori datadir). It generates the dataset on out datadir with the described structre. Best ensure that there are no videos. 
	* Creates a json file used to navigate the dataset and retrieve strips as requested. The structure is explained on the following notebook

* get_characteristic_test.ipynb 
	* Substitutes the previously generated strips by their characterstic noise as described by Lukas et al. 

Please not that the above processes may take an awful long amount of time if using the whole socrates dataset. (1h+)

* siamese_new_dataset.ipynb
	* The definition of the siamese model, as well as the training and evaluation routines. The training checkpoint for the latest version of the model can be found under the checkpts directory. Training may take unreasonable amount of time wihtout a GPU, restore the model checkpt with load_weights instead. 

## Requirements

The code was developed under a docker environment and is strongly recommended to run it so. The Dockerfile is included, but it was reversed-engineered from the image, so it may be unstable. If facing problems, the image is derived from https://hub.docker.com/layers/tensorflow/tensorflow/latest-gpu-jupyter/images/sha256-c3b4e83edf14b282902c80e0ef245115736ce4c91eabc39c93f51ca56508e504?context=explore , with the addition of:
cv2 (may be already included)
pywt
scipy

If you do not wish to use docker, the first two notebooks should be runable with python3 and the aforementioned modules.
