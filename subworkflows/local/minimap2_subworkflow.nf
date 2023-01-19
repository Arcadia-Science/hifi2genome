//
// Minimap2 subworkflow to index an assembly and map reads to the assembly
//

include { MINIMAP2_INDEX } from '../../modules/nf-core/minimap2/index'
include { MINIMAP2_ALIGN } from '../../modules/nf-core/minimap2/align'

workflow MINIMAP2_SUBWORKFLOW {
    take:
    assembly
    reads

    main:
    ch_versions = Channel.empty()

    // build index
    MINIMAP2_INDEX(assembly)
    ch_versions = ch_versions.mix(MINIMAP2_INDEX.out.versions)
    ch_index = MINIMAP2_INDEX.out.index

    // align reads to index
    MINIMAP2_ALIGN(reads, ch_index, "true", "false", "true")
    ch_align_bam = MINIMAP2_ALIGN.out.bam

    emit:
    ch_index
    ch_versions
    ch_align_bam

}