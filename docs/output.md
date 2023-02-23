# Arcadia-Science/hifi2genome Output

This page describes the output files and report produced by the pipeline. The directories listed below are created in the results directory after the pipeline has finished.

## Pipeline Overview

This pipeline takes in PacBio Hifi reads sequenced from a single organism, assembles them with `Flye`, assesses the assembly with `QUAST`, performs lineage-specific QC with `BUSCO`, and maps the reads back to the resulting assembly with `minimap2`. The pipeline then reports the QC stats fro `QUAST` and `BUSCO` with `MultiQC`.

### Assembly

Assembly is performed with `Flye` and outputs the assembled scaffolds or single contig in `.fasta` format. Resulting outputs also include the assembly graph in `.gfa` and `.gv` formats, info on the assembly in `*.assembly_info.txt`, parameters used in `*.params.json` and the log output.

### QUAST Assembly QC

For each assembly, QC stats are reported from `QUAST`. Due to input/output requirements by `QUAST` all genome assemblies resulting from the pipeline must be ran in a single `QUAST` process and the statistics for each assembly are in a single `report.tsv` file. This contains information such as N50, L50, number of contigs longer than a certain length, etc. Within the `QUAST` output directory, basic stats and plots are given for the assemblies.

### BUSCO QC

For each assembly, lineage specific QC stats are reported. By default the `auto` option is ran where the best fitting lineage is selected. For each assembly, a `*.batch_summary.txt` and `short_summary` file are produced. The former gives a general summary of the `BUSCO `results where the `short_summary` file gives more specifics on number of BUSCOs found, number that were searched against, and the versions of the dependencies.

### Minimap2 mapping

The pipeline maps the original reads back to the corresponding resulting assembly to facilitate downstream manual coverage checking with a program such as IGV. In the `minimap2` directory are the reference index created by `minimap2` for each assembly and the reads mapped back to the reference index in BAM format. The BAM file has been sorted and indexed.

### Samtools stats

Mapping statistics such as % of reads mapping to the assembly and alignment metrics are produced using `samtools stats` and displayed in the MultiQC report.

### Pipeline overview

The `pipeline_overview` directory provides information about how the pipeline was run.

### Custom

The `custom` directory contains the `software_versions.yml` file that gives a list of the versions of each piece of software used in the pipeline.
