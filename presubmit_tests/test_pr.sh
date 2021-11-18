#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

### Transferring shell commands used in https://gist.github.com/jcnars/26b8526cde45a1bb5778a36abe90b96b
### into this test script
### context / reference: (internal) at: http://b/202240337#comment22

# set up ssh from pod to BMX host
# using sydney for initial testing
mkdir /root/.ssh
chmod 0700 /root/.ssh
ssh-keyscan -tecdsa 172.16.30.1 > /root/.ssh/known_hosts

# install pre-reqs
pip install jmespath
cp /etc/files_needed_for_tk/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
yum install google-cloud-sdk -y

# run the cleanup script
cd ..; ./cleanup-oracle.sh --ora-version 19 --inventory-file /etc/files_needed_for_tk/nonrac-inv --yes-i-am-sure --ora-disk-mgmt udev --ora-swlib-path /u01/oracle_install --ora-asm-disks /etc/files_needed_for_tk/nonrac-asm.json --ora-data-mounts /etc/files_needed_for_tk/nonrac-datamounts.json

# run the install script
./install-oracle.sh --ora-swlib-bucket gs://bmaas-testing-oracle-software --instance-ssh-user ansible9 --instance-ssh-key /etc/files_needed_for_tk/id_rsa_bms_tk_key --backup-dest "+RECO" --ora-swlib-path /u01/oracle_install --ora-version 19 --ora-swlib-type gcs --ora-asm-disks /etc/files_needed_for_tk/nonrac-asm.json --ora-data-mounts /etc/files_needed_for_tk/nonrac-datamounts.json --cluster-type NONE --ora-data-diskgroup DATA --ora-reco-diskgroup RECO --ora-db-name orcl --ora-db-container false --instance-ip-addr 172.16.30.1 --instance-hostname linuxserver44.orcl
