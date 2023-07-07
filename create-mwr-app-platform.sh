cat << EOF | kubectl apply --context kind-hub -f -
apiVersion: work.open-cluster-management.io/v1alpha1
kind: ManifestWorkReplicaSet
metadata:
  name: argo-app-platform
  namespace: default
spec:
  manifestWorkTemplate:
    workload:
      manifests:
      - apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRole
        metadata:
          name: open-cluster-management:klusterlet-work:my-role
        rules:
        - apiGroups:
          - argoproj.io
          resources:
          - '*'
          verbs:
          - get
          - list
          - watch
          - create
          - update
          - patch
          - delete
      - apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: open-cluster-management:klusterlet-work:my-binding
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: open-cluster-management:klusterlet-work:my-role
        subjects:
        - kind: ServiceAccount
          name: klusterlet-work-sa
          namespace: open-cluster-management-agent
      - apiVersion: argoproj.io/v1alpha1
        kind: ApplicationSet
        metadata:
          name: app-platform
          namespace: argocd
        spec:
          generators:
            - list:
                elements:
                  - component: cert-manager
                    repoURL: https://charts.jetstack.io
                    chartVersion: "v1.11.2"
                    chart: cert-manager
                    namespace: cert-manager
                  - component: istio
                    repoURL: https://istio-release.storage.googleapis.com/charts
                    chartVersion: "1.18.0"
                    chart: base
                    namespace: istio-system
                  - component: jaeger
                    repoURL: https://jaegertracing.github.io/helm-charts
                    chartVersion: "2.43.0"
                    chart: jaeger-operator
                    namespace: o11y
                  - component: opensearch
                    repoURL: https://opensearch-project.github.io/helm-charts
                    chartVersion: "1.20.0"
                    chart: opensearch
                    namespace: o11y
                  - component: opensearch-dashboards
                    repoURL: https://opensearch-project.github.io/helm-charts
                    chartVersion: "1.13.0"
                    chart: opensearch-dashboards
                    namespace: o11y
                  - component: kiali
                    repoURL: https://kiali.org/helm-charts
                    chartVersion: "1.69.0"
                    chart: kiali-operator
                    namespace: o11y
                  - component: prometheus
                    repoURL: https://prometheus-community.github.io/helm-charts
                    chartVersion: "47.0.0"
                    chart: kube-prometheus-stack
                    namespace: o11y
                    serverSideApply: true
                  - component: grafana
                    repoURL: https://grafana.github.io/helm-charts
                    chartVersion: "6.56.5"
                    chart: grafana
                    namespace: o11y
                  - component: fluentd
                    repoURL: registry-1.docker.io
                    chartVersion: "5.8.2"
                    chart: bitnamicharts/fluentd
                    namespace: o11y
                  - component: keycloak
                    repoURL: https://codecentric.github.io/helm-charts
                    chartVersion: "18.4.3"
                    chart: keycloak
                    namespace: security
                  - component: ingress-nginx
                    repoURL: https://kubernetes.github.io/ingress-nginx
                    chartVersion: "4.7.0"
                    chart: ingress-nginx
                    namespace: ingress-nginx
                  - component: kubevela
                    repoURL: https://charts.kubevela.net/core
                    chartVersion: "1.8.2"
                    chart: vela-core
                    namespace: vela-system
                  - component: velero
                    repoURL: https://vmware-tanzu.github.io/helm-charts
                    chartVersion: "4.0.2"
                    chart: velero
                    namespace: velero
          goTemplate: true
          template:
            metadata:
              name: "{{.component}}"
              annotations:
                argocd.argoproj.io/manifest-generate-paths: ".;.."
            spec:
              ignoreDifferences:
                - group: admissionregistration.k8s.io
                  kind: MutatingWebhookConfiguration
                  jqPathExpressions:
                    - '.webhooks[]?.clientConfig.caBundle'
                - group: admissionregistration.k8s.io
                  kind: ValidatingWebhookConfiguration
                  jqPathExpressions:
                    - '.webhooks[]?.clientConfig.caBundle'
                    - '.webhooks[]?.failurePolicy'
                - group: cert-manager.io
                  kind: Certificate
                  jsonPointers:
                    - /spec/duration
                - group: apiregistration.k8s.io
                  kind: APIService
                  jsonPointers:
                    - /spec/insecureSkipTLSVerify
                    - /spec/caBundle
              project: default
              sources:
                - repoURL: "{{.repoURL}}"
                  targetRevision: "{{.chartVersion}}"
                  helm:
                    passCredentials: true
                    valueFiles:
                      - '\$values/components/{{.component}}/values.yaml'
                    releaseName: "{{.component}}"
                  chart: "{{.chart}}"
                - repoURL: "https://github.com/anandf/app-platform-argocd.git"
                  targetRevision: main
                  ref: values
                - repoURL: "https://github.com/anandf/app-platform-argocd"
                  targetRevision: main
                  path: "components/{{.component}}"
              destination:
                name: in-cluster
                namespace: "{{.namespace}}"
              syncPolicy:
                automated:
                  prune: true
                  selfHeal: true
                syncOptions:
                  - CreateNamespace=true
                  - ServerSideApply={{or .serverSideApply false}}

  placementRefs:
  - name: demo-clusters
EOF
