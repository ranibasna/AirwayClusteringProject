import pandas as pd
import numpy as np
from time import time
import os
import sys

# Deep Learning libraries
import keras.backend as K
from keras.optimizers import SGD
from keras.utils.vis_utils import plot_model
from keras import initializers, optimizers
import tensorflow as tf
from DEC import DEC
# import h5py
# import argparse

# Seeding libraries
from numpy.random import seed
from tensorflow import set_random_seed
import random


# adding the path to the Functions inside the project
p = os.path.abspath('/Users/xbasra/Documents/Data/Airway_Clustering/Python_Functions/')
if p not in sys.path:
    sys.path.append(p)

# Creat parser
# my_parser = argparse.ArgumentParser(description='running the deep clustering from the command line')
# Add the data argument
# my_parser.add_argument('converted_data', type=argparse.FileType('r'), help='input the converted data from the uft method')
# my_parser.add_argument('original_data', type=argparse.FileType('r'), help='enter the original airway data set')
# my_parser.add_argument('output_dir_path', type=str, help='the path to save the output')
# my_parser.add_argument('output_dir_path', type=argparse.FileType('w'), help='the path to save the output')
# execute the parser_args method
# args = my_parser.parse_args()

# original_data = pd.read_csv(args.original_data)
# converted_airway = pd.read_csv(args.converted_data)

converted_airway = pd.read_csv(sys.argv[1])
converted_airway.drop('Unnamed: 0', axis=1, inplace=True)

original_data = pd.read_csv(sys.argv[2])
# original_data.drop('Unnamed: 0', axis=1, inplace=True)

# Airway_data = pd.read_csv('/Users/xbasra/Documents/Data/Airway_Clustering/Intermediate/Preprocessed_data/Airway2_f.csv')
# del Airway_data['Unnamed: 0']
# converted_airway = pd.read_csv('/Users/xbasra/Documents/Data/Airway_Clustering/Intermediate/Preprocessed_data/converted_airway.csv')
# del converted_airway['Unnamed: 0']
# airway_2 = pd.read_csv('/Users/xbasra/Documents/Data/Airway_Clustering/Intermediate/Preprocessed_data/Airway2.csv')
# del airway_2['Unnamed: 0']

# The below is necessary in Python 3.2.3 onwards to
# have reproducible behavior for certain hash-based operations.
os.environ['PYTHONHASHSEED'] = str(0)
# The below is necessary for starting Numpy generated random numbers
# in a well-defined initial state.
random.seed(44)
# The below is necessary for starting core Python generated random numbers
# in a well-defined state.
seed(22)
# Force TensorFlow to use single thread.
# Multiple threads are a potential source of
# non-reproducible results.
session_conf = tf.ConfigProto(intra_op_parallelism_threads=1,
                              inter_op_parallelism_threads=1)
set_random_seed(454)
sess = tf.Session(graph=tf.get_default_graph(), config=session_conf)
K.set_session(sess)

dec_airway = DEC(dims=[converted_airway.shape[-1], 200, 10], n_clusters=6)
# plot_model(dec_food.model, to_file='dec_model.png', show_shapes=True)
dec_airway.model.summary()
t0 = time()
# Pretrain autoencoders before clustering
dec_airway.pretrain(converted_airway, batch_size=128, epochs=200, optimizer='adam')
# begin clustering, time not include pretraining part.

dec_airway.compile(loss='kld', optimizer='adam')
dec_airway.fit(converted_airway, y=None, batch_size=128, tol=0.00001, maxiter=15000, update_interval=40)
# Show the final results
y_pred = dec_airway.y_pred
# print('acc:', cluster_acc(y, y_pred))
print('clustering time: %d seconds.' % int(time() - t0))

print(np.unique(y_pred, return_counts=True))

result_airway_uft_DEC = original_data.copy()
result_airway_uft_DEC['clusters'] = y_pred
# result_airway_uft_DEC.to_csv('03_output/result_airway_uft_DEC.csv', index=None, header=True)
# args.output_dir_path.write('result_airway_uft_DEC')
# result_airway_uft_DEC.to_csv(args.out_dir)
result_airway_uft_DEC.to_csv(sys.argv[3], index=None, header=True)

# python3 Python_Functions/code.py Intermediate/Preprocessed_data/converted_airway.csv Original_Data/AirwayDiseasePhenotypingDataSets5/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv Results/result_airway_DEC.csv
