version 1.0

task pairtools_task {
    input {
        File sorted
        String container
    }

    command <<<
        pairtools dedup --nproc-in 32 --nproc-out 32 --mark-dups --output-stats stats.txt --output dedup.pairsam ~{sorted}
    >>>

    output {
        File dedup = "dedup.pairsam"
        File stats = "stats.txt"
    }

    runtime {
        cpu: 32
        memory: "150G"
        disks: "local-disk 10000 SSD"
        docker: container
    }
}

workflow pairtools_wf {
  input {
    File sorted = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/submissions/625e9f72-c6fe-4435-a731-771f181ce451/pairtools_wf/2d58b427-0a6e-4eee-972b-9f722edcd850/call-pairtools_task/sorted.pairsam"
    String container = "quay.io/biocontainers/pairtools:1.1.3--py311h534e829_0"
  }

  call pairtools_task {
    input:
      sorted = sorted,
      container = container
  }

  output {
      File dedup = pairtools_task.dedup
      File stats = pairtools_task.stats
  }
}
