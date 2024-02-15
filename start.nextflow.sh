#!/usr/bin/env bash
# DIR where the current script resides
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
skip=${1:-'0'} 
batch_size=${2:-'1000'}
snapshot_date=${3:-'2024-02-12'}   
project_id='prj-int-dev-covid19-nf-gls'
dataset_name='sarscov2_metadata'
platform=illumina
table_name="${platform}_consensus_metadata"
input_name="${platform}_input"
batch_index=0
input_dir="${DIR}/data/${snapshot_date}"; mkdir -p "${input_dir}"
# TODO: reverse chronological order

sql="SELECT * FROM ${project_id}.${dataset_name}.${table_name} LIMIT ${batch_size}"
# bq --project_id="${project_id}" --format=csv query --use_legacy_sql=false --max_rows="${batch_size}" "${sql}" \
#     | awk 'BEGIN{ FS=","; OFS="\t" }{$1=$1; print $0 }' > "${input_dir}/${table_name}_${batch_index}.tsv"
python ${DIR}/bin/get_url.py "${input_dir}/${table_name}_${batch_index}.tsv" "${input_dir}/${input_name}_${batch_index}.tsv"
${DIR}/run.nextflow.sh test illumina 
# $input_dir/${input_name}.tsv