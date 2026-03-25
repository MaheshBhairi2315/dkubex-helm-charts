# Contributing to DKubeX Helm Charts

## Adding a New Chart

1. Create a new directory under `charts/` with your app name
2. Follow the standard Helm chart structure:
   ```
   charts/your-app/
   ├── Chart.yaml
   ├── values.yaml
   └── templates/
       ├── _helpers.tpl
       ├── deployment.yaml
       └── service.yaml
   ```

3. Test your chart locally:
   ```bash
   helm lint charts/your-app
   helm install test charts/your-app --dry-run --debug
   ```

4. Submit a pull request

## Chart Requirements

- Must include proper labels using `_helpers.tpl`
- Must have configurable resources
- Must use semantic versioning
- Must include a detailed README.md in the chart directory

## Testing

Before submitting, ensure:
- Chart passes `helm lint`
- Chart can be installed successfully
- All templates render correctly
- Values are properly documented

## Release Process

Charts are automatically packaged and released when merged to `main` branch via GitHub Actions.
