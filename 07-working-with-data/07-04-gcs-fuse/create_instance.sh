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

# create VM
gcloud compute --project=dhodun1 instances create gcs-fuse-vm \
    --zone=us-central1-a --machine-type=e2-medium \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --image=ubuntu-2004-focal-v20210315 --image-project=ubuntu-os-cloud \
    --boot-disk-size=100GB

# create bucket and populate with dummy data
BUCKET_NAME=my-bucket-4312

gsutil mb -l us gs://$BUCKET_NAME
gsutil -m cp -r gs://gcp-public-data-landsat/LC08/01/044/034/LC08_L1GT_044034_20130330_20170310_01_T2 gs://$BUCKET_NAME

# install gcs-fuse
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update
sudo apt-get install gcsfuse

# check credentials
gcloud auth list

# create mount point and mount
BUCKET_NAME=my-bucket-4312

mkdir $BUCKET_NAME
gcsfuse --implicit-dirs $BUCKET_NAME $BUCKET_NAME

# check contents
ls $BUCKET_NAME
cd $BUCKET_NAME
echo "gcs fuse is cool!" > file.txt

# verify the file is on GCS
cd
gsutil cat gs://$BUCKET_NAME/file.txt

# lastly, edit fstab so the bucket mounts on boot
# first grab your user's userid and groupid
id

vim /etc/fstab

# add:
my-bucket-4312 /home/dhodun/my-bucket-4312 gcsfuse rw,implicit_dirs,x-systemd.requires=network-online.target,allow_other,uid=1001,gid=1002

# restart vm and test
sudo shutdown -r now