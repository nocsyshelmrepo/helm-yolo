# yolo Helm Charts

- install yolo on ecpaas.

## Usage:

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

```console
git clone https://github.com/nocsyshelmrepo/helm-yolo 
cd helm-yolo
helm install {release} -n {namespace} .
```

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

---

## Configuration

| Parameter | Description | Default |
|:-----------|:-------------|:---------|
| `global.repoPrefix` | Prefix string for image repository | "ecpaas-dockerhub.ddns.net"<br></br>ex: "" |
| `autoscaling.enabled` | Enable Horizontal POD autoscaling | true |
| `autoscaling.minReplicas` | Minimum number of replicas | 1 |
| `autoscaling.maxReplicas` | Maximum number of replicas | 2 |
| `autoscaling.targetCPU` | Target CPU utilization percentage | 10 |
| `autoscaling.targetMemory` | Target Memory utilization percentage | |
| `ingress.enabled` | Enable ingress | true |
| `spread` | Enable Topology Spread Constraints | true |
| `service.session` | Enable Session Affinity | false |
| `requestGpu` | Enable requesting GPU resource | true |

