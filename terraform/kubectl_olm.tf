provider "kubectl" {
  host = "${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
  client_certificate = "${google_container_cluster.primary.master_auth.0.client_certificate}"
  client_key = "${google_container_cluster.primary.master_auth.0.client_key}"
}

data "kubectl_file_documents" "crds" {
  content = file("../kubernetes/olm/crds.yaml")
}

resource "kubectl_manifest" "crds_apply" {
  for_each  = data.kubectl_file_documents.crds.manifests
  yaml_body = each.value
  wait = true
  server_side_apply = true
}

data "kubectl_file_documents" "olm" {
  content = file("../kubernetes/olm/olm.yaml")
}

resource "kubectl_manifest" "olm_apply" {
  depends_on = [data.kubectl_file_documents.crds]
  for_each  = data.kubectl_file_documents.olm.manifests
  yaml_body = each.value
}