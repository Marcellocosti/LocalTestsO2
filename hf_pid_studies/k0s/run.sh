#!bin!bash

OPTION="-b --configuration json://home/mdicosta/runlocal/pid/k0s_data/config_PR.json"
LOGFILE="log.txt"

o2-analysis-hf-task-pid-studies $OPTION |
o2-analysis-timestamp $OPTION |
o2-analysis-mccollision-converter $OPTION |
o2-analysis-centrality-table $OPTION |
o2-analysis-multiplicity-table $OPTION |
o2-analysis-event-selection $OPTION |
o2-analysis-track-propagation $OPTION |
# o2-analysis-pid-tof-merge $OPTION |
o2-analysis-pid-tof-base $OPTION |
o2-analysis-pid-tof-full $OPTION |
o2-analysis-ft0-corrected-table $OPTION |
o2-analysis-lf-lambdakzerobuilder $OPTION |
o2-analysis-pid-tpc $OPTION |
o2-analysis-lf-lambdakzeromcbuilder $OPTION |
o2-analysis-lf-cascadebuilder $OPTION |
o2-analysis-lf-cascademcbuilder $OPTION |
o2-analysis-tracks-extra-v002-converter $OPTION |
o2-analysis-pid-tpc-base $OPTION --aod-file @input_data_pid.txt --aod-writer-json OutputDirector_pid.json > "$LOGFILE" 2>&1

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
rm AO2D.root
rm ao2ds_to_merge.txt
rm localhost*