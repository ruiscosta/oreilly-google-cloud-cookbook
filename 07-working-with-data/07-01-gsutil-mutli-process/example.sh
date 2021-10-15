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

# can cancel once you see transfer speed, will move ~250GB total
gsutil cp -r gs://gcp-public-data-landsat/LC08/01/044/034/* gs://$BUCKET_NAME

# can cancel once you see greatly increased transfer speed
gsutil -m cp -r gs://gcp-public-data-landsat/LC08/01/044/034/ gs://$BUCKET_NAME

# delete data
gsutil -m rm -r  gs://$BUCKET_NAME/034/*