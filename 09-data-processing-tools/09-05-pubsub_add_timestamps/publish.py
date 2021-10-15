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

import datetime
import json
import random
import time

from google.cloud import pubsub_v1

PROJECT_ID = "dhodun1"
TOPIC_NAME = "events"


def generate_event():
    return {
        'user_id': random.randint(1, 100),
        'action': random.choices(['start', 'stop', 'rewind', 'download'], k=1),
        'timestamp': datetime.datetime.utcnow().strftime('%m/%d/%Y %H:%M:%S %Z')
    }


def publish_burst(publisher, topic_path, buffer):
    for message in buffer:
        json_str = json.dumps(message)
        data = json_str.encode('utf-8')
        publisher.publish(topic_path, data,
                          timestamp=message['timestamp'])
        print('Message for event {} published at {}'.format(
            message['timestamp'],
            datetime.datetime.utcnow().strftime('%m/%d/%Y %H:%M:%S %Z')))


if __name__ == "__main__":
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(PROJECT_ID, TOPIC_NAME)

    while True:

        buffer = []
        for i in range(10):
            time.sleep(1)
            buffer.append(generate_event())

        publish_burst(publisher, topic_path, buffer)
