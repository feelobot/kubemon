```
kapacitor define cpu_alert \
  -tick test.tick \
  -type stream \
  -dbrp k8s.default 
kapacitor enable cpu_alert
kapacitor show cpu_alert
```

INFLUX:
`CREATE SUBSCRIPTION "kapacitor-376910544-gla96" on "k8s"."default" DESTINATIONS ALL 'udp://kapacitor.kube-system.svc.cluster.local:43309'`

