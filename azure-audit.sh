#!/usr/bin/env bash

set -u

FULL_NAME="Peace Offor Nwadinachi"
REPORT_DIR="./reports"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
REPORT="$REPORT_DIR/azure-audit-$TIMESTAMP.txt"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

mkdir -p "$REPORT_DIR"

log() {
    echo "$1" | tee -a "$REPORT"
}

pass() {
    log "[PASS] $1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

warn() {
    log "[WARN] $1"
    WARN_COUNT=$((WARN_COUNT + 1))
}

fail() {
    log "[FAIL] $1"
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

log "========================================"
log "Azure Security Posture Audit"
log "Auditor: $FULL_NAME"
log "Generated: $(date)"
log "========================================"
log ""

# ----------------------------------------
# CHECK 1: NSG exposure
# ----------------------------------------

log "CHECK 1: NSG SSH/RDP exposure"

NSG_FINDINGS=$(az network nsg rule list \
    --resource-group bookreview-capstone-rg \
    --nsg-name web-nsg \
    --query "[?direction=='Inbound' && access=='Allow'].[name,sourceAddressPrefix,destinationPortRange]" \
    -o tsv 2>/dev/null)

if echo "$NSG_FINDINGS" | grep -E '(\*|0\.0\.0\.0/0|Internet).*(22|3389)' >/dev/null; then
    fail "An inbound NSG rule may expose SSH/RDP to the Internet."
else
    pass "No Internet-wide SSH/RDP rule detected in web-nsg."
fi

log ""

# ----------------------------------------
# CHECK 2: Storage public blob access
# ----------------------------------------

log "CHECK 2: Storage public blob access"

STORAGE_PUBLIC=$(az storage account list \
    --query "[].allowBlobPublicAccess" \
    -o tsv 2>/dev/null)

if echo "$STORAGE_PUBLIC" | grep -qi "true"; then
    warn "At least one Storage Account allows public blob access."
else
    pass "Storage Accounts do not report public blob access enabled."
fi

log ""

# ----------------------------------------
# CHECK 3: VM disk encryption
# ----------------------------------------

log "CHECK 3: VM disk encryption"

VM_ENCRYPTION=$(az vm list \
    --resource-group bookreview-capstone-rg \
    --query "[].{VM:name,EncryptionAtHost:securityProfile.encryptionAtHost}" \
    -o tsv 2>/dev/null)

if echo "$VM_ENCRYPTION" | grep -qi "true"; then
    pass "At least one VM reports encryption at host enabled."
else
    warn "VMs do not report encryption at host enabled. Review disk encryption configuration."
fi

log ""

# ----------------------------------------
# CHECK 4: MySQL public network access
# ----------------------------------------

log "CHECK 4: MySQL public network access"

MYSQL_PUBLIC=$(az mysql flexible-server list \
    --resource-group bookreview-capstone-rg \
    --query "[].network.publicNetworkAccess" \
    -o tsv 2>/dev/null)

if echo "$MYSQL_PUBLIC" | grep -qi "enabled"; then
    fail "Azure Database for MySQL has public network access enabled."
elif echo "$MYSQL_PUBLIC" | grep -qi "disabled"; then
    pass "Azure Database for MySQL public network access is disabled."
else
    warn "Unable to conclusively determine MySQL public network access."
fi

log ""
log "========================================"
log "SUMMARY"
log "PASS: $PASS_COUNT"
log "WARN: $WARN_COUNT"
log "FAIL: $FAIL_COUNT"
log "Report: $REPORT"
log "========================================"

if [ "$FAIL_COUNT" -gt 0 ]; then
    exit 2
elif [ "$WARN_COUNT" -gt 0 ]; then
    exit 1
else
    exit 0
fi