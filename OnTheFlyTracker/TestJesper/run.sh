OPTION="-b --configuration json://conf_reco.json"

rm AnalysisResults.root

o2-analysis-alice3-multicharm ${OPTION} |\
o2-analysis-on-the-fly-detector-geometry-provider ${OPTION} |\
o2-analysis-alice3-decaypreselector ${OPTION} |\
o2-analysis-alice3-multicharm-finder ${OPTION} |\
o2-analysis-onthefly-tofpid ${OPTION} |\
o2-analysis-onthefly-tracker ${OPTION} --shm-segment-size 6442450944 --aod-file AO2D_pp_Xicc.root --aod-writer-json OutputDir.json

touch ao2ds_to_merge.txt
echo AO2D.root > ao2ds_to_merge.txt
o2-aod-merger --input ao2ds_to_merge.txt --max-size 1000000000000000000000000000 --output TreeRecoAfter.root
rm ao2ds_to_merge.txt
rm AO2D.root
mv AnalysisResults.root AnalysisResultsAfter.root
