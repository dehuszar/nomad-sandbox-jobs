job "hello-world" {
  datacenters = ["home"]
  type        = "batch"

  parameterized {
    payload       = "forbidden"
    meta_required = ["start_time"]
    meta_optional = ["message"]
  }

  group "hellos" {
    service {
      name = "hello-world"
      tags = ["global", "hellos"]
    }

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    task "runner" {
      driver = "docker"

      artifact {
        source      = "https://github.com/dehuszar/nomad-sandbox-jobs/load-balancing-test/hello-world.js"
        destination = "local/hello-world.js"
      }

      config {
        image   = "node:lts-alpine"
        command = "node hello-world.js"
      }
    }
  }
}
