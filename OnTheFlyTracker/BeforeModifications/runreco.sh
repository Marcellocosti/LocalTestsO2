#!/bin/bash

set -o pipefail
export OMP_NUM_THREADS=1
export TBB_NUM_THREADS=1

echo "Starting reconstruction in folder /home/mdicosta/LocalTestsO2/OnTheFlyTracker/BeforeModifications"

o2-analysis-onthefly-tracker -b --configuration json://config_reco.json |
o2-analysis-on-the-fly-detector-geometry-provider -b --configuration json://config_reco.json --aod-file AO2DGen.root --aod-writer-json OutputDir.json > log_reco.txt 2>&1

touch ao2ds_to_merge.txt
echo AO2D.root > ao2ds_to_merge.txt
o2-aod-merger --input ao2ds_to_merge.txt --max-size 1000000000000000000000000000 --output TreeReco20ps.root
rm ao2ds_to_merge.txt
mv AO2D.root AO2DReco20ps.root
mv AnalysisResults.root AnalysisResultsReco20ps.root
mv dpl-config.json dpl-config-reco-20-ps.json
