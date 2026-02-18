## Test pid studies 
#!bin!bash
OPTION="-b --configuration json://configuration.json"
LOGFILE="log.txt"


o2-analysis-propagationservice $OPTION |
o2-analysis-tracks-extra-v002-converter $OPTION |
o2-analysis-event-selection-service $OPTION |
o2-analysis-ft0-corrected-table $OPTION |
o2-analysis-pid-tof-merge $OPTION |
o2-analysis-trackselection $OPTION |
o2-analysis-qa-event-track-lite-producer $OPTION --aod-file @inputs.txt --aod-writer-json OutputDirector.json > "$LOGFILE" 2>&1

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