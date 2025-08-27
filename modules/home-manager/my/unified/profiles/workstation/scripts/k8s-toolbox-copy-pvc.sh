NAMESPACE="$1"
FROM_PVC="$2"
TO_PVC="$3"
TO_STORAGECLASS="$4"
TO_NEW_SIZE="${5:-}"

pvc_data="$(kubectl get pvc -n "$NAMESPACE" "$FROM_PVC" --output=json)"
_resources_code=""
if [ -z "$TO_NEW_SIZE" ]; then
  _resources_code=".spec.resources"
else
  _resources_code="{
    requests: {
        storage: \"$TO_NEW_SIZE\"
    }
  }"
fi
new_pvc_data="$(echo "$pvc_data" | jq "{
  apiVersion: .apiVersion,
  kind: .kind,
  metadata: {
    labels: .metadata.labels,
    annotations: [ .metadata.annotations // {} | to_entries | ( .[] | select(.key | contains(\"kubernetes.io\") | not) ) ] | from_entries,
    name: \"$TO_PVC\",
    namespace: .metadata.namespace,
  },
  spec: {
    accessModes: .spec.accessModes,
    resources: $_resources_code,
    storageClassName: \"$TO_STORAGECLASS\"
  }
}")"
echo "$new_pvc_data" | kubectl apply --server-side=true -f -
