/**
 * Copyright 2021, Google, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const sendgrid = require('@sendgrid/mail');

exports.sendGrid = async (req, res) => {
    console.log('running sendGrid Function')
    try {
        if (req.method !== 'POST') {
            const error = new Error('Only POST requests are accepted');
            error.code = 405;
            throw error;
        }
        const msg = {
            to: req.body.to,
            from: req.body.from,
            subject: req.body.subject,
            text: req.body.text
        };
        sendgrid.setApiKey(process.env.SENDGRID_API_KEY);
        sendgrid.send(msg)
            .then((response) => {
                console.log(response)
                if (response.statusCode < 200 || response.statusCode >= 400) {
                    const error = Error(response.body);
                    error.code = response.statusCode;
                    throw error;
                }
                res.status(200).send(`\n\n Email Sent to ${req.body.to} \n\n`);
            })
        return Promise.resolve();
    } catch (err) {
        console.error(err);
        const code =
            err.code || (err.response ? err.response.statusCode : 500) || 500;
        res.status(code).send(err);
        return Promise.reject(err);
    }
};