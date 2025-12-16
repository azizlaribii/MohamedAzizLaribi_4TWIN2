#!/bin/bash

# Attendre que Grafana soit prêt
echo "Attente que Grafana soit prêt..."
sleep 30

# Configuration de la source de données Prometheus
curl -X POST "http://localhost:3000/api/datasources" \
  -H "Content-Type: application/json" \
  -u "admin:admin" \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://host.docker.internal:9090",
    "access": "proxy",
    "basicAuth": false,
    "isDefault": true
  }' 2>/dev/null

echo -e "\nSource de données configurée. Importation du dashboard..."

# Importe le dashboard Node Exporter
curl -X POST "http://localhost:3000/api/dashboards/import" \
  -H "Content-Type: application/json" \
  -u "admin:admin" \
  -d '{
    "dashboard": {
      "id": null,
      "title": "Node Exporter Full",
      "tags": ["templated"],
      "timezone": "browser",
      "schemaVersion": 16,
      "version": 0,
      "refresh": "5s"
    },
    "folderId": 0,
    "overwrite": true,
    "inputs": [{
      "name": "DS_PROMETHEUS",
      "type": "datasource",
      "pluginId": "prometheus",
      "value": "Prometheus"
    }],
    "path": "dashboards/1860-node-exporter-full.json"
  }' 2>/dev/null

echo -e "\nConfiguration terminée !"
