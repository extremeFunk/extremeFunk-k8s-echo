kubectl -n monitoring port-forward svc/prometheus-prometheus-oper-prometheus 9090 &
kubectl -n monitoring port-forward svc/prometheus-grafana 8080:9091 &
kubectl -n loggin port-forward $(cat kibana.hostname) 5601:9092 &
kubectl -n monitoring port-forward svc/prometheus-prometheus-oper-alertmanager 9093 &
