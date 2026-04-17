# OPTION="-b --configuration json://config_working.json"
OPTION="-b --configuration json://config.json"
LOGFILE="log.txt"

o2-analysis-pid-tof-full $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-ft0-corrected-table $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-hf-track-index-skim-creator $OPTION |\
o2-analysis-propagationservice $OPTION |\
o2-analysis-trackselection $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi $OPTION |\
o2-analysis-hf-task-dplus $OPTION |\
o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-hf-candidate-selector-ds-to-k-k-pi $OPTION |\
o2-analysis-hf-task-ds $OPTION |\
o2-analysis-hf-candidate-creator-3prong $OPTION --resources-monitoring 2 --aod-file @../input_files_2023_pass4_pbpb.txt --shm-segment-size 7500000000 > "$LOGFILE" 2>&1
# o2-analysis-qvector-table $OPTION --resources-monitoring 2 --aod-file @input_data.txt --aod-writer-json OutputDirector.json  --shm-segment-size 7500000000 --aod-parent-access-level 1 > "$LOGFILE" 2>&1

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