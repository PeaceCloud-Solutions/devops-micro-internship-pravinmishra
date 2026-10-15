#!/usr/bin/env bash

set -u
set -o pipefail

NAMESPACE="${NAMESPACE:-book-review}"
DEPLOYMENT="${DEPLOYMENT:-book-review-backend}"
SERVICE="${SERVICE:-book-review-backend}"
APP_LABEL="${APP_LABEL:-app=book-review-backend}"

REPORT_DIR="${REPORT_DIR:-reports}"
REPORT_FILE="${REPORT_FILE:-$REPORT_DIR/k8s-health-report.txt}"

mkdir -p "$(dirname "$REPORT_FILE")"

exec > >(tee "$REPORT_FILE") 2>&1

echo "Full Name: Peace Nwadinachi Offor"
echo "=============================================="
echo "KUBERNETES INCIDENT TRIAGE REPORT"
echo "=============================================="
echo "Timestamp: $(date -Is)"
echo "Namespace: $NAMESPACE"
echo "Deployment: $DEPLOYMENT"
echo "Service: $SERVICE"
echo "Pod selector: $APP_LABEL"
echo ""

status=0

echo "===== KUBERNETES CONTEXT ====="

if ! kubectl config current-context; then
    echo "FAIL: Unable to determine Kubernetes context."
    exit 2
fi

echo ""
echo "===== DEPLOYMENT ====="

if ! kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE"; then
    echo "FAIL: Deployment not found."
    exit 2
fi

desired=$(kubectl get deployment "$DEPLOYMENT" \
    -n "$NAMESPACE" \
    -o jsonpath='{.spec.replicas}') || exit 2

ready=$(kubectl get deployment "$DEPLOYMENT" \
    -n "$NAMESPACE" \
    -o jsonpath='{.status.readyReplicas}') || exit 2

desired="${desired:-1}"
ready="${ready:-0}"

if (( ready < desired )); then
    echo "FAIL: Only $ready of $desired replicas are ready."
    status=2
else
    echo "PASS: All $desired replicas are ready."
fi

echo ""
echo "===== PODS ====="

kubectl get pods -n "$NAMESPACE" -l "$APP_LABEL" -o wide || exit 2

echo ""
echo "===== SERVICE ====="

if ! kubectl get service "$SERVICE" -n "$NAMESPACE"; then
    echo "FAIL: Service not found."
    exit 2
fi

echo ""
echo "===== SERVICE ENDPOINTS ====="

kubectl get endpoints "$SERVICE" -n "$NAMESPACE" || exit 2

endpoint_ips=$(kubectl get endpoints "$SERVICE" \
    -n "$NAMESPACE" \
    -o jsonpath='{range .subsets[*].addresses[*]}{.ip}{" "}{end}') || exit 2

if [[ -z "$endpoint_ips" ]]; then
    echo "FAIL: Service has no ready backend endpoints."
    status=2
else
    echo "PASS: Ready endpoint IPs: $endpoint_ips"
fi

echo ""
echo "===== ENDPOINTSLICES ====="

kubectl get endpointslices \
    -n "$NAMESPACE" \
    -l "kubernetes.io/service-name=$SERVICE" || exit 2

echo ""
echo "===== RECENT EVENTS ====="

kubectl get events \
    -n "$NAMESPACE" \
    --sort-by=.metadata.creationTimestamp \
    | tail -n 15 || exit 2

echo ""
echo "===== FINAL TRIAGE RESULT ====="

if (( status == 0 )); then
    echo "HEALTHY: Deployment and Service backends are ready."
elif (( status == 1 )); then
    echo "WARN: Kubernetes resources require attention."
else
    echo "FAIL: Kubernetes workload is unhealthy."
fi

exit "$status"
