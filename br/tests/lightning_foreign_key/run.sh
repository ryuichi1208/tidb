#!/bin/bash
#
# Copyright 2022 PingCAP, Inc.
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

set -eu

# Create existing tables that import data will reference.
run_sql 'CREATE DATABASE IF NOT EXISTS fk;'
run_sql 'CREATE TABLE fk.t2 (a BIGINT PRIMARY KEY);'

for BACKEND in tidb local; do
  run_sql 'DROP TABLE IF EXISTS fk.t;'
  run_lightning --backend $BACKEND
  run_sql 'SELECT GROUP_CONCAT(a) FROM fk.t ORDER BY a;'
  check_contains '1,2,3,4,5'
done
