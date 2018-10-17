brew install elasticsearch
brew install logstash
brew install kibana

# List of pipelines to be loaded by Logstash



- pipeline.id: logback
  pipeline.workers: 1
  pipeline.batch.size: 100
  queue.type: memory
  config.string: >
    input {
      tcp {
        port => "9700"
        codec => "json"
      }
    }
    output {
      elasticsearch { 
        hosts => [ "localhost:9200" ]
        id => "logstash" 
        index => "logstash-%{+YYYY.MM.dd}"
      }
    }
