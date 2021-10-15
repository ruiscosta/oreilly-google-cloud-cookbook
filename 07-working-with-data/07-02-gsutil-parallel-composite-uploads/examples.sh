# Copyright 2021, Google, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

BUCKET_NAME=my-bucket-4312

gsutil mb -l us gs://$BUCKET_NAME


# copy a largish file locally (~250MB)
gsutil cp gs://gcp-public-data-landsat/LC08/01/044/017/LC08_L1GT_044017_20200809_20200809_01_RT/LC08_L1GT_044017_20200809_20200809_01_RT_B8.TIF .

# copy file in single chunk
gsutil cp LC08_L1GT_044017_20200809_20200809_01_RT_B8.TIF gs://$BUCKET_NAME

# speed up upload with parallel composite uploads
gsutil -o "GSUtil:parallel_composite_upload_threshold=200M,GSUtil:parallel_composite_upload_component_size=50M,GSUtil:parallel_process_count=8" cp LC08_L1GT_044017_20200809_20200809_01_RT_B8.TIF gs://$BUCKET_NAME

# cleanup
gsutil rm gs://$BUCKET_NAME/LC08_L1GT_044017_20200809_20200809_01_RT_B8.TIF