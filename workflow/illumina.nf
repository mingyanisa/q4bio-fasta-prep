
nextflow.enable.dsl = 2

params.STOREDIR = "./prepro/storeDir"
params.OUTDIR = "./prepro/results"

process stage_file {
    storeDir params.STOREDIR
    cpus 2
    memory '8 GB'
    //container 'quay.io/biocontainers/fastp:0.20.1--h8b12597_0'

    input:
    tuple val(run_accession), val(sample_accession), file(input_file)
    path(sars2_fasta)
    path(sars2_fasta_fai)

    output:
    file("${run_accession}_consensus.fasta.gz")

    script:
    """
    wget -t 0 -O ${run_accession}_consensus.fasta.gz \$(cat ${input_file})
    """
}
process concat_files {
    publishDir params.OUTDIR, mode: 'copy'

    cpus 2
    memory '8 GB' 
    input:
    path('*.fasta.gz')

    output:
    file("all.fasta.gz")

    script:
    """
    cat *fasta.gz > all.fasta.gz
    """
}
workflow {
    data = Channel
            .fromPath(params.INPUT_DATA)
            .splitCsv(header: true, sep: '\t')
            .map { row -> tuple(row.run_accession, row.sample_accession, row.url)}
    consensus_files = stage_file(data, params.SARS2_FA, params.SARS2_FA_FAI)
    concat_files(consensus_files.collect())
}