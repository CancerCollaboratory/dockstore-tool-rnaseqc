#!/usr/bin/env cwl-runner

class: CommandLineTool

description: |
  ***********************************************************************

dct:creator:
  foaf:name: Andy Yang
  foaf:mbox: "mailto:ayang@oicr.on.ca"

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cancercollaboratory/dockstore-tool-rnaseqc"
  - { import: node-engine.cwl }

inputs:
  - id: "#in"
    type: File
    description: "Required input sam or bam file"
    inputBinding:
      position: 1

outputs:
  - id: "#out"
    type: File
    description: "Required output sam or bam file"
    outputBinding:
      glob:
        engine: cwl:JsonPointer
        script: /job/output1

baseCommand: ["sam-filter"]
