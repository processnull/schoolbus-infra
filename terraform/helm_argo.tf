provider "helm" {
  kubernetes {
    host = "${google_container_cluster.primary.endpoint}"
    cluster_ca_certificate = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
    client_certificate = "${google_container_cluster.primary.master_auth.0.client_certificate}"
    client_key = "${google_container_cluster.primary.master_auth.0.client_key}"
  }
}

resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.24.0"
  create_namespace = true

  values = [
    file("../kubernetes/argocd/application.yaml")
  ]
}
