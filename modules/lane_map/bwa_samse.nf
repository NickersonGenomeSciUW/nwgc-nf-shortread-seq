process BWA_SAMSE {

    tag "BWA_SAMSE_${flowCell}_${lane}_${library}_${userId}"
    
    input:
        tuple path(fastq1), val(flowCell), val(lane), val(library), val(userId), val(readGroup), val(publishDirectory)
        val referenceGenome


    output:
        tuple path("${flowCell}.${lane}.${library}.matefixed.sorted.bam"), val(flowCell), val(lane), val(library), val(userId), val(publishDirectory), emit: samse

    script:
        """
        bwa samse \
				${referenceGenome} \
				-r ${readGroup} \
		    	<(bwa aln -t ${task.cpus} ${referenceGenome} -0 ${fastq1}) \
		    	${fastq1} | \
        samblaster --addMateTags -a | \
        samtools view -Sbhu - | \
        sambamba sort \
                -t ${task.cpus} \
                -o ${flowCell}.${lane}.${library}.matefixed.sorted.bam \
                /dev/stdin
        """
}