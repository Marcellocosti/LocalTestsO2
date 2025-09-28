OPTION="-b --configuration json://cfg.json"
LOGFILE="log.txt"

o2-analysis-hf-pid-creator $OPTION |\
o2-analysis-ft0-corrected-table $OPTION |\
o2-analysis-pid-tof-base $OPTION |\
o2-analysis-pid-tof-full $OPTION |\
o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-hf-candidate-creator-3prong $OPTION |\
o2-analysis-hf-tree-creator-dplus-to-pi-k-pi $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
# o2-analysis-mccollision-converter $OPTION |\
# o2-analysis-propagationservice $OPTION --aod-file @../input_mc_corrbkgs_derived.txt --aod-writer-json OutputDirector.json --aod-parent-access-level 1 > log_mc_corrbkgs_derived.txt 2>&1
o2-analysis-propagationservice $OPTION --aod-file @../input_LHC25e3.txt --aod-writer-json OutputDirector.json --aod-parent-access-level 1 > log_LHC25e3.txt 2>&1

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
o2-aod-merger --input ao2ds_to_merge.txt --max-size 10000000000000 --output Tree_LHC25e3.root
# o2-aod-merger --input ao2ds_to_merge.txt --max-size 10000000000000 --output Tree_input_mc_corrbkgs_derived.root
rm ao2ds_to_merge.txt
rm localhost*