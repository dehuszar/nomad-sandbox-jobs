job "hello-world-docker" {
  datacenters = ["home"]
  type        = "batch"

  parameterized {
    payload       = "forbidden"
    meta_required = ["start_time"]
    meta_optional = ["subject"]
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

      config {
        image   = "node:lts-alpine"
        command = "node"
        args = [
          "local/hello-world.js",
          env["NOMAD_META_start_time"],
          env["NOMAD_META_subject"]
        ]
      }

      template {
        data = <<EOF
const startTime = process.argv[2];
const subject = process.argv[3];

function hello ( startTime, subject ) {
  const now = new Date();
  const started = new Date(startTime);
  const runtime = (now - started)/1000;
  const subOrDefault = subject === "" ? "World" : subject;
  console.log(`Hello ${subOrDefault}.  This message took ${runtime}s`);
}

hello(startTime, subject);
      EOF

        destination = "local/hello-world.js"
      }
    }
  }
}
