#!/bin/bash
# Copyright 2020 Tencent
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

set -e
#NUM_THREADS=(4)
#FRAMEWORKS=("turbo-transformers")
#BATCH_SIZE=(2)
#SEQ_LEN=(4)
NUM_THREADS=(1 2 4 8)
FRAMEWORKS=("torch" "turbo-transformers")
SEQ_LEN=(10 20 40 60 80 120)
BATCH_SIZE=(1 2)
N=150
MODEL="bert-base-chinese"
for n_th in ${NUM_THREADS[*]}
do
  for batch_size in ${BATCH_SIZE[*]}
  do
    for seq_len in ${SEQ_LEN[*]}
    do
      for framework in ${FRAMEWORKS[*]}
      do
        env OMP_WAIT_POLICY=ACTIVE OMP_NUM_THREADS=${n_th} python benchmark.py ${MODEL} --seq_len=${seq_len} --batch_size=${batch_size}\
            -n ${N} --framework=${framework} --num_threads=${n_th}
      done
    done
  done
done
