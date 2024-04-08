The Node Exporter collects metrics and exposes them with HTTP endpoint where Prometheus can pull them from.

  namespace: monitoring
  labels:
    component: prometheus-agent

    I think the node exporter is just for scraping external ec2s