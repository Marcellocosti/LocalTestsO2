OPTION="-b --configuration json://cfg_grid.json"
LOGFILE="log.txt"
o2-analysis-hf-data-creator-charm-had-pi-reduced $OPTION |\
o2-analysis-pid-tof-full $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-trackselection $OPTION |\
o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-hf-candidate-selector-dstar-to-d0-pi $OPTION |\
o2-analysis-lf-propagationservice $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-hf-candidate-creator-dstar $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
o2-analysis-ft0-corrected-table $OPTION --aod-file @../../input_data.txt  --aod-writer-json ./../../OutputDirector_creator.json --aod-parent-access-level 1  > $LOGFILE 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!"
else
  echo "Error: Exit code $rc"
  echo "Check the log file $LOGFILE"
  exit $rc
fi

mv AnalysisResults.root AnalysisResults_workflow.root
# mv AO2D.root AO2D_workflow.root
# rm localhost*

touch ao2ds_to_merge.txt
echo AO2D.root > ao2ds_to_merge.txt
o2-aod-merger --input ao2ds_to_merge.txt --max-size 10000000000000 --output Tree.root
rm ao2ds_to_merge.txt
rm localhost*