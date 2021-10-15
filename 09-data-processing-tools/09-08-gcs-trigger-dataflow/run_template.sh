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

BUCKET=dhodun1
PROJECT=dhodun1

export TEMPLATE_PATH=gs://$BUCKET/tmp/templates/gcs-trigger-template.json
export TEMPLATE_IMAGE="gcr.io/$PROJECT/cookbook/gcs-trigger-pipeline:latest"

export INPUT_PATH=gs://$BUCKET/events.json
export OUTPUT_TABLE=${PROJECT}:weblog.events_upload
export INPUT_SUBSCRIPTION="events_beam_9036176609351017604"


export REGION="us-central1"

gcloud dataflow flex-template run "cookbook-trigger-pipeline-`date +%Y%m%d-%H%M%S`" \
  --template-file-gcs-location "$TEMPLATE_PATH" \
  --parameters inputPath="$INPUT_PATH" \
  --parameters outputTable="$OUTPUT_TABLE" \
  --region "$REGION"