OPTION="-b --configuration json://cfg_track_index.json"
LOGFILE="log_track_index.txt"

o2-analysis-hf-track-index-skim-creator $OPTION |\
o2-analysis-tracks-extra-v002-converter $OPTION |\
o2-analysis-multcenttable $OPTION |\
o2-analysis-event-selection-service $OPTION |\
o2-analysis-propagationservice $OPTION |\
o2-analysis-pid-tpc-service $OPTION |\
o2-analysis-track-to-collision-associator $OPTION |\
o2-analysis-trackselection $OPTION --aod-writer-json output_director_track_index.json --aod-file @input_new_embedding.txt > $LOGFILE 2>&1

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
rm AO2D.root
mv AnalysisResults.root AnalysisResults_trackindex.root
mv Tree.root Tree_trackindex.root