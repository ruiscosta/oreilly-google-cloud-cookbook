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

PROJECT_ID=<INSERT PROJECT>

# create VM
gcloud compute --project=$PROJECT_ID instances create pd-snapshot-test \
--zone=us-central1-a --machine-type=e2-medium \
--scopes=https://www.googleapis.com/auth/cloud-platform \
--image=ubuntu-2004-focal-v20210315 --image-project=ubuntu-os-cloud \
--boot-disk-size=100GB

# SSH onto VM
gcloud compute ssh pd-snapshot-test --zone us-central1-a

# add a file
echo "Hello World!" >> my_file.txt
cat my_file.txt

# create first snapshot in UI

# add second file
echo "Hello Universe!" >> my_second_file.txt
cat my_second_file.txt

# create new snapshot in UI

gcloud compute --project=dhodun1 instances delete pd-snapshot-test --zone=us-central1-a --delete-disks=all

# delete including the disk
gcloud compute --project=dhodun1 instances delete pd-snapshot-test --zone=us-central1-a --delete-disks=all

# create using snapshot

# test it
gcloud compute ssh pd-snapshot-restore --zone us-central1-a
cat my_file.txt
cat my_second_file.txt

# delete new instance
gcloud compute instances delete pd-snapshot-restore --zone us-central1-a