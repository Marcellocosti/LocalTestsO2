## Test pid studies 
#!bin!bash
OPTION="-b --configuration json://configuration.json"
LOGFILE="log.txt"


o2-analysis-timestamp $OPTION |
o2-analysis-mm-lumi-stability-p-p $OPTION --aod-file @inputs.txt > "$LOGFILE" 2>&1

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