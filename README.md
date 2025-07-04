# eggd_TSO500_reports_workflow (DNAnexus Platform Workflow)

DNAnexus workflow to generate coverage reports and Excel workbooks for TSO500 solid cancer service.

---

![Image of workflow](images/tso500_reports_workflow.png)

## What version of apps are used in this workflow?

|  App 	| Version  	|
|---	|---	|
|CNVkit | [2.0.3](https://platform.dnanexus.com/app/app-GxGqp980Xg5JY3K442z7Gg72)|
|eggd_mosdepth           |[1.1.0](https://github.com/eastgenomics/eggd_mosdepth/releases/tag/v1.1.0)|
|eggd_athena             |[1.6.0](https://github.com/eastgenomics/eggd_athena/releases/tag/v1.6.0)|
|eggd_vcf_rescue |[1.1.0](https://github.com/eastgenomics/eggd_vcf_rescue/releases/tag/v1.1.0)|
|eggd_vep           |[1.3.0](https://github.com/eastgenomics/eggd_vep/releases/tag/v1.3.0)|
|eggd_add_MANE_annotation       |[1.1.0](https://github.com/eastgenomics/eggd_add_MANE_annotation/releases/tag/v1.1.0)|
|eggd_plot_variant_baf | [2.0.1](https://github.com/eastgenomics/eggd_plot_variant_baf/releases/tag/v2.0.1)|
|eggd_generate_variant_workbook |[2.10.0](https://github.com/eastgenomics/eggd_generate_variant_workbook/releases/tag/v2.10.0)|

## What version of files are used in this workflow?

Inputs which are static files are defined in the current version of the Conductor Helios config at https://github.com/eastgenomics/eggd_conductor_configs/tree/main/assay_configs/TSO500.
