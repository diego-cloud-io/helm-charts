# helm-charts

## Update the index

When a new version is required:

1.  Take a new release branch
1.  Update the version number in Chart.yaml
1.  Package the chart: `helm package helm-chart-sources/*` (if you update only one chart package just the modified chart, not all charts)
1.  Update the index: `helm repo index --url https://diego-cloud-io.github.io/helm-charts --merge index.yaml .`
1.  Commit, push, PR, approve, et voila!
