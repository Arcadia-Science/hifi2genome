process MINIMAP2_ALIGN {
    tag "$index_meta.id"
    label 'process_medium'

    // Note: the versions here need to match the versions used in the mulled container below and minimap2/index
    conda "bioconda::minimap2=2.24 bioconda::samtools=1.14"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mulled-v2-66534bcbb7031a148b13e2ad42583020b9cd25c4:1679e915ddb9d6b4abda91880c4b48857d471bd8-0' :
        'quay.io/biocontainers/mulled-v2-66534bcbb7031a148b13e2ad42583020b9cd25c4:1679e915ddb9d6b4abda91880c4b48857d471bd8-0' }"

    // modified input requirements, explicitly emits the BAM file from the SAM output piped to samtools to sort, don't allow for PAF option because unneeded
    // fixes samtools piping to go through view, sort, and index to a final BAM file

    input:
    tuple val(index_meta), path(index), val(reads_meta), path(reads)

    output:
    tuple val(index_meta), path("*.sorted.bam"), path("*.bam.bai")     , emit: sorted_indexed_bam
    path "versions.yml"                                                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${index_meta.id}"

    """
    minimap2 \\
        $args \\
        -t $task.cpus \\
        $index \\
        $reads | \\
        samtools view -@ $task.cpus -bS | \\
        samtools sort -@ $task.cpus -o ${prefix}.sorted.bam
    samtools index ${prefix}.sorted.bam ${prefix}.bam.bai


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        minimap2: \$(minimap2 --version 2>&1)
    END_VERSIONS
    """
}
