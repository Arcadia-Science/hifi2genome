# Arcadia-Science/hifi2genome

<!-- TODO: Update these based on your pipeline's supported platforms -->

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A521.10.3-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Nextflow Tower](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Nextflow%20Tower-%234256e7)](https://tower.nf/launch?pipeline=https://github.com/Arcadia-Science/hifi2genome)

**Arcadia-Science/hifi2genome** is a workflow for assembling PacBio Hifi reads into single genomes and performing QC stats on the assembled genomes.

The pipeline is built using [Nextflow](https://www.nextflow.io), a workflow tool to run tasks across multiple compute infrastructures in a very portable manner. It uses Docker/Singularity containers making installation trivial and results highly reproducible. The [Nextflow DSL2](https://www.nextflow.io/docs/latest/dsl2.html) implementation of this pipeline uses one container per process which makes it much easier to maintain and update software dependencies. Where possible, these processes have been submitted to and installed from [nf-core/modules](https://github.com/nf-core/modules) in order to make them available to all nf-core pipelines, and to everyone within the Nextflow community!

## Pipeline summary

<!-- TODO: Fill in short bullet-pointed list of the default steps in the pipeline -->

## Quick start

<!-- TODO: Fill in short bullet-pointed list of the default steps to get the pipeline up and running -->

## Full documentation

<!-- TODO: Fill in this section with how to fully use the pipeline, what the inputs are and what the outputs look like. If this section ends up being super long, feel free to create a new docs/ directory and add details there. -->

## Contributions and support

<!-- TODO: Add CONTRIBUTING.MD that is specific to Arcadia Science -->

## Citations

<!-- TODO: Add bibliography of tools and data used in your pipeline -->

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.
