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

#!/usr/bin/env python

import json
from datetime import datetime
import random
import time
import json
import os
import random
import time

# Set the `project` variable to a Google Cloud project ID.
project = os.environ['PROJECT_ID']


data = []

with open('events.json') as file:
    for row in file:
        data.append(json.loads(row))


while True:
    message = random.choice(data)
    message['timestamp'] = datetime.now().strftime('%Y-%m-%dT%H:%M:%S.%fZ')

    message = json.dumps(message)
    command = "gcloud --project={} pubsub topics publish events --message='{}'".format(
        project, message)
    print(command)
    os.system(command)
    time.sleep(random.randrange(1, 5))
