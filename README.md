# DKubeX Helm Charts Repository

This repository contains Helm charts for applications available in the DKubeX marketplace.

## Available Charts

- **postgresql** - PostgreSQL database
- **redis** - Redis cache
- **mongodb** - MongoDB NoSQL database
- **nginx** - NGINX web server
- **elasticsearch** - Elasticsearch search engine (Paid)
- **kafka** - Apache Kafka messaging (Paid)
- **grafana** - Grafana monitoring (Paid)
- **minio** - MinIO object storage
- **rabbitmq** - RabbitMQ message broker
- **prometheus** - Prometheus monitoring (Paid)

## Usage

### Add this Helm repository

```bash
helm repo add dkubex https://maheshbhairi2315.github.io/dkubex-helm-charts
helm repo update
```

### Install a chart

```bash
helm install my-postgresql dkubex/postgresql --namespace my-namespace --create-namespace
```

### Using OCI (Alternative)

```bash
helm install my-postgresql oci://ghcr.io/maheshbhairi2315/charts/postgresql --namespace my-namespace
```

## Chart Structure

Each chart follows the standard Helm chart structure:

```
charts/
├── postgresql/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── _helpers.tpl
```

## Development

### Package a chart

```bash
helm package charts/postgresql -d packages/
```

### Update repository index

```bash
helm repo index packages/ --url https://maheshbhairi2315.github.io/dkubex-helm-charts
```

## License

MIT License
