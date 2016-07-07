```
kapacitor define cpu_alert -tick test.tick \
  -type stream \
  -tick test.tick \
  -dbrp k8s.default 
```
kapacitor enable cpu_alert
kapacitor show cpu_alert
