OPTION="-b --configuration json://conf_reco.json"

o2-analysis-alice3-multicharm ${OPTION} |\
o2-analysis-on-the-fly-detector-geometry-provider ${OPTION} |\
o2-analysis-alice3-decaypreselector ${OPTION} |\
o2-analysis-alice3-multicharm-finder ${OPTION} |\
o2-analysis-onthefly-tofpid ${OPTION} |\
o2-analysis-onthefly-tracker ${OPTION} --shm-segment-size 6442450944 --aod-file AO2D_pp_Xicc.root
