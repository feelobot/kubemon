#!/bin/bash
kubectl create -f deploy/influxdb-deployment.yaml
kubectl create -f deploy/influxdb-service.yaml
kubectl create -f deploy/influxdb-ingress.yaml
echo "Waiting for influxdb..."
sleep 5
kubectl create -f deploy/
#kubectl create -f deploy/heapster-service.yaml
#kubectl create -f deploy/grafana-deployment.yaml
#kubectl create -f deploy/grafana-service.yaml
#kubectl create -f deploy/grafana-ingress.yaml
#kubectl create -f deploy/kapacitor-deployment.yaml
#kubectl create -f deploy/kapacitor-service.yaml
echo "Waiting for things to come up..."
sleep 10
curl "http://admin:secret@`minikube service grafana --url | sed 's/http\:\/\///' `/api/datasources" -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"influx","type":"influxdb","url":"http://influxdb.default.svc.cluster.local:8086/","access":"proxy","isDefault":true,"database":"k8s","user":"","password":""}'
curl -d @dashboard.json "http://admin:secret@`minikube service grafana --url | sed 's/http\:\/\///' `/api/dashboards/db" -X POST -H 'Content-Type: application/json;charset=UTF-8'
echo ""
minikube service grafana
