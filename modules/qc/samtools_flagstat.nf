process SAMTOOLS_FLAGSTAT {

    tag "SAMTOOLS_FLAGSTAT_${sampleId}${filePrefixString}_${userId}"

    publishDir "${publishDirectory}", mode: 'link', pattern: "${sampleId}${filePrefixString}.flagstat.output.txt"

    input:
        tuple path(bam), path(bai), val(sampleId), val(filePrefix), val(userId), val(publishDirectory)

    output:
        tuple val(filePrefix), path("${sampleId}${filePrefixString}.flagstat.output.txt"), emit: flagstatFile
        path "versions.yaml", emit: versions

    script:
        filePrefixString = ""
        if (filePrefix != null) {
            filePrefixString = filePrefix
        }
        else {
            filePrefixString = "${sampleId}"
        }

        """
        mkdir -p ${publishDirectory}

        samtools \
            flagstat \
            $bam \
            -@ ${task.cpus} \
            > ${sampleId}${filePrefixString}.flagstat.output.txt

        cat <<-END_VERSIONS > versions.yaml
        '${task.process}':
            samtools: \$(samtools --version | grep ^samtools | awk '{print \$2}')
        END_VERSIONS
        """

}