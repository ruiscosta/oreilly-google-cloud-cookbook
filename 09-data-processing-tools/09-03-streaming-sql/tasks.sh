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

PROJECT_ID=<my_project>

gcloud pubsub topics create events

bq mk --location=us weblog

# load data into the table
bq load --autodetect $PROJECT_ID:weblog.userprofile ./bq_data.csv

# examine the table
bq head -n 10 $PROJECT_ID:weblog.userprofile

# add to data catalog

gcloud data-catalog entries update --lookup-entry='pubsub.topic.$PROJECT_ID.events' --schema-from-file=schema.yaml