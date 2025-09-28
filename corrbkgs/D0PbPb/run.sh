OPTION="-b --configuration json://grid.json"
LOGFILE="log.txt"

o2-analysis-hf-tree-creator-d0-to-k-pi $OPTION |\
o2-analysis-hf-candidate-selector-d0 $OPTION |\
o2-analysis-hf-candidate-creator-2prong $OPTION |\
o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-pid-tof-full $OPTION |\
o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-propagationservice $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
# o2-analysis-mccollision-converter $OPTION |\
o2-analysis-ft0-corrected-table $OPTION --aod-file @../input_LHC25e3.txt --aod-writer-json OutputDirector.json --aod-parent-access-level 1 > log.txt 2>&1

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
o2-aod-merger --input ao2ds_to_merge.txt --max-size 10000000000000 --output Tree.root
rm ao2ds_to_merge.txt
rm localhost*