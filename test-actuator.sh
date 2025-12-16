#!/bin/bash

MINIKUBE_IP="192.168.49.2"
PORT="30080"
BASE_URL="http://$MINIKUBE_IP:$PORT/student"

echo "Testing endpoints..."
echo "===================="

# Test health
echo "1. /actuator/health"
curl -s -o /tmp/health.json -w "HTTP: %{http_code}\n" $BASE_URL/actuator/health
cat /tmp/health.json | jq . 2>/dev/null || cat /tmp/health.json
echo ""

# Test prometheus
echo "2. /actuator/prometheus"
HTTP_CODE=$(curl -s -o /tmp/prom.txt -w "%{http_code}" $BASE_URL/actuator/prometheus)
echo "HTTP: $HTTP_CODE"
if [ "$HTTP_CODE" = "200" ]; then
  echo "Success! First 3 lines:"
  head -3 /tmp/prom.txt
fi
echo ""

# Test info
echo "3. /actuator/info"
curl -s -o /tmp/info.json -w "HTTP: %{http_code}\n" $BASE_URL/actuator/info
cat /tmp/info.json | jq . 2>/dev/null || cat /tmp/info.json
echo ""

# Test metrics
echo "4. /actuator/metrics"
curl -s -o /tmp/metrics.json -w "HTTP: %{http_code}\n" $BASE_URL/actuator/metrics
echo "Response length: $(wc -l < /tmp/metrics.json) lines"
