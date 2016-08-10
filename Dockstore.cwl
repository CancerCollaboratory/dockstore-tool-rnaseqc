#!/usr/bin/env cwl-runner

class: CommandLineTool

description: |
  Computes a series of quality control metrics for RNA-seq data.

  Usage:

  -bwa <arg>
  Path to BWA, which should be set if it's not in your path and BWArRNA is used.

  -BWArRNA <arg>
  Use an on the fly BWA alignment for estimating rRNA content. The value should be the rRNA reference fasta. If this flag is absent, rRNA estimation will be based upon the rRNA transcript intervals provided in the GTF (a faster but less robust method).

  -corr <arg>
  GCT file for expression correlation comparison. Note, that the values must be log normalized, and the identifiers must match those of the GTF file.

  -d <arg>
  Perform downsampling to the given number of reads.

  -e <arg>
  Change the definition of a transcripts end (5' or 3') to the given length. (50, 100, 200 are acceptable values; 200 is default)

  -expr <arg>
  Uses provided GCT file for expression values instead of on-the-fly RPKM calculation

  -gc <arg>
  File of transcript id <tab> gc content. Used for stratification.

  -n <arg>
  Number of top transcripts to use. Default is 1000.

  -noDoC
  Suppresses GATK Depth of Coverage calculations.

  -noReadCounting
  Suppresses read count-based metrics.

  -o <arg>
  Output directory (will be created if doesn't exist).

  -r <arg>
  Reference Genome in fasta format.

  -rRNA <arg>
  intervalFIle for rRNA loci (must end in .list). This is an alternative flag to the -BWArRNA flag.

  -s <arg>
  Sample File: tab-delimited description of samples and their bams. This file header is:
  Sample ID    Bam File    Notes
  When running on just one sample, this argument can be a string of the form
  "Sample ID|Bam File|Notes", where Bam File is the path to the input file.

  -singleEnd
  This BAM contains single end reads.

  -strat <arg>
  Stratification options: current supported option is 'gc'

  -strictMode <arg>
  When counting reads per exon or generating RPKMs, reads will be filtered out that have a mapping quality of zero, more than 6 non-reference bases or improper pairs.

  -t <arg>
  GTF File defining transcripts (must end in '.gtf').

  -transcriptDetails
  Provide an HTML report for each transcript.

  -ttype <arg>
  The column in GTF to use to look for rRNA transcript type. Mainly used for running on Ensembl GTF (specify "-ttype 2"). Otherwise, for spec-conforming GTF files, disregard.

  -rRNAdSampleTarget
  Downsamples to calculate rRNA rate more efficiently. Default is 1 million. Set to 0 to disable.

  -gcMargin
  Used in conjunction with '-strat gc' to specify the percent gc content to use as boundaries. E.g. .25 would set a lower cutoff of 25% and an upper cutoff of 75% (default is 0.375).

  -gld
  Gap Length Distribution: if flag is present, the distribution of gap lengths will be plotted.

  -gatkFlags
  Pass a string of quotes directly to the GATK (e.g. -gatkFlags "-DBQ 0" to set missing base qualities to zero). 

dct:creator:
  foaf:name: Andy Yang
  foaf:mbox: "mailto:ayang@oicr.on.ca"

cwlVersion: draft-3

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cancercollaboratory/dockstore-tool-rnaseqc"

inputs:
  - id: "#bwa"
    type: [ "null", File ]
    description: "Path to BWA, which should be set if it's not in your path and BWArRNA is used."
    inputBinding:
      position: 1
      prefix: "-bwa"

  - id: "#BWArRNA"
    type: [ "null", string ]
    description: "Use an on the fly BWA alignment for estimating rRNA content. The value should be the rRNA reference fasta. If this flag is absent, rRNA estimation will be based upon the rRNA transcript intervals provided in the GTF (a faster but less robust method)."
    inputBinding:
      position: 2
      prefix: "-BWArRNA"

  - id: "#corr"
    type: [ "null", string ]
    description: "GCT file for expression correlation comparison. Note, that the values must be log normalized, and the identifiers must match those of the GTF file."
    inputBinding:
      position: 3
      prefix: "-corr"

  - id: "#d"
    type: [ "null", string ]
    description: "Perform downsampling to the given number of reads."
    inputBinding:
      position: 4
      prefix: "-d"

  - id: "#e"
    type: [ "null", string ]
    description: "Change the definition of a transcripts end (5' or 3') to the given length. (50, 100, 200 are acceptable values; 200 is default)"
    inputBinding:
      position: 5
      prefix: "-e"

  - id: "#expr"
    type: [ "null", File ]
    description: "Uses provided GCT file for expression values instead of on-the-fly RPKM calculation"
    inputBinding:
      position: 6
      prefix: "-expr"

  - id: "#gc"
    type: [ "null", File ]
    description: "File of transcript id <tab> gc content. Used for sstratification."
    inputBinding:
      position: 7
      prefix: "-gc"

  - id: "#n"
    type: [ "null", int ]
    description: "Number of top transcripts to use. Default is 1000."
    inputBinding:
      position: 8
      prefix: "-n"

  - id: "#noDoC"
    type: [ "null", boolean ]
    description: "Suppresses GATK Depth of Coverage calculations."
    inputBinding:
      position: 8
      prefix: "-noDoC"

  - id: "#noReadCounting"
    type: [ "null", int ]
    description: "Suppresses read count-based metrics."
    inputBinding:
      position: 8
      prefix: "--noReadCounting"

  - id: "#o"
    type: [ "null", string ]
    description: "Output directory (will be created if doesn't exist)."
    inputBinding:
      position: 8
      prefix: "-o"

  - id: "#r"
    type: File 
    description: "Reference Genome in fasta format."
    inputBinding:
      position: 8
      prefix: "-r"
    secondaryFiles:
      - ".fai"
      - "^.dict"
      - "^.bam"
      - "^.bam.bai"


  - id: "#rRNA"
    type: [ "null", File ]
    description: "intervalFile for rRNA loci (must end in .list). This is an alternative flag to the -BWArRNA flag."
    inputBinding:
      position: 8
      prefix: "-rRNA"

  - id: "#s"
    type: string 
    description: "Sample File: tab-delimited description of samples and their bams"
    inputBinding:
      position: 8
      prefix: "-s"

  - id: "#singleEnd"
    type: [ "null", File ]
    description: "This BAM contains single end reads."
    inputBinding:
      position: 8
      prefix: "-singleEnd"

  - id: "#strat"
    type: [ "null", string ] 
    description: "Stratification options: current supported option is 'gc'"
    inputBinding:
      position: 8
      prefix: "-strat"

  - id: "#strictMode"
    type: [ "null", boolean ] 
    description: "When counting reads per exon or generating RPKMs, reads will be filtered out that have a mapping quality of zero, more than 6 non-reference bases or improper pairs."
    inputBinding:
      position: 8
      prefix: "-strictMode"

  - id: "#t"
    type: File 
    description: "iGTF File defining transcripts (must end in '.gtf')."
    inputBinding:
      position: 8
      prefix: "-t"

  - id: "#transcriptDetails"
    type: [ "null", File ] 
    description: "Provide an HTML report for each transcript."
    inputBinding:
      position: 8
      prefix: "-transcriptDetails"

  - id: "#ttype"
    type: [ "null", int ] 
    description: "The column in GTF to use to look for rRNA transcript type. Mainly used for running on Ensembl GTF (specify \"-ttype 2\"). Otherwise, for spec-conforming GTF files, disregard."
    inputBinding:
      position: 8
      prefix: "-ttype"

  - id: "#rRNAdSampleTarget"
    type: [ "null", int ] 
    description: "Downsamples to calculate rRNA rate more efficiently. Default is 1 million. Set to 0 to disable."
    inputBinding:
      position: 8
      prefix: "-rRNAdSampleTarget"

  - id: "#gcMargin"
    type: [ "null", double ] 
    description: "Used in conjunction with '-strat gc' to specify the percent gc content to use as boundaries. E.g. .25 would set a lower cutoff of 25% and an upper cutoff of 75% (default is 0.375)."
    inputBinding:
      position: 8
      prefix: "-gcMargin"

  - id: "#gld"
    type: [ "null", boolean ]
    description: "Gap Length Distribution: if flag is present, the distribution of gap lengths will be plotted."
    inputBinding:
      position: 8
      prefix: "-gld"

  - id: "#gatkFlags"
    type: [ "null", string ] 
    description: "Pass a string of quotes directly to the GATK (e.g. -gatkFlags \"-DBQ 0\" to set missing base qualities to zero)."
    inputBinding:
      position: 8
      prefix: "-gatkFlags"
 
  - id: "#out"
    type: string

outputs:
  - id: "#out"
    type: File
    outputBinding: 
      glob: $(inputs.out)
    description: "Required output sam or bam file"

baseCommand: ["wrapper.sh"]
