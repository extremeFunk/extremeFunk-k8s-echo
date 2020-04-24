#!/bin/sh

kubectl -n monitoring port-forward svc/prometheus-prometheus-oper-prometheus 9090 &
kubectl -n monitoring port-forward svc/prometheus-grafana 9091:80 &
kubectl -n loggin port-forward svc/loggin-kibana 9092:5601 &
kubectl -n monitoring port-forward svc/prometheus-prometheus-oper-alertmanager 9093 &
