CREATE OR REPLACE VIEW prj-int-dev-covid19-nf-gls.sarscov2_metadata.nanopore_consensus_metadata
AS SELECT 
T1.analysis_accession,
T1.sample_accession,
T1.analysis_date,
T2.run_accession,
T2.instrument_platform AS platform,
T2.instrument_model AS MODEL,
T2.first_public,
T2.first_created,
T3.time_submitted
FROM
    `prj-int-dev-covid19-nf-gls.sarscov2_metadata.analysis_archived` T1
        LEFT JOIN
    `prj-int-dev-covid19-nf-gls.sarscov2_metadata.sra_index` T2
    ON
            T2.run_accession = T1.run_accession
        LEFT JOIN
    `prj-int-dev-covid19-nf-gls.sarscov2_metadata.submission_receipts` T3
    ON
            T3.analysis_accession = T1.analysis_accession
WHERE file_submitted LIKE '%_consensus.fasta.gz' AND T2.instrument_platform = "OXFORD_NANOPORE"
ORDER BY time_submitted;