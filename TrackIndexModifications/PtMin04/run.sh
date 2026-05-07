#!/bin/bash

SUFFIX_DATATYPE=$1

OPTION="-b --configuration json://config_${SUFFIX_DATATYPE}.json --session 661778 --timeframes-rate-limit 2 --timeframes-rate-limit-ipcid 661778"
LOGFILE="log_${SUFFIX_DATATYPE}.txt"

o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-hf-track-index-skim-creator $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-trackselection $OPTION |\
o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-pid-tof-merge $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-propagationservice $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-ft0-corrected-table $OPTION --aod-file @input.txt --aod-parent-access-level 1 --aod-parent-base-path-replacement "alien://;/home/alitrain/train-workdir/testdata/LFN" --readers 1 --aod-memory-rate-limit 209715200 --shm-segment-size 7500000000 --time-limit 300 --resources-monitoring 5 --resources-monitoring-dump-interval 600  > "$LOGFILE" 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!" >> "$LOGFILE"
else
  echo "Error: Exit code $rc" >> "$LOGFILE"
  echo "Check the log file $LOGFILE"
  exit $rc
fi

mv AnalysisResults.root AnalysisResults_${SUFFIX_DATATYPE}.root
mv performanceMetrics.json performanceMetrics_${SUFFIX_DATATYPE}.json
mv dpl-config.json dpl-config_${SUFFIX_DATATYPE}.json







# # Include o2-analysis-tracks-extra-v002-converter with PbPb, comment with OO
# o2-analysis-tracks-extra-v002-converter $OPTION |\
# o2-analysis-pid-tof-full $OPTION |\
# o2-analysis-pid-tof-base $OPTION |\
# o2-analysis-hf-pid-creator $OPTION |\
# o2-analysis-pid-tpc-service $OPTION |\
# o2-analysis-ft0-corrected-table $OPTION |\
# o2-analysis-multcenttable $OPTION |\
# o2-analysis-event-selection-service $OPTION |\
# o2-analysis-hf-track-index-skim-creator $OPTION |\
# o2-analysis-propagationservice $OPTION |\
# o2-analysis-trackselection $OPTION |\
# # o2-analysis-hf-candidate-creator-3prong $OPTION |\
# o2-analysis-track-to-collision-associator $OPTION --resources-monitoring 5 --aod-memory-rate-limit 10000000000000 --aod-file @input_file_${SUFFIX_DATATYPE}.txt --shm-segment-size 7500000000000 --time-limit 300 > "$LOGFILE" 2>&1
