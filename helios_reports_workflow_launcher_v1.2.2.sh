#!/bin/bash

output_path="$1"
destination="${output_path%%\/eggd_tso500}"

# define the REPORTS WORKFLOW VERSION to use (currently v1.4.2)
workflow_id="workflow-GjKQqBj4yfK1yYzXXbypQyZ7"
workflow_name=$(dx describe --json "$workflow_id" | jq -r '.name')

# create a list of the sample ids from the samplesheet, print the number of samples
samplesheet=$(dx find data --name "SampleSheet.csv"  --path "${output_path}/demultiplexOutput/" --norecurse --brief)
sample_list=$(sed -e '1,/Sample_ID/ d' <(dx cat "$samplesheet")  | cut -d','  -f1)

sample_count=$(for f in $sample_list; do echo "$f"; done | wc -l)
echo "${sample_count} samples identified"

# launch the reports workflow for each sample
for sample_prefix in $sample_list; do

  # handles both old and new samplenames by adding "-" to old samples only to handle repeats
  if [[ $sample_prefix == M* || $sample_prefix == H* ]]; then 
    sample_prefix="${sample_prefix}-"
  fi  

  # check if sample is DNA or RNA depending on where the bam file lives
  isBAMdna=$(dx find data --name "${sample_prefix}*.bam" --path "${output_path}/scatter/StitchedRealigned/" --brief)

  # if 'isBAMdna' has a value to the variable run the first command which looks in ${output_path}/scatter/StitchedRealigned/
  # else if empty then we assume it is RNA and check in ${output_path}/scatter/RnaAlignment/

  if [[ $isBAMdna ]]; then
    echo -e "\nStarting workflow for DNA sample ${sample_prefix}"
    dx run $workflow_id \
    $(dx find data --name "${sample_prefix}*.fastq.gz" --path ${output_path}/demultiplexOutput/Logs_Intermediates/FastqGeneration --brief | sed 's/^/-istage-GFQZjB84b0bxz4Yg1y3ygKJZ.fastqs=/') \
    -istage-GF22j384b0bpYgYB5fjkk34X.bam=$(dx find data --name "${sample_prefix}*.bam" --path ${output_path}/scatter/StitchedRealigned/ --brief) \
    -istage-GF22j384b0bpYgYB5fjkk34X.index=$(dx find data --name "${sample_prefix}*.bai" --path ${output_path}/scatter/StitchedRealigned/ --brief) \
    -istage-GF22GJQ4b0bjFFxG4pbgFy5V.name=${sample_prefix%-} \
    -istage-GF25f384b0bVZkJ2P46f79xy.gvcf=$(dx find data --name "${sample_prefix}*.genome.vcf" --path ${output_path}/gather/Results/ --brief) \
    -istage-GF25ZXj4b0bxQzBjG9jJ1q77.additional_files=$(dx find data --name "${sample_prefix}*_CombinedVariantOutput.tsv" --path ${output_path}/gather/Results/ --brief) \
    -istage-GF25ZXj4b0bxQzBjG9jJ1q77.additional_files=$(dx find data --name "MetricsOutput.tsv" --path ${output_path}/ --brief --norecurse) \
    --name "${workflow_name}_${sample_prefix%-}" \
    --destination="${destination}/$workflow_name" --brief -y ;
    echo "Output: ${destination}/$workflow_name"

  else
    echo -e "\nStarting workflow for RNA sample ${sample_prefix}"
    dx run $workflow_id \
    $(dx find data --name "${sample_prefix}*.fastq.gz" --path ${output_path}/demultiplexOutput/Logs_Intermediates/FastqGeneration/ --brief | sed 's/^/-istage-GFQZjB84b0bxz4Yg1y3ygKJZ.fastqs=/') \
    -istage-GF22j384b0bpYgYB5fjkk34X.bam=$(dx find data --name "${sample_prefix}*.bam" --path ${output_path}/scatter/RnaAlignment/ --brief) \
    -istage-GF22j384b0bpYgYB5fjkk34X.index=$(dx find data --name "${sample_prefix}*.bai" --path ${output_path}/scatter/RnaAlignment/ --brief) \
    -istage-GF22GJQ4b0bjFFxG4pbgFy5V.name=${sample_prefix%-} \
    -istage-GF25f384b0bVZkJ2P46f79xy.gvcf=$(dx find data --name "${sample_prefix}*_SpliceVariants.vcf" --path ${output_path}/gather/Results/ --brief) \
    -istage-GF25ZXj4b0bxQzBjG9jJ1q77.additional_files=$(dx find data --name "${sample_prefix}*_CombinedVariantOutput.tsv" --path ${output_path}/gather/Results/ --brief) \
    -istage-GF25ZXj4b0bxQzBjG9jJ1q77.additional_files=$(dx find data --name "MetricsOutput.tsv" --path ${output_path}/ --brief --norecurse) \
    --name "${workflow_name}_${sample_prefix%-}" \
    --destination="${destination}/$workflow_name" --brief -y ;
    echo "Output: ${destination}/$workflow_name"
  fi
done
