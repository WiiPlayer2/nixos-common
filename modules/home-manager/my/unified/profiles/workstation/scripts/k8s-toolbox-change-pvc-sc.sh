NAMESPACE="$1"
PVC="$2"
STORAGECLASS="$3"
NEW_SIZE="${4:-}"

k8s-toolbox rename-pvc "$NAMESPACE" "$PVC" "${PVC}-old"
k8s-toolbox copy-pvc "$NAMESPACE" "${PVC}-old" "$PVC" "$STORAGECLASS" "$NEW_SIZE"
pv-migrate \
  --source-namespace="$NAMESPACE" \
  --source="${PVC}-old" \
  --dest-namespace="$NAMESPACE" \
  --dest="$PVC"
kubectl delete -n "$NAMESPACE" pvc "${PVC}-old"
