//
// Check input samplesheet and reads channel
//

include { CHECK_SAMPLESHEET } from '../../modules/local/check_samplesheet'

workflow INPUT_CHECK {
    take:
    complete_samplesheet // file: /path/to/complete_samplesheet.csv

    main:
    CHECK_SAMPLESHEET(complete_samplesheet)

    CHECK_SAMPLESHEET.out
        .csv
        .splitCsv (header:true, sep:',')
        .map { create_fastq_channel(it) }
        .set { reads }

    emit:
    reads                                     // channel: [ val(meta), [ reads ] ]
    versions = CHECK_SAMPLESHEET.out.versions // channel: [ versions.yml ]

}

// Function to get list of [meta, [fastq]
def create_fastq_channel(LinkedHashMap row) {
    // create meta map
    def meta = [:]
        meta.id = row.sample

    // add paths of fastq files to the meta map

    def reads_meta = []
        reads_meta = [meta, [file(row.fastq)]]
    return reads_meta
}
