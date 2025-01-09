OPTION="-b --configuration json://config.json"
LOGFILE="log.txt"

o2-analysis-pid-tof-full $OPTION |
o2-analysis-pid-tof-base $OPTION |
o2-analysis-hf-pid-creator $OPTION |
o2-analysis-pid-tpc $OPTION |
o2-analysis-ft0-corrected-table $OPTION |
o2-analysis-timestamp $OPTION |
o2-analysis-hf-track-index-skim-creator $OPTION |
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi $OPTION |
o2-analysis-event-selection $OPTION |
o2-analysis-multiplicity-table $OPTION |
o2-analysis-track-to-collision-associator $OPTION |
o2-analysis-pid-tpc-base $OPTION |
o2-analysis-track-propagation $OPTION |
o2-analysis-trackselection $OPTION |
o2-analysis-centrality-table $OPTION |
o2-analysis-hf-task-dplus $OPTION |
o2-analysis-mccollision-converter $OPTION |
o2-analysis-tracks-extra-v002-converter $OPTION |
o2-analysis-hf-candidate-creator-3prong $OPTION > "$LOGFILE" 2>&1

# report status
rc=$?
if [ $rc -eq 0 ]; then
  echo "No problems!"
  python3 ~/LocalTestsO2/utils/proj_thnsparse.py -dpdata
else
  echo "Error: Exit code $rc"
  echo "Check the log file $LOGFILE"
  exit $rc
fi