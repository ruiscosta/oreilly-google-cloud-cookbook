# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import logging
import os

import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.datasets import load_boston
from sklearn.model_selection import train_test_split
from tensorflow import keras
from tensorflow.keras import Sequential

if 'AIP_MODEL_DIR' not in os.environ:
    raise KeyError(
        'The `AIP_MODEL_DIR` environment variable has not been' +
        'set. See https://cloud.google.com/ai-platform-unified/docs/tutorials/image-recognition-custom/training'
    )
output_directory = os.environ['AIP_MODEL_DIR']

# using the Boston housing prices dataset
# https://scikit-learn.org/stable/datasets/toy_dataset.html#boston-dataset for more details
# using features like proportion of non-retail business acres in town, average rooms per dwelling, and tax rate
# to predict median house value in $1000's


logging.info('Loading and preprocessing data ...')

X, y = load_boston(return_X_y=True)
combined_data = pd.DataFrame(np.concatenate((X, np.expand_dims(y, 1)), axis=1))
combined_data.columns = ["CRIM", "ZN", "INDUS", "CHAS", "NOX", "RM",
                         "AGE", "DIS", "RAD", "TAX", "PTRATIO", "B1000", "LSTAT", "MEDV"]
data_train, data_test = train_test_split(combined_data)

FEATURES = ["CRIM", "ZN", "INDUS", "NOX", "RM",
            "AGE", "DIS", "TAX", "PTRATIO"]
LABEL = "MEDV"

train_features = data_train[FEATURES]
train_labels = data_train[LABEL]

test_features = data_test[FEATURES]
test_labels = data_test[LABEL]

logging.info('Creating and training model ...')
model = Sequential([
    keras.layers.Dense(
        15, activation="relu", input_shape=(train_features.shape[-1],)
    ),
    keras.layers.Dense(10, activation="relu"),
    keras.layers.Dense(1, activation=None)
])

model.compile(loss='mae')
model.fit(train_features, train_labels, epochs=20,
          validation_data=(test_features, test_labels))


logging.info(f'Exporting SavedModel to: {output_directory}')
model.save(output_directory)
