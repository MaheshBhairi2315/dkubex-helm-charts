# Credit Scheduler Helm Chart

A Helm chart for deploying the Credit Scheduler application - a React + FastAPI task scheduling application with credit-based allocation.

## Application Overview

Credit Scheduler is a web application that allows users to schedule tasks in 30-minute time slots using a credit-based system. It features:

- Credit-based task scheduling (default: 16 credits = 8 hours per day)
- 7-day planning horizon
- Real-time clock and task status updates
- Color-coded task visualization
- SQLite database for data persistence

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `my-scheduler`:

```bash
helm install my-scheduler ./credit-scheduler
```

## Uninstalling the Chart

To uninstall/delete the `my-scheduler` deployment:

```bash
helm uninstall my-scheduler
```

## Configuration

The following table lists the configurable parameters of the Credit Scheduler chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `ghcr.io/dev-oc-sb/credit_scheduler` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `3600` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |
| `resources.requests.cpu` | CPU request | `250m` |
| `resources.requests.memory` | Memory request | `256Mi` |
| `persistence.enabled` | Enable persistent storage for SQLite database | `false` |
| `persistence.storageClass` | Storage class for PVC | `""` |
| `persistence.accessMode` | Access mode for PVC | `ReadWriteOnce` |
| `persistence.size` | Size of PVC | `1Gi` |
| `persistence.mountPath` | Mount path for persistent volume | `/app` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Tolerations for pod assignment | `[]` |
| `affinity` | Affinity rules for pod assignment | `{}` |

## Example: Installing with Custom Values

```bash
helm install my-scheduler ./credit-scheduler \
  --set image.tag=v1.0.0 \
  --set persistence.enabled=true \
  --set persistence.size=2Gi
```

## Example: Using a values file

Create a `custom-values.yaml` file:

```yaml
replicaCount: 2

image:
  repository: ghcr.io/dev-oc-sb/credit_scheduler
  tag: "v1.0.0"

service:
  type: LoadBalancer

persistence:
  enabled: true
  size: 5Gi
  storageClass: "standard"

resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi
```

Then install with:

```bash
helm install my-scheduler ./credit-scheduler -f custom-values.yaml
```

## Persistence

The chart optionally supports persistent storage for the SQLite database. When enabled, a PersistentVolumeClaim is created and mounted at `/app` to preserve the `scheduler.db` file across pod restarts.

To enable persistence:

```bash
helm install my-scheduler ./credit-scheduler --set persistence.enabled=true
```

## Accessing the Application

After installation, you can access the application by port-forwarding:

```bash
kubectl port-forward svc/my-scheduler-credit-scheduler 3600:3600
```

Then open your browser to `http://localhost:3600`

## Source Code

- Application Repository: https://github.com/Dev-OC-SB/credit_scheduler
- Helm Charts Repository: https://github.com/MaheshBhairi2315/dkubex-helm-charts

## Support

For issues and questions, please contact the DKubeX Team at support@dkubex.io
