OPTION="-b --configuration json://cfg_mc.json"
LOGFILE="log.txt"

o2-analysis-multiplicity-table $OPTION |\
o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-pid-tpc $OPTION |\
o2-analysis-track-propagation $OPTION |\
o2-analysis-mccollision-converter $OPTION |\
o2-analysis-ft0-corrected-table $OPTION |\
o2-analysis-timestamp $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
o2-analysis-pid-tof-full $OPTION |\
o2-analysis-hf-track-index-skim-creator $OPTION |\
o2-analysis-hf-candidate-creator-3prong $OPTION |\
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi $OPTION |\
o2-analysis-hf-tree-creator-dplus-to-pi-k-pi $OPTION |\
o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-trackselection $OPTION |\
o2-analysis-pid-tpc-base $OPTION |\
o2-analysis-event-selection $OPTION |\
o2-analysis-centrality-table $OPTION --aod-file @../input_mc_pp.txt --aod-writer-json OutputDirector.json --resources-monitoring 2 > log.txt 2>&1

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