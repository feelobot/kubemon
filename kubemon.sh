#!/bin/bash
kubectl create -f deploy/
echo "Waiting for things to come up..."
sleep 10
curl "http://admin:secret@`minikube service grafana --url | sed 's/http\:\/\///' `/api/datasources" -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"influx","type":"influxdb","url":"http://influxdb.default.svc.cluster.local:8086/","access":"proxy","isDefault":true,"database":"k8s","user":"","password":""}'
sleep 10
curl -d @dashboard.json "http://admin:secret@`minikube service grafana --url | sed 's/http\:\/\///' `/api/dashboards/db" -X POST -H 'Content-Type: application/json;charset=UTF-8'
echo ""
minikube service grafana
