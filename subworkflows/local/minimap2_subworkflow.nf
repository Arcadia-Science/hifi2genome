//
// Minimap2 subworkflow to index an assembly and map reads to the assembly
//

include { MINIMAP2_INDEX } from '../../modules/nf-core/minimap2/index'
include { MINIMAP2_ALIGN } from '../../modules/local/nf-core-modified/minimap2/align'
include { SAMTOOLS_STATS } from '../../modules/nf-core/samtools/stats/main'

workflow MINIMAP2_SUBWORKFLOW {
    take:
    assembly // tuple val(meta), path(fasta)
    reads    // tuple val(meta), path(reads)

    main:
    ch_versions = Channel.empty()

    // build index
    MINIMAP2_INDEX(assembly)
    ch_versions = ch_versions.mix(MINIMAP2_INDEX.out.versions)
    ch_index = MINIMAP2_INDEX.out.index

    // match index to the corresponding reads
    ch_reads = reads.map{meta, reads -> [meta.id, meta,reads]}
    ch_mapping = ch_index
        .map{meta, index -> [meta.id, meta, index]}
        .combine(ch_reads, by:0)
        .map{id, index_meta, index, reads_meta, reads -> [index_meta, index, reads_meta, reads]}

    // align reads to index
    MINIMAP2_ALIGN(ch_mapping)
    ch_align_bam = MINIMAP2_ALIGN.out.sorted_indexed_bam

    // get samtools stats
    SAMTOOLS_STATS(ch_align_bam, assembly)
    ch_stats = SAMTOOLS_STATS.out.stats
    ch_versions = ch_versions.mix(SAMTOOLS_STATS.out.versions)

    emit:
    ch_index
    ch_align_bam
    ch_stats
    versions = ch_versions

}
