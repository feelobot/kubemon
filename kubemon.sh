#!/bin/bash
echo "Launching influxdb..."
kubectl create -f deploy/influxdb-deployment.yaml 1>/dev/null 2>&1
kubectl create -f deploy/influxdb-service.yaml 1>/dev/null 2>&1
kubectl create -f deploy/influxdb-ingress.yaml 1>/dev/null 2>&1
echo "Waiting for influxdb..."
sleep 5
echo "Starting up Grafana & Heapster..."
kubectl create -f deploy/ 1>/dev/null 2>&1
echo "Waiting for things to come up..."
sleep 10
echo "Creating Datasource & Dashboards..."

GRAFANA_URL=`kubectl describe service grafana | grep Ingress | awk '{print "admin:secret@"$3}' | sed 's/$/:3000/'`
printf "GRAFANA_URL: %s\n" "$GRAFANA_URL"

printf "Creating InfluxDB data source...\n"
curl `echo $GRAFANA_URL | sed 's/$/\/api\/datasources/'` -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"influx","type":"influxdb","url":"http://influxdb.default.svc.cluster.local:8086/","access":"proxy","isDefault":true,"database":"k8s","user":"","password":""}'
printf "\nCreating dashboard: dashboard...\n"
curl -d @dashboard.json `echo $GRAFANA_URL | sed 's/$/\/api\/dashboards\/db/'` -X POST -H 'Content-Type: application/json;charset=UTF-8'
printf "\nCreating dashboard: cluster..\n"
curl -d @cluster.json `echo $GRAFANA_URL | sed 's/$/\/api\/dashboards\/db/'` -X POST -H 'Content-Type: application/json;charset=UTF-8'
printf "\ndone"
kubectl describe service grafana
