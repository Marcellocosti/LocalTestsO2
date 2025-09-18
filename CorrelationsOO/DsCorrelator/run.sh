OPTION="-b --configuration json://cfg.json"
LOGFILE="log.txt"

o2-analysis-hf-correlator-ds-hadrons $OPTION |
o2-analysis-hf-candidate-selector-ds-to-k-k-pi $OPTION |
o2-analysis-pid-tpc-base $OPTION |
o2-analysis-trackselection $OPTION |
o2-analysis-hf-candidate-creator-3prong $OPTION |
o2-analysis-hf-pid-creator $OPTION |
o2-analysis-pid-tpc $OPTION |
o2-analysis-pid-tof-full $OPTION |
o2-analysis-multcenttable $OPTION |
o2-analysis-event-selection-service $OPTION |
o2-analysis-lf-propagationservice $OPTION |
o2-analysis-pid-tof-base $OPTION |
o2-analysis-ft0-corrected-table $OPTION --aod-file @input_OO.txt --aod-parent-access-level 1 > $LOGFILE 2>&1