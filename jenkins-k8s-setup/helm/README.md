# Tenant Namespace Helm Chart

This Helm chart creates Kubernetes namespaces based on a tenant identifier, which can be provided either via an environment variable or static configuration.

## Features

- Creates namespaces dynamically based on the `TENANT` environment variable
- Supports static tenant names as fallback
- Allows custom labels and annotations
- Configurable finalizers

## Usage

### Using Environment Variable (Default)

Set the `TENANT` environment variable and install the chart:

```bash
export TENANT=my-tenant
helm install tenant-ns ./helm
```

### Using Static Tenant Name

```bash
helm install tenant-ns ./helm --set tenant.useEnvironmentVariable=false --set tenant.name=my-static-tenant
```

### With Additional Labels and Annotations

```bash
export TENANT=production-tenant
helm install tenant-ns ./helm \
  --set tenant.labels.environment=production \
  --set tenant.labels.team=platform \
  --set tenant.annotations.contact=admin@example.com
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `tenant.useEnvironmentVariable` | Use TENANT environment variable for namespace name | `true` |
| `tenant.name` | Static tenant name (used when useEnvironmentVariable is false) | `""` |
| `tenant.labels` | Additional labels for the namespace | `{}` |
| `tenant.annotations` | Additional annotations for the namespace | `{}` |
| `tenant.finalizers` | Finalizers for the namespace | `[]` |

## Examples

### Jenkins Pipeline Usage

In your Jenkins pipeline, you can use this chart like this:

```groovy
pipeline {
    agent any
    environment {
        TENANT = "${params.TENANT_NAME ?: 'default'}"
    }
    stages {
        stage('Deploy Namespace') {
            steps {
                sh '''
                    helm upgrade --install tenant-${TENANT} ./helm \
                      --set tenant.labels.pipeline-id=${BUILD_ID} \
                      --set tenant.annotations.build-url=${BUILD_URL}
                '''
            }
        }
    }
}
```

### Multiple Tenants

```bash
# Deploy for multiple tenants
for tenant in tenant1 tenant2 tenant3; do
    TENANT=$tenant helm install $tenant-ns ./helm
done
```

## Validation

The chart includes validation to ensure either:
- `tenant.useEnvironmentVariable` is `true` and `TENANT` environment variable is set, OR  
- `tenant.useEnvironmentVariable` is `false` and `tenant.name` is provided

If neither condition is met, the chart will fail with a clear error message.