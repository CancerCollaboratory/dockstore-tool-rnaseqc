#!/usr/bin/env cwl-runner

class: CommandLineTool

dct:creator:
  foaf:name: Andy Yang
  foaf:mbox: mailto:ayang@oicr.on.ca
cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: quay.io/cancercollaboratory/dockstore-tool-rnaseqc
inputs:
  rRNA:
    type: File?
    inputBinding:
      position: 8
      prefix: -rRNA
    doc: intervalFile for rRNA loci (must end in .list). This is an alternative flag
      to the -BWArRNA flag.
  strat:
    type: string?
    inputBinding:
      position: 8
      prefix: -strat
    doc: 'Stratification options: current supported option is ''gc'''
  strictMode:
    type: boolean?
    inputBinding:
      position: 8
      prefix: -strictMode
    doc: When counting reads per exon or generating RPKMs, reads will be filtered
      out that have a mapping quality of zero, more than 6 non-reference bases or
      improper pairs.
  gc:
    type: File?
    inputBinding:
      position: 7
      prefix: -gc
    doc: File of transcript id <tab> gc content. Used for sstratification.
  out: string
  gatkFlags:
    type: string?
    inputBinding:
      position: 8
      prefix: -gatkFlags
    doc: Pass a string of quotes directly to the GATK (e.g. -gatkFlags "-DBQ 0" to
      set missing base qualities to zero).
  transcriptDetails:
    type: File?
    inputBinding:
      position: 8
      prefix: -transcriptDetails
    doc: Provide an HTML report for each transcript.
  noReadCounting:
    type: int?
    inputBinding:
      position: 8
      prefix: --noReadCounting
    doc: Suppresses read count-based metrics.
  ttype:
    type: int?
    inputBinding:
      position: 8
      prefix: -ttype
    doc: The column in GTF to use to look for rRNA transcript type. Mainly used for
      running on Ensembl GTF (specify "-ttype 2"). Otherwise, for spec-conforming
      GTF files, disregard.
  rRNAdSampleTarget:
    type: int?
    inputBinding:
      position: 8
      prefix: -rRNAdSampleTarget
    doc: Downsamples to calculate rRNA rate more efficiently. Default is 1 million.
      Set to 0 to disable.
  noDoC:
    type: boolean?
    inputBinding:
      position: 8
      prefix: -noDoC
    doc: Suppresses GATK Depth of Coverage calculations.
  bwa:
    type: File?
    inputBinding:
      position: 1
      prefix: -bwa
    doc: Path to BWA, which should be set if it's not in your path and BWArRNA is
      used.
  corr:
    type: string?
    inputBinding:
      position: 3
      prefix: -corr
    doc: GCT file for expression correlation comparison. Note, that the values must
      be log normalized, and the identifiers must match those of the GTF file.
  BWArRNA:
    type: string?
    inputBinding:
      position: 2
      prefix: -BWArRNA
    doc: Use an on the fly BWA alignment for estimating rRNA content. The value should
      be the rRNA reference fasta. If this flag is absent, rRNA estimation will be
      based upon the rRNA transcript intervals provided in the GTF (a faster but less
      robust method).
  singleEnd:
    type: File?
    inputBinding:
      position: 8
      prefix: -singleEnd
    doc: This BAM contains single end reads.
  e:
    type: string?
    inputBinding:
      position: 5
      prefix: -e
    doc: Change the definition of a transcripts end (5' or 3') to the given length.
      (50, 100, 200 are acceptable values; 200 is default)
  d:
    type: string?
    inputBinding:
      position: 4
      prefix: -d
    doc: Perform downsampling to the given number of reads.
  expr:
    type: File?
    inputBinding:
      position: 6
      prefix: -expr
    doc: Uses provided GCT file for expression values instead of on-the-fly RPKM calculation
  gld:
    type: boolean?
    inputBinding:
      position: 8
      prefix: -gld
    doc: 'Gap Length Distribution: if flag is present, the distribution of gap lengths
      will be plotted.'
  o:
    type: string?
    inputBinding:
      position: 8
      prefix: -o
    doc: Output directory (will be created if doesn't exist).
  n:
    type: int?
    inputBinding:
      position: 8
      prefix: -n
    doc: Number of top transcripts to use. Default is 1000.
  s:
    type: string
    inputBinding:
      position: 8
      prefix: -s
    doc: 'Sample File: tab-delimited description of samples and their bams'
  r:
    type: File
    inputBinding:
      position: 8
      prefix: -r
    secondaryFiles:
    - .fai
    - ^.dict
    - ^.bam
    - ^.bam.bai
    doc: Reference Genome in fasta format.
  gcMargin:
    type: double?
    inputBinding:
      position: 8
      prefix: -gcMargin
    doc: Used in conjunction with '-strat gc' to specify the percent gc content to
      use as boundaries. E.g. .25 would set a lower cutoff of 25% and an upper cutoff
      of 75% (default is 0.375).
  t:
    type: File
    inputBinding:
      position: 8
      prefix: -t
    doc: iGTF File defining transcripts (must end in '.gtf').
outputs:
  out:
    type: File
    outputBinding:
      glob: $(inputs.out)
    doc: Required output sam or bam file
baseCommand: [wrapper.sh]
doc: "Computes a series of quality control metrics for RNA-seq data.\n\nUsage:\n\n\
  -bwa <arg>\nPath to BWA, which should be set if it's not in your path and BWArRNA\
  \ is used.\n\n-BWArRNA <arg>\nUse an on the fly BWA alignment for estimating rRNA\
  \ content. The value should be the rRNA reference fasta. If this flag is absent,\
  \ rRNA estimation will be based upon the rRNA transcript intervals provided in the\
  \ GTF (a faster but less robust method).\n\n-corr <arg>\nGCT file for expression\
  \ correlation comparison. Note, that the values must be log normalized, and the\
  \ identifiers must match those of the GTF file.\n\n-d <arg>\nPerform downsampling\
  \ to the given number of reads.\n\n-e <arg>\nChange the definition of a transcripts\
  \ end (5' or 3') to the given length. (50, 100, 200 are acceptable values; 200 is\
  \ default)\n\n-expr <arg>\nUses provided GCT file for expression values instead\
  \ of on-the-fly RPKM calculation\n\n-gc <arg>\nFile of transcript id <tab> gc content.\
  \ Used for stratification.\n\n-n <arg>\nNumber of top transcripts to use. Default\
  \ is 1000.\n\n-noDoC\nSuppresses GATK Depth of Coverage calculations.\n\n-noReadCounting\n\
  Suppresses read count-based metrics.\n\n-o <arg>\nOutput directory (will be created\
  \ if doesn't exist).\n\n-r <arg>\nReference Genome in fasta format.\n\n-rRNA <arg>\n\
  intervalFIle for rRNA loci (must end in .list). This is an alternative flag to the\
  \ -BWArRNA flag.\n\n-s <arg>\nSample File: tab-delimited description of samples\
  \ and their bams. This file header is:\nSample ID    Bam File    Notes\nWhen running\
  \ on just one sample, this argument can be a string of the form\n\"Sample ID|Bam\
  \ File|Notes\", where Bam File is the path to the input file.\n\n-singleEnd\nThis\
  \ BAM contains single end reads.\n\n-strat <arg>\nStratification options: current\
  \ supported option is 'gc'\n\n-strictMode <arg>\nWhen counting reads per exon or\
  \ generating RPKMs, reads will be filtered out that have a mapping quality of zero,\
  \ more than 6 non-reference bases or improper pairs.\n\n-t <arg>\nGTF File defining\
  \ transcripts (must end in '.gtf').\n\n-transcriptDetails\nProvide an HTML report\
  \ for each transcript.\n\n-ttype <arg>\nThe column in GTF to use to look for rRNA\
  \ transcript type. Mainly used for running on Ensembl GTF (specify \"-ttype 2\"\
  ). Otherwise, for spec-conforming GTF files, disregard.\n\n-rRNAdSampleTarget\n\
  Downsamples to calculate rRNA rate more efficiently. Default is 1 million. Set to\
  \ 0 to disable.\n\n-gcMargin\nUsed in conjunction with '-strat gc' to specify the\
  \ percent gc content to use as boundaries. E.g. .25 would set a lower cutoff of\
  \ 25% and an upper cutoff of 75% (default is 0.375).\n\n-gld\nGap Length Distribution:\
  \ if flag is present, the distribution of gap lengths will be plotted.\n\n-gatkFlags\n\
  Pass a string of quotes directly to the GATK (e.g. -gatkFlags \"-DBQ 0\" to set\
  \ missing base qualities to zero). \n"

