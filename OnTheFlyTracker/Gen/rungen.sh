#!/bin/bash

set -o pipefail
export OMP_NUM_THREADS=1
export TBB_NUM_THREADS=1
o2-sim-dpl-eventgen --generator external --nEvents 100000 --aggregate-timeframe 50 --configFile $O2DPG_MC_CONFIG_ROOT/MC/config/ALICE3/ini/pythia8_pp.ini -b --configuration json://config_gen.json |
o2-sim-mctracks-to-aod --tf-offset 391403000000 -b --configuration json://config_gen.json --aod-writer-keep dangling > log_gen.txt 2>&1

# o2-sim-dpl-eventgen --generator external --nEvents 3000 --seed 1 --aggregate-timeframe 50 --configFile genBox.ini -b --configuration json://config_gen.json |
# o2-sim-mctracks-to-aod --tf-offset 391403000000  -b --configuration json://config_gen.json --aod-writer-keep dangling > log_gen.txt 2>&1

rm AO2DGen.root
mv AnalysisResults_trees.root AO2DGen.root
mv dpl-config.json dpl-config-gen.json
