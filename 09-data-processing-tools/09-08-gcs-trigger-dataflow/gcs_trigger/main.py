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

def gcs_trigger(event, context):

    import time

    from googleapiclient.discovery import build

    input_path = 'gs://{}/{}'.format(event['bucket'], event['name'])

    project = 'dhodun1'
    job = 'gcs-trigger-job-{}'.format(time.strftime("%Y%m%d-%H%M%S"))
    parameters = {
        'inputPath': input_path,
        'outputTable': "dhodun1:weblog.events_upload"
    }

    dataflow = build('dataflow', 'v1b3')
    request = dataflow.projects().locations().flexTemplates().launch(
        projectId=project,
        location="us-central1",
        body={
            "launchParameter": {
                'jobName': job,
                'containerSpecGcsPath': 'gs://dhodun1/tmp/templates/gcs-trigger-template.json',
                'parameters': parameters,
            }
        }
    )

    response = request.execute()
