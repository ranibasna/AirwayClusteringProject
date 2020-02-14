import pandas as pd
import numpy as np
from time import time
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.utils import resample
from sklearn import metrics
from sklearn.metrics import adjusted_rand_score
import os
import sys

# Deep Learning libraries
from keras.models import Sequential
from keras.layers.core import Dense, Activation, Reshape
from keras.layers import Dense, Input
#from keras.layers import Merge
from keras.layers import Concatenate
from keras.layers.embeddings import Embedding
from keras.callbacks import ModelCheckpoint
import keras.backend as K
from keras.engine.topology import Layer, InputSpec
from keras.models import Model
from keras.optimizers import SGD
from keras import callbacks
from keras.initializers import VarianceScaling
from keras.utils.vis_utils import plot_model
from keras import initializers, optimizers
import tensorflow as tf

import h5py

# Seeding libraries
from numpy.random import seed
from tensorflow import set_random_seed
import random
import seaborn as sns; sns.set()

# adding the path to the Functions inside the project
p = os.path.abspath('/Users/xbasra/Documents/Data/Airway_Clustering/Python_Functions/')
if p not in sys.path:
  sys.path.append(p)

Airway_data = pd.read_csv('/Users/xbasra/Documents/Data/Airway_Clustering/Intermediate/Preprocessed_data/Airway2_f.csv')
del Airway_data['Unnamed: 0']
converted_airway = pd.read_csv('/Users/xbasra/Documents/Data/Airway_Clustering/Intermediate/Preprocessed_data/converted_airway.csv')
del converted_airway['Unnamed: 0']
pd.set_option('display.max_columns', 30)
airway_2 = pd.read_csv('/Users/xbasra/Documents/Data/Airway_Clustering/Intermediate/Preprocessed_data/Airway2.csv')
del airway_2['Unnamed: 0']
airway_2.head()

from DEC import DEC
dec_airway = DEC(dims=[converted_airway.shape[-1], 200, 10], n_clusters=6)
print(dec_airway.model.summary())

# Pretrain autoencoders before clustering
dec_airway.pretrain(converted_airway, batch_size=128, epochs=100, optimizer='adam')
# begin clustering, time not include pretraining part.
dec_airway.compile(loss='kld', optimizer='adam')
dec_airway.fit(converted_airway, y=None, batch_size=128, tol= 0.00001, maxiter=15000,
            update_interval=40)

# Show the final results
y_pred = dec_airway.y_pred
#print('acc:', cluster_acc(y, y_pred))
print('clustering time: %d seconds.' % int(time() - t0))





# from FcDEC import FcDEC
# 
# FcDE_airway = FcDEC(dims=[np.asarray(converted_airway).shape[-1], 100, 70, 15], n_clusters=6)
# FcDE_airway.pretrain(converted_airway.values, batch_size=128, epochs=200, optimizer='adam', aug_pretrain=False)
# 
# optimizer = SGD(lr= 0.9)
# FcDE_airway.compile(optimizer=optimizer, loss='kld')
# y_pred_FcDE = FcDE_airway.fit(converted_airway.values, y=None, maxiter=15000, batch_size=128, update_interval=40,aug_cluster=False)


result_airway_uft_DEC = converted_airway.copy()
result_airway_uft_DEC['cluster'] = y_pred
result_airway_uft_DEC = result_airway_uft_DEC.to_csv('/Users/xbasra/Documents/Data/Airway_Clustering/Intermediate/CSV_output_data/result_airway_uft_DEC.csv', index = None, header=True)












