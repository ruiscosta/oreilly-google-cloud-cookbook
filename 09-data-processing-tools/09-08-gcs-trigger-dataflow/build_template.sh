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


gcloud dataflow flex-template build $TEMPLATE_PATH \
  --image-gcr-path "$TEMPLATE_IMAGE" \
  --sdk-language "JAVA" \
  --flex-template-base-image JAVA11 \
  --metadata-file "metadata.json" \
  --jar "target/cookbook-gcs-trigger-pipeline-1.0.jar" \
  --env FLEX_TEMPLATE_JAVA_MAIN_CLASS="com.mypackage.pipeline.MyPipeline"