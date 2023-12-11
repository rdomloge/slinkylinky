Steps to create cert-manager
-- taken from https://k3s.rocks/https-cert-manager-letsencrypt/

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.11.0/cert-manager.yaml



CREATE letsencrypt-prod.yaml

    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
    name: letsencrypt-prod
    spec:
    acme:
        email: rdomloge@gmail.com
        server: https://acme-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
        name: letsencrypt-prod
        solvers:
        - http01:
            ingress:
            class: traefik

EXECUTE cat letsencrypt-prod.yaml | envsubst | kubectl apply -f -

CREATE traefik-https-redirect-middleware.yaml

    apiVersion: traefik.containo.us/v1alpha1
    kind: Middleware
    metadata:
    name: redirect-https
    spec:
    redirectScheme:
        scheme: https
        permanent: true

EXECUTE cat traefik-https-redirect-middleware.yaml | envsubst | kubectl apply -f -

CREATE whoami-ingress-tls.yaml

    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    name: whoami-tls-ingress
    annotations:
        kubernetes.io/ingress.class: traefik
        cert-manager.io/cluster-issuer: letsencrypt-prod
        traefik.ingress.kubernetes.io/router.middlewares: default-redirect-https@kubernetescrd
    spec:
    rules:
        - host: whoami.rdomloge.synology.me
        http:
            paths:
            - path: /
                pathType: Prefix
                backend:
                service:
                    name: whoami
                    port:
                    number: 5678
    tls:
        - secretName: whoami-tls
        hosts:
            - whoami.rdomloge.synology.me

EXECUTE cat ./whoami/whoami-ingress-tls.yaml | envsubst | kubectl apply -f -