OPTION="-b --configuration json://cfg_task_dplus.json"
LOGFILE="log_task_dplus.txt"

o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-propagationservice $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
o2-analysis-pid-tof-full $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-hf-candidate-creator-3prong $OPTION |\
o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi $OPTION |\
o2-analysis-hf-task-dplus $OPTION |\
o2-analysis-trackselection $OPTION --aod-file @input_track_index_new_embedding.txt --aod-parent-access-level 1 > $LOGFILE 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!"
else
  echo "Error: Exit code $rc"
  echo "Check the log file $LOGFILE"
  exit $rc
fi

rm AnalysisResults_task_dplus.root
mv AnalysisResults.root AnalysisResults_task_dplus.root
