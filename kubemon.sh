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
curl "http://admin:secret@`minikube service grafana --url | sed 's/http\:\/\///' `/api/datasources" -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"influx","type":"influxdb","url":"http://influxdb.default.svc.cluster.local:8086/","access":"proxy","isDefault":true,"database":"k8s","user":"","password":""}'
curl -d @dashboard.json "http://admin:secret@`minikube service grafana --url | sed 's/http\:\/\///' `/api/dashboards/db" -X POST -H 'Content-Type: application/json;charset=UTF-8'
curl -d @cluster.json "http://admin:secret@`minikube service grafana --url | sed 's/http\:\/\///' `/api/dashboards/db" -X POST -H 'Content-Type: application/json;charset=UTF-8'
echo "done"
minikube service grafana
