#!/bin/bash

NEVENTS="200000"
CORES=1
OPTION="-b --configuration json://conf_gen.json --pipeline generator-task:$CORES, mctracks-to-aod:$CORES"
CONFIG_FILE="--configFile $O2DPG_ROOT/MC/config/ALICE3/ini/xi_pp.ini"

export ALIEN_PROC_ID=12

o2-sim-dpl-eventgen --generator external --nEvents ${NEVENTS} ${OPTION} ${CONFIG_FILE} --aggregate-timeframe 300 \
| o2-sim-mctracks-to-aod ${OPTION} --aod-writer-keep dangling

mv AnalysisResults_trees.root AO2D_pp_Xicc.root