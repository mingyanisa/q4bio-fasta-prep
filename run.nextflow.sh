#!/usr/bin/env bash
# DIR where the current script resides
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
profile=${1:-'test'} 
pipeline=${2:-'illumina'}
input_file=${3:-"${DIR}/data/test/illumina_input_0.tsv"}
nextflow -C "${DIR}/nextflow.config" run "${DIR}/workflow/${pipeline}.nf" -profile "${profile}" \
    --INPUT_DATA $input_file \
    --SARS2_FA "${DIR}/data/NC_045512.2.fa" \
    --SARS2_FA_FAI "${DIR}/data/NC_045512.2.fa.fai" 
nextflow clean -f -q
    # --OUTDIR "${pipeline_dir}/publishDir" \
    # --STOREDIR "${pipeline_dir}/storeDir" \
    # -w "${pipeline_dir}/workDir" \
    # -with-tower