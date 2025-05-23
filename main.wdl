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
        memory: "200G"
        disks: "local-disk 20000 SSD"
        docker: container
    }
}

workflow pairtools_wf {
  input {
    File sorted = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/submissions/289e2f2d-9a58-4504-a692-c62e8c642f44/pairtools_wf/05d87378-5a10-491f-8a79-9c8951115163/call-pairtools_task/sorted.pairsam"
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
