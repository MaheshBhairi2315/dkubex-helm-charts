# DKubeX Helm Charts

This is the Helm repository for DKubeX marketplace applications.

## Usage

Add this Helm repository:

```bash
helm repo add dkubex https://maheshbhairi2315.github.io/dkubex-helm-charts
helm repo update
```

Search for available charts:

```bash
helm search repo dkubex
```

Install a chart:

```bash
helm install my-postgresql dkubex/postgresql --namespace my-namespace --create-namespace
```

## Available Charts

- postgresql-1.0.0
- redis-1.0.0
- mongodb-1.0.0
- nginx-1.0.0
- elasticsearch-1.0.0
- kafka-1.0.0
- grafana-1.0.0
- minio-1.0.0
- rabbitmq-1.0.0
- prometheus-1.0.0

## Source

Chart sources are available at: https://github.com/MaheshBhairi2315/dkubex-helm-charts
