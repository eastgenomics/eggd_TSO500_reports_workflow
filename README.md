# eggd_TSO500_reports_workflow

How to run it:

```
for sample in $(dx ls ${output_path}/analysis_folder/Logs_Intermediates/SampleAnalysisResults/*_SampleAnalysisResults.json); \
  do sample_prefix=$(echo $sample |sed 's/_SampleAnalysisResults.json//'); \
  echo $sample_prefix ;\
  dx run project-GF1V5v84b0bzgy6qJGx4qyjf:workflow-GF224Xj4b0bp4kgk4QQ323gk \
  -istage-GF22j384b0bpYgYB5fjkk34X.bam=$(dx find data --name "${sample_prefix}*.bam" --path ${output_path}/analysis_folder/Logs_Intermediates/StitchedRealigned/ --brief) \
  -istage-GF22j384b0bpYgYB5fjkk34X.index=$(dx find data --name "${sample_prefix}*.bai" --path ${output_path}/analysis_folder/Logs_Intermediates/StitchedRealigned/ --brief) \
  -istage-GF22GJQ4b0bjFFxG4pbgFy5V.name=${sample_prefix} \
  -istage-GF25f384b0bVZkJ2P46f79xy.gvcf=$(dx find data --name "${sample_prefix}*.genome.vcf" --path ${output_path}/analysis_folder/Results/ --brief) \
  --destination="${output_path}/reports_workflow_1" -y; \
done
```

Testing directory:
https://platform.dnanexus.com/projects/GF1V5v84b0bzgy6qJGx4qyjf/data/