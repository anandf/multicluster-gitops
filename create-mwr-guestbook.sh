cat << EOF | kubectl apply --context kind-hub -f -
apiVersion: work.open-cluster-management.io/v1alpha1
kind: ManifestWorkReplicaSet
metadata:
  name: argo-guestbook
  namespace: default
spec:
  manifestWorkTemplate:
    manifestConfigs:
    - resourceIdentifier:
        group: argoproj.io
        resource: applications
        namespace: argocd
        name: guestbook
      feedbackRules:
        - type: WellKnownStatus
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
        kind: Application
        metadata:
          name: guestbook
          namespace: argocd
        spec:
          destination:
            namespace: guestbook
            server: https://kubernetes.default.svc
          project: default
          source:
            path: guestbook
            repoURL: https://github.com/argoproj/argocd-example-apps.git
            targetRevision: HEAD
          syncPolicy:
            automated:
              prune: true
              selfHeal: true
            syncOptions:
            - CreateNamespace=true
  placementRefs:
  - name: demo-clusters
EOF
