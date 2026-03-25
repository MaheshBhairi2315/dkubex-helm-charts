#!/bin/bash

# Script to create all Helm charts for DKubeX marketplace apps

CHARTS_DIR="charts"

# Define all apps with their configurations
declare -A APPS=(
    ["redis"]="bitnami/redis:7.2|6379|Redis cache"
    ["mongodb"]="bitnami/mongodb:7.0|27017|MongoDB NoSQL database"
    ["nginx"]="bitnami/nginx:1.25|80|NGINX web server"
    ["elasticsearch"]="bitnami/elasticsearch:8.11|9200|Elasticsearch search engine"
    ["kafka"]="bitnami/kafka:3.6|9092|Apache Kafka messaging"
    ["grafana"]="bitnami/grafana:10.2|3000|Grafana monitoring"
    ["minio"]="bitnami/minio:2024|9000|MinIO object storage"
    ["rabbitmq"]="bitnami/rabbitmq:3.12|5672|RabbitMQ message broker"
    ["prometheus"]="bitnami/prometheus:2.48|9090|Prometheus monitoring"
)

for app in "${!APPS[@]}"; do
    IFS='|' read -r image port description <<< "${APPS[$app]}"
    
    echo "Creating chart for $app..."
    
    # Create directories
    mkdir -p "$CHARTS_DIR/$app/templates"
    
    # Create Chart.yaml
    cat > "$CHARTS_DIR/$app/Chart.yaml" <<EOF
apiVersion: v2
name: $app
description: $description
type: application
version: 1.0.0
appVersion: "1.0"
keywords:
  - $app
home: https://github.com/MaheshBhairi2315/dkubex-helm-charts
sources:
  - https://github.com/MaheshBhairi2315/dkubex-helm-charts
maintainers:
  - name: DKubeX Team
    email: support@dkubex.io
EOF

    # Create values.yaml
    cat > "$CHARTS_DIR/$app/values.yaml" <<EOF
replicaCount: 1

image:
  repository: ${image%:*}
  tag: "${image#*:}"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: $port

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

nodeSelector: {}
tolerations: []
affinity: {}
EOF

    # Create _helpers.tpl
    cat > "$CHARTS_DIR/$app/templates/_helpers.tpl" <<EOF
{{/*
Expand the name of the chart.
*/}}
{{- define "$app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "$app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- \$name := default .Chart.Name .Values.nameOverride }}
{{- if contains \$name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name \$name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "$app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "$app.labels" -}}
helm.sh/chart: {{ include "$app.chart" . }}
{{ include "$app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "$app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "$app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
EOF

    # Create deployment.yaml
    cat > "$CHARTS_DIR/$app/templates/deployment.yaml" <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "$app.fullname" . }}
  labels:
    {{- include "$app.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "$app.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "$app.selectorLabels" . | nindent 8 }}
    spec:
      containers:
      - name: $app
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: http
          containerPort: $port
          protocol: TCP
        resources:
          {{- toYaml .Values.resources | nindent 10 }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
EOF

    # Create service.yaml
    cat > "$CHARTS_DIR/$app/templates/service.yaml" <<EOF
apiVersion: v1
kind: Service
metadata:
  name: {{ include "$app.fullname" . }}
  labels:
    {{- include "$app.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
  - port: {{ .Values.service.port }}
    targetPort: http
    protocol: TCP
    name: http
  selector:
    {{- include "$app.selectorLabels" . | nindent 4 }}
EOF

done

echo "All charts created successfully!"
