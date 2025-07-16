OPTION="-b --configuration json://config.json"
LOGFILE="log.txt"

o2-analysis-pid-tof-full $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-pid-tpc $OPTION |\
o2-analysis-ft0-corrected-table $OPTION |\
o2-analysis-timestamp $OPTION |\
o2-analysis-qvector-table $OPTION |\
o2-analysis-hf-task-flow-charm-hadrons $OPTION |\
o2-analysis-hf-track-index-skim-creator $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi $OPTION |\
o2-analysis-pid-tpc-base $OPTION |\
o2-analysis-track-propagation $OPTION |\
o2-analysis-trackselection $OPTION |\
o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-hf-candidate-creator-3prong $OPTION --resources-monitoring 2 --aod-file @input_data.txt --aod-writer-json OutputDirector.json > "$LOGFILE" 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!" >> "$LOGFILE"
  python3 ~/LocalTestsO2/utils/proj_thnsparse.py -dpflow
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