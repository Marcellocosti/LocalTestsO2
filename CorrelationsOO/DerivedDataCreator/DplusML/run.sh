OPTION="-b --configuration json://cfg.json"
LOGFILE="log.txt"

o2-analysis-pid-tof-full $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-ft0-corrected-table $OPTION |\
o2-analysis-track-propagation $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-trackselection $OPTION |\
o2-analysis-hf-candidate-creator-3prong $OPTION |\
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi $OPTION |\
o2-analysis-hf-derived-data-creator-correlations-reduced $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-event-selection-service $OPTION --aod-writer-json ../OutputDir.json --aod-file @../input_OO.txt --aod-parent-access-level 1 > $LOGFILE 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!"
else
  echo "Error: Exit code $rc"
  echo "Check the log file $LOGFILE"
  exit $rc
fi

touch ao2ds_to_merge.txt
echo AO2D.root > ao2ds_to_merge.txt
o2-aod-merger --input ao2ds_to_merge.txt --max-size 1000000000000000 --output Tree.root
rm ao2ds_to_merge.txt
rm localhost*