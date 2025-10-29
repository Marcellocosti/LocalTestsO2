#!/bin/bash

# First argument: SE or ME
MODE=$1
FILENAME=$2

if [[ -z "$MODE" ]]; then
    echo "Usage: $0 [SE|ME]"
    exit 1
fi

if [[ "$MODE" == "SE" ]]; then
    echo "Processing Same Event ..."
    FILENAME="input_SE.txt"
    CFG="./SE/CfgSE.json"
elif [[ "$MODE" == "ME" ]]; then
    echo "Processing Mixed Event ..."
    FILENAME="input_ME.txt"
    CFG="./ME/CfgME.json"
else
    echo "Usage: $0 [SE|ME]"
    exit 1
fi

CFG="./Cfg.json"
LOGFILE="log_${MODE}.txt"
HADHADCORR=0
JOBS=1
DELETE=1

COMMONCONFIGS="--aod-memory-rate-limit 1000000000 --configuration json://$CFG --shm-segment-size 7500000000"

# Get suffix from first AOD
AODNAME=$(head -n 1 "$FILENAME")
SUFFIX=$(basename "$AODNAME" | cut -d'_' -f2- | sed 's/.root//')

# Ensure file ends with newline
sed -i -e '$a\' "$FILENAME"

# Count AODs and split per job
NAO2D=$(grep -cve '^$' "$FILENAME")
NFILESPERJOB=$(( (NAO2D + JOBS - 1) / JOBS ))

AODCOUNTER=0
NFILES=0
declare -a INPUTNAMES=()

# Split AOD list into temp files
while IFS= read -r line; do
    if [[ $AODCOUNTER -eq 0 ]]; then
        INPUTNAMES+=("inputs_file_temp_${NFILES}.txt")
    fi
    echo "$line" >> "inputs_file_temp_${NFILES}.txt"
    AODCOUNTER=$((AODCOUNTER + 1))
    if [[ $AODCOUNTER -eq $NFILESPERJOB ]]; then
        AODCOUNTER=0
        NFILES=$((NFILES + 1))
    fi
done < "$FILENAME"

# Run jobs in parallel
parallel -j "$JOBS" --env COMMONCONFIGS '
    mkdir -p output_{#} &&
    cd output_{#} &&
    o2-analysis-hf-correlator-flow-charm-hadrons-reduced $COMMONCONFIGS \
        --aod-writer-json ../../../OutputDirector_task.json \
        --resources-monitoring 2 \
        --fairmq-ipc-prefix . \
        --aod-file @../{1} > log_{#}.txt 2>&1 &&
    cd ..
' ::: "${INPUTNAMES[@]}"

# Merge outputs
declare -a ANALYSISRESULTS=()
> ao2ds_to_merge.txt
for ((i=0;i<NFILES;i++)); do
    if [ -f "output_${i}/AO2D.root" ]; then
        echo "output_${i}/AO2D.root" >> ao2ds_to_merge.txt
        ANALYSISRESULTS+=("output_${i}/AnalysisResults.root")
    fi
done

if [ -s ao2ds_to_merge.txt ]; then
    o2-aod-merger --input ao2ds_to_merge.txt --max-size 10000000000000 --output "Tree${SUFFIX}.root"
    hadd -f "AnalysisResultsTask${SUFFIX}.root" "${ANALYSISRESULTS[@]}"
fi

rm -f inputs_file_temp_*.txt ao2ds_to_merge.txt
find . -name "localhost*" -delete

if [ "$DELETE" -eq 1 ]; then
    rm -rf output_*
fi
