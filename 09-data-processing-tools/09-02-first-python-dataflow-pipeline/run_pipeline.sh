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


gcloud projects add-iam-policy-binding dhodun2 \
    --member=serviceAccount:181626564526-compute@developer.gserviceaccount.com \
    --role=roles/storage.objectAdmin

DATAFLOW_REGION=us-central1
STORAGE_BUCKET=my_new_dataflow_bucket23
PROJECT_ID=dhodun2


python3 wordcount.py \
    --region $DATAFLOW_REGION \
    --input gs://dataflow-samples/shakespeare/kinglear.txt \
    --output gs://$STORAGE_BUCKET/results/outputs \
    --runner DataflowRunner \
    --project $PROJECT_ID \
    --temp_location gs://$STORAGE_BUCKET/tmp/