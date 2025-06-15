/bin/otelcol/otelcol-contrib --config=/etc/otelcol/config.yaml &
/bin/tempo/tempo -config.file /etc/tempo/config.yaml &
/bin/loki/loki-linux-amd64 -config.file /etc/loki/config.yaml

wait -n
exit $?