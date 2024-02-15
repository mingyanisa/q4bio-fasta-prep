import pandas as pd
# from google.cloud import bigquery 
# from dotenv import load_dotenv
import sys
import requests

# load_dotenv()

 
input_file =str(sys.argv[1]) #'./data/2024-02-12/illumina_consensus_metadata_0.tsv' 
output_file =str(sys.argv[2])
output_file=input_file.replace('consensus_metadata','input')
def get_url(analysis_accession,run_accession):
    return f'ftp://ftp.sra.ebi.ac.uk/vol1/{analysis_accession[:6]}/{analysis_accession}/{run_accession}_consensus.fasta.gz'

df=pd.read_csv(input_file, sep='\t')
df['url']=df.apply(lambda x:get_url(x.analysis_accession,x.run_accession), axis=1)
df.to_csv(output_file,sep='\t', index=False)