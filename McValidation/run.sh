OPTION="-b --configuration json://config_with_mc_eff.json"
LOGFILE="log.txt"

o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-pid-tof-full $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
# o2-analysis-pid-tof-merge $OPTION |\
o2-analysis-hf-candidate-creator-2prong $OPTION |\
o2-analysis-hf-track-index-skim-creator $OPTION |\
o2-analysis-hf-candidate-creator-3prong $OPTION |\
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi $OPTION |\
o2-analysis-ft0-corrected-table $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-trackselection $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-propagationservice $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-hf-task-mc-efficiency $OPTION |\
o2-analysis-hf-task-mc-validation $OPTION --aod-file @input_data.txt --aod-memory-rate-limit 2000000000 --shm-segment-size 16000000000 --aod-parent-access-level 1 > $LOGFILE 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!"
else
  echo "Error: Exit code $rc"
  echo "Check the log file $LOGFILE"
  exit $rc
fi
