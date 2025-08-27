NAMESPACE="$1"
FROM_PVC="$2"
TO_PVC="$3"

pvc_data="$(kubectl get pvc -n "$NAMESPACE" "$FROM_PVC" --output=json)"
pv="$(echo "$pvc_data" | jq -r '.spec.volumeName')"

pv_data="$(kubectl get pv "$pv" --output=json)"
new_pv_data="$(echo "$pv_data" | jq "{
  apiVersion: .apiVersion,
  kind: .kind,
  metadata: .metadata,
  spec: {
    accessModes: .spec.accessModes,
    capacity: .spec.capacity,
    claimRef: .spec.claimRef,
    csi: .spec.csi,
    persistentVolumeReclaimPolicy: \"Retain\",
    storageClassName: .spec.storageClassName,
    volumeMode: .spec.volumeMode
  },
  status: .status
}")"
echo "$new_pv_data" | kubectl apply --server-side=true --force-conflicts -f -

new_pvc_data="$(echo "$pvc_data" | jq "{
  apiVersion: .apiVersion,
  kind: .kind,
  metadata: {
    labels: .metadata.labels,
    name: \"$TO_PVC\",
    namespace: .metadata.namespace,
  },
  spec: .spec
}")"
echo "$new_pvc_data" | kubectl apply --server-side=true --force-conflicts -f -

kubectl delete pvc -n "$NAMESPACE" "$FROM_PVC"
# kubectl wait --for=jsonpath='{.status.phase}'=Released "pv/$pv"

pvc_data="$(kubectl get pvc -n "$NAMESPACE" "$TO_PVC" --output=json)"
pvc_resource_version="$(echo "$pvc_data" | jq -r '.metadata.resourceVersion')"
pvc_uid="$(echo "$pvc_data" | jq -r '.metadata.uid')"
pv_data="$(kubectl get pv "$pv" --output=json)"
new_pv_data="$(echo "$pv_data" | jq "{
  apiVersion: .apiVersion,
  kind: .kind,
  metadata: .metadata,
  spec: {
    accessModes: .spec.accessModes,
    capacity: .spec.capacity,
    claimRef: {
      apiVersion: .spec.claimRef.apiVersion,
      kind: .spec.claimRef.kind,
      name: \"$TO_PVC\",
      namespace: \"$NAMESPACE\",
      resourceVersion: \"$pvc_resource_version\",
      uid: \"$pvc_uid\"
    },
    csi: .spec.csi,
    persistentVolumeReclaimPolicy: .spec.persistentVolumeReclaimPolicy,
    storageClassName: .spec.storageClassName,
    volumeMode: .spec.volumeMode
  },
  status: .status
}")"
echo "$new_pv_data" | kubectl apply --server-side=true --force-conflicts -f -
