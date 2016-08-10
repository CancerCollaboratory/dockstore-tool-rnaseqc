#!/usr/bin/env bash
# cp bam file into place (weird, I know)
cp /var/lib/cwl/*/*.bam .
cp /var/lib/cwl/*/*.bam.bai .

# Call tool with parameters
java $JAVA_OPTS -jar /opt/rnaseqc/RNA-SeQC_v1.1.8.jar "$@"
