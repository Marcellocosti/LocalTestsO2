#!/bin/bash

o2-analysis-tracks-extra-v002-converter -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-hf-track-index-skim-creator -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-track-to-collision-associator -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-trackselection -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-hf-pid-creator -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-pid-tof-merge -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-multcenttable -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-event-selection-service -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-propagationservice -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-pid-tpc-service -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 |\
o2-analysis-ft0-corrected-table -b --configuration json://configuration.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778 --aod-file @input.txt --aod-parent-access-level 1 --aod-parent-base-path-replacement "alien://;/home/alitrain/train-workdir/testdata/LFN" --readers 1 --aod-memory-rate-limit 209715200 --shm-segment-size 7500000000 --time-limit 300 --resources-monitoring 5 --resources-monitoring-dump-interval 600  > log.txt 2>&1
