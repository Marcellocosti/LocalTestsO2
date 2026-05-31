#!/bin/bash
OPTION="-b --configuration json://config.json"
LOGFILE="log.txt"

o2-analysis-ft0-corrected-table $OPTION |\
o2-analysis-pid-tof-merge $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-propagationservice $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-lf-kink-builder $OPTION |\
o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-lf-lambda1405analysis $OPTION --aod-writer-json OutputDir.json --aod-file @input_data.txt --shm-segment-size 7500000000 --aod-parent-access-level 1 > "$LOGFILE" 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!" >> "$LOGFILE"
else
  echo "Error: Exit code $rc" >> "$LOGFILE"
  echo "Check the log file $LOGFILE"
  exit $rc
fi

touch ao2ds_to_merge.txt
echo AO2D.root > ao2ds_to_merge.txt
o2-aod-merger --input ao2ds_to_merge.txt --max-size 10000000000000 --output Tree.root
rm ao2ds_to_merge.txt
rm localhost*