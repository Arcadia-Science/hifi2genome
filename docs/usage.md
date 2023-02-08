# Arcadia-Science/hifi2genome Usage

This page provides documentation on how to use the Arcadia-Science/hifi2genome workflow.

## Input specifications

This pipeline only process PacBio Hifi sequences in a single file in fastq format. The hifi2genome workflow takes a CSV samplesheet listing the sample names and paths to the fastq files as direct input. It does not take the path to the directory of the fastq files, you must list them in a samplesheet. The CSV must contain the columns:

`sample, fastq`
Neither the `sample` or `fastq` columns may contain spaces, and the `fastq` column contains the path to your PacBio Hifi reads in a single fastq file. The path to the fastq file can be the full path to a local file or URL. Valid examples look like the following:

```
sample,fastq
acineobacter_baumanii_AYE,s3://nf-test-datasets/hifi2genome/raw_reads/m64004_210929_143746.bc2001.fq.gz
bacillus_cereus_971,s3://nf-test-datasets/hifi2genome/raw_reads/m64004_210929_143746.bc2002.fq.gz
bacillus_subtilis_w23,s3://nf-test-datasets/hifi2genome/raw_reads/m64004_210929_143746.bc2003.fq.gz
burkholderia_cepacia_ucb717,s3://nf-test-datasets/hifi2genome/raw_reads/m64004_210929_143746.bc2004.fq.gz
```

The samplesheet must be a valid `.csv` file extension with 2 comma-separated columns names as above, and the sample IDs must be unique. The pipeline requires fastq files to end in `.fastq` or `.fq` or compressed `.fastq.gz` or `.fq.gz`.

## Running the pipeline

A typical command for running the pipeline looks like:
`nextflow run Arcadia-Science/hifi2genome --input samplesheet.csv --outdir <OUTDIR> -profile docker`

This will launch the pipeline with the `docker` configuration pipeline. See below for more information about profiles.
The pipeline will create the following files and directories in your working directory:

```
work                # Directory containing the nextflow working files
<OUTDIR>            # Finished results in specified location (defined with --outdir)
.nextflow_log       # Log file from Nextflow
# Other nextflow hidden files, eg. history of pipeline runs and old logs.
```

### Updating the pipeline

When you run the above command, Nextflow automatically pulls the pipeline code from GitHub and stores it as a cached version. When running the pipeline after this, it will always use the cached version if available - even if the pipeline has been updated since. To make sure you are running the latest version of the pipeline, regularly update the cached version with:
`nextflow pull Arcadia-Science/hifi2genome`

## Pipeline arguments

Below lists several arguments to configure core parts of how Nextflow is run and pipeline-specific arguments you can modify.

### Core Nextflow arguments

These options are part of Nextflow and use a single hyphen.

#### `-profile`

Use this parameter to choose a configuration profile. Profiles can give configuration presets for different compute environments. Several generic profiles are bundled with the pipeline which instruct the pieline to use software packaged using different methods (Docker, Singularity, Conda, etc.) When using Biocontainers, most of the software packaging methods pull Docker containers from quay.io except for Singularity which directly downloads Singularity images via https hosted by the Galaxy project and Conda which downloads and installs software locally from Bioconda.

We highly recommend the user of Docker or Singularity containers for full pipeline reproducibility, and have personally tested using Docker containers extensively within Arcadia. Other generic profiles besides the above listed are available, but they are untested and you can use at your own discretion.

If `-profile` is not specified, the pipeline will run locally and expect all software to be installed and available on the `PATH` which is not recommended.

- `docker`
  - A generic configuration profile to be used with Docker
- `singularity`
  - A generic configuration profile to be used with Singularity
- `conda`
  - A generic configuration profile to be used with Conda. Please only use Conda as a last resort, such as when it is not possible to run with Docker, Singularity, or the other preset configurations.
- `test`, `test_full`
  - Profiles with a complete configuration for automated testing. This includes links to test data and need no other parameters

#### `-resume`

Specify this when restarting the pipeline from a previously failed run, updated part of the pipeline, or additional samples. Nextflow will use cached results from any pipeline steps where the inputs are the same, continuing from where it got to previously. For the input to be considered the same, not only the names of the files must be identical but all the files' contents as well.

#### `-c`

Specify the path to a specific config file.

#### Running in the background

Nextflow handles job submissions and supervises running jobs. The Nextflow process must run until the pipeline is finished. The Nextflow `-bg` flag launches Nextflow in the background, detached from your terminal so that the workflow does not stop if you log out of your session. The logs are saved to a file. Alternatively you can use `screen`/`tmux` or a similar tool to create a detached session which you can log back into at a later time.

### Pipeline-specific arguments

The following are command-line arguments that are specific to the pipeline that can be changed. Defaults are described.

#### `--lineage`

The selected BUSCO lineage to run for resulting genome assemblies. This is a required parameter and is not set to a default setting. We highly recommonded NOT using the 'auto' lineage selection as in our experience this is highly resource intensive and is unnecessary for this workflow where the user likely already knows the desired lineage of the resulting assembly. See [https://busco.ezlab.org/list_of_lineages.html](https://busco.ezlab.org/list_of_lineages.html) for a full list of BUSCO lineages to choose from.

#### `--mode`

Mode for BUSCO to run in. By default and for most use cases this is and should be run in genome mode since the pipeline QCs the resulting genome assembly.
