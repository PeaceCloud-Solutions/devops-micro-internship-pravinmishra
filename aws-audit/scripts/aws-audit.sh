
#!/usr/bin/env bash

set -u

# ============================================================
# AWS Security and Cost Audit
# Read-only: this script must never modify AWS resources.
# ============================================================

FULL_NAME="Peace Offor Nwadinachi"
REGION="eu-north-1"
REPORT_DIR="reports"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
REPORT_FILE="${REPORT_DIR}/aws-audit-${TIMESTAMP}.txt"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

checks=(
  "check_s3_public_access"
  "check_ssh_open_to_world"
  "check_mysql_open_to_world"
  "check_rds_public_access"
  "check_ebs_encryption"
)

mkdir -p "$REPORT_DIR"

log() {
  echo "$1" | tee -a "$REPORT_FILE"
}

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  log "[PASS] $1"
}

warn() {
  WARN_COUNT=$((WARN_COUNT + 1))
  log "[WARN] $1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  log "[FAIL] $1"
}

check_s3_public_access() {
  log ""
  log "CHECK 1: S3 public-access settings"

  local buckets
  buckets="$(aws s3api list-buckets \
    --query 'Buckets[].Name' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to list S3 buckets."
    return
  fi

  if [[ -z "$buckets" ]]; then
    pass "No S3 buckets found."
    return
  fi

  local finding=0

  for bucket in $buckets; do
    local block
    block="$(aws s3api get-public-access-block \
      --bucket "$bucket" \
      --query 'PublicAccessBlockConfiguration.[BlockPublicAcls,IgnorePublicAcls,BlockPublicPolicy,RestrictPublicBuckets]' \
      --output text 2>/dev/null)"

    if [[ $? -ne 0 ]]; then
      warn "Bucket $bucket has no readable bucket-level Public Access Block configuration."
      finding=1
      continue
    fi

    if [[ "$block" == $'True\tTrue\tTrue\tTrue' ]]; then
      log "  $bucket: all bucket-level Public Access Block settings enabled."
    else
      warn "Bucket $bucket does not have all four bucket-level Public Access Block settings enabled."
      finding=1
    fi
  done

  if [[ $finding -eq 0 ]]; then
    pass "S3 bucket-level Public Access Block settings passed."
  fi
}

check_ssh_open_to_world() {
  log ""
  log "CHECK 2: Security groups exposing SSH (22) to 0.0.0.0/0"

  local groups
  groups="$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --query "SecurityGroups[?IpPermissions[?IpProtocol=='tcp' && FromPort<=\`22\` && ToPort>=\`22\` && IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect security groups for SSH exposure."
    return
  fi

  if [[ -n "$groups" ]]; then
    warn "Security group(s) expose SSH port 22 to the whole IPv4 internet:"
    log "$groups"
  else
    pass "No security group exposes SSH port 22 to 0.0.0.0/0."
  fi
}

check_mysql_open_to_world() {
  log ""
  log "CHECK 3: Security groups exposing MySQL (3306) to 0.0.0.0/0"

  local groups
  groups="$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --query "SecurityGroups[?IpPermissions[?IpProtocol=='tcp' && FromPort<=\`3306\` && ToPort>=\`3306\` && IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect security groups for MySQL exposure."
    return
  fi

  if [[ -n "$groups" ]]; then
    fail "Security group(s) expose MySQL port 3306 to the whole IPv4 internet:"
    log "$groups"
  else
    pass "No security group exposes MySQL port 3306 to 0.0.0.0/0."
  fi
}

check_rds_public_access() {
  log ""
  log "CHECK 4: RDS public accessibility"

  local public_dbs
  public_dbs="$(aws rds describe-db-instances \
    --region "$REGION" \
    --query 'DBInstances[?PubliclyAccessible==`true`].[DBInstanceIdentifier]' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect RDS DB instances."
    return
  fi

  if [[ -n "$public_dbs" ]]; then
    fail "Publicly accessible RDS DB instance(s) found:"
    log "$public_dbs"
  else
    pass "No RDS DB instance is publicly accessible."
  fi
}

check_ebs_encryption() {
  log ""
  log "CHECK 5: EBS volume encryption"

  local unencrypted
  unencrypted="$(aws ec2 describe-volumes \
    --region "$REGION" \
    --query 'Volumes[?Encrypted==`false`].[VolumeId,State,Size]' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect EBS volumes."
    return
  fi

  if [[ -n "$unencrypted" ]]; then
    warn "Unencrypted EBS volume(s) found:"
    log "$unencrypted"
  else
    pass "All discovered EBS volumes are encrypted."
  fi
}

log "============================================================"
log "AWS SECURITY AND COST AUDIT"
log "Name: $FULL_NAME"
log "Region: $REGION"
log "Started: $(date)"
log "============================================================"

for check in "${checks[@]}"; do
  "$check"
done

log ""
log "============================================================"
log "FINAL SUMMARY"
log "PASS: $PASS_COUNT"
log "WARN: $WARN_COUNT"
log "FAIL: $FAIL_COUNT"
log "Report: $REPORT_FILE"
log "============================================================"

if [[ $FAIL_COUNT -gt 0 ]]; then
  log "OVERALL STATUS: FAIL"
  exit 2
elif [[ $WARN_COUNT -gt 0 ]]; then
  log "OVERALL STATUS: WARN"
  exit 1
else
  log "OVERALL STATUS: HEALTHY"
  exit 0
fi

# ============================================================
# AWS Security and Cost Audit
# Read-only: this script must never modify AWS resources.
# ============================================================

FULL_NAME="Peace Offor Nwadinachi"
REGION="eu-north-1"
REPORT_DIR="reports"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
REPORT_FILE="${REPORT_DIR}/aws-audit-${TIMESTAMP}.txt"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

checks=(
  "check_s3_public_access"
  "check_ssh_open_to_world"
  "check_mysql_open_to_world"
  "check_rds_public_access"
  "check_ebs_encryption"
)

mkdir -p "$REPORT_DIR"

log() {
  echo "$1" | tee -a "$REPORT_FILE"
}

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  log "[PASS] $1"
}

warn() {
  WARN_COUNT=$((WARN_COUNT + 1))
  log "[WARN] $1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  log "[FAIL] $1"
}

check_s3_public_access() {
  log ""
  log "CHECK 1: S3 public-access settings"

  local buckets
  buckets="$(aws s3api list-buckets \
    --query 'Buckets[].Name' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to list S3 buckets."
    return
  fi

  if [[ -z "$buckets" ]]; then
    pass "No S3 buckets found."
    return
  fi

  local finding=0

  for bucket in $buckets; do
    local block
    block="$(aws s3api get-public-access-block \
      --bucket "$bucket" \
      --query 'PublicAccessBlockConfiguration.[BlockPublicAcls,IgnorePublicAcls,BlockPublicPolicy,RestrictPublicBuckets]' \
      --output text 2>/dev/null)"

    if [[ $? -ne 0 ]]; then
      warn "Bucket $bucket has no readable bucket-level Public Access Block configuration."
      finding=1
      continue
    fi

    if [[ "$block" == $'True\tTrue\tTrue\tTrue' ]]; then
      log "  $bucket: all bucket-level Public Access Block settings enabled."
    else
      warn "Bucket $bucket does not have all four bucket-level Public Access Block settings enabled."
      finding=1
    fi
  done

  if [[ $finding -eq 0 ]]; then
    pass "S3 bucket-level Public Access Block settings passed."
  fi
}

check_ssh_open_to_world() {
  log ""
  log "CHECK 2: Security groups exposing SSH (22) to 0.0.0.0/0"

  local groups
  groups="$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --query "SecurityGroups[?IpPermissions[?IpProtocol=='tcp' && FromPort<=\`22\` && ToPort>=\`22\` && IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect security groups for SSH exposure."
    return
  fi

  if [[ -n "$groups" ]]; then
    warn "Security group(s) expose SSH port 22 to the whole IPv4 internet:"
    log "$groups"
  else
    pass "No security group exposes SSH port 22 to 0.0.0.0/0."
  fi
}

check_mysql_open_to_world() {
  log ""
  log "CHECK 3: Security groups exposing MySQL (3306) to 0.0.0.0/0"

  local groups
  groups="$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --query "SecurityGroups[?IpPermissions[?IpProtocol=='tcp' && FromPort<=\`3306\` && ToPort>=\`3306\` && IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect security groups for MySQL exposure."
    return
  fi

  if [[ -n "$groups" ]]; then
    fail "Security group(s) expose MySQL port 3306 to the whole IPv4 internet:"
    log "$groups"
  else
    pass "No security group exposes MySQL port 3306 to 0.0.0.0/0."
  fi
}

check_rds_public_access() {
  log ""
  log "CHECK 4: RDS public accessibility"

  local public_dbs
  public_dbs="$(aws rds describe-db-instances \
    --region "$REGION" \
    --query 'DBInstances[?PubliclyAccessible==`true`].[DBInstanceIdentifier]' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect RDS DB instances."
    return
  fi

  if [[ -n "$public_dbs" ]]; then
    fail "Publicly accessible RDS DB instance(s) found:"
    log "$public_dbs"
  else
    pass "No RDS DB instance is publicly accessible."
  fi
}

check_ebs_encryption() {
  log ""
  log "CHECK 5: EBS volume encryption"

  local unencrypted
  unencrypted="$(aws ec2 describe-volumes \
    --region "$REGION" \
    --query 'Volumes[?Encrypted==`false`].[VolumeId,State,Size]' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect EBS volumes."
    return
  fi

  if [[ -n "$unencrypted" ]]; then
    warn "Unencrypted EBS volume(s) found:"
    log "$unencrypted"
  else
    pass "All discovered EBS volumes are encrypted."
  fi
}

log "============================================================"
log "AWS SECURITY AND COST AUDIT"
log "Name: $FULL_NAME"
log "Region: $REGION"
log "Started: $(date)"
log "============================================================"

for check in "${checks[@]}"; do
  "$check"
done

log ""
log "============================================================"
log "FINAL SUMMARY"
log "PASS: $PASS_COUNT"
log "WARN: $WARN_COUNT"
log "FAIL: $FAIL_COUNT"
log "Report: $REPORT_FILE"
log "============================================================"

if [[ $FAIL_COUNT -gt 0 ]]; then
  log "OVERALL STATUS: FAIL"
  exit 2
elif [[ $WARN_COUNT -gt 0 ]]; then
  log "OVERALL STATUS: WARN"
  exit 1
else
  log "OVERALL STATUS: HEALTHY"
  exit 0
fi

set -u

# ============================================================
# AWS Security and Cost Audit
# Read-only: this script must never modify AWS resources.
# ============================================================

FULL_NAME="Peace Offor Nwadinachi"
REGION="eu-north-1"
REPORT_DIR="reports"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
REPORT_FILE="${REPORT_DIR}/aws-audit-${TIMESTAMP}.txt"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

checks=(
  "check_s3_public_access"
  "check_ssh_open_to_world"
  "check_mysql_open_to_world"
  "check_rds_public_access"
  "check_ebs_encryption"
)

mkdir -p "$REPORT_DIR"

log() {
  echo "$1" | tee -a "$REPORT_FILE"
}

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  log "[PASS] $1"
}

warn() {
  WARN_COUNT=$((WARN_COUNT + 1))
  log "[WARN] $1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  log "[FAIL] $1"
}

check_s3_public_access() {
  log ""
  log "CHECK 1: S3 public-access settings"

  local buckets
  buckets="$(aws s3api list-buckets \
    --query 'Buckets[].Name' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to list S3 buckets."
    return
  fi

  if [[ -z "$buckets" ]]; then
    pass "No S3 buckets found."
    return
  fi

  local finding=0

  for bucket in $buckets; do
    local block
    block="$(aws s3api get-public-access-block \
      --bucket "$bucket" \
      --query 'PublicAccessBlockConfiguration.[BlockPublicAcls,IgnorePublicAcls,BlockPublicPolicy,RestrictPublicBuckets]' \
      --output text 2>/dev/null)"

    if [[ $? -ne 0 ]]; then
      warn "Bucket $bucket has no readable bucket-level Public Access Block configuration."
      finding=1
      continue
    fi

    if [[ "$block" == $'True\tTrue\tTrue\tTrue' ]]; then
      log "  $bucket: all bucket-level Public Access Block settings enabled."
    else
      warn "Bucket $bucket does not have all four bucket-level Public Access Block settings enabled."
      finding=1
    fi
  done

  if [[ $finding -eq 0 ]]; then
    pass "S3 bucket-level Public Access Block settings passed."
  fi
}

check_ssh_open_to_world() {
  log ""
  log "CHECK 2: Security groups exposing SSH (22) to 0.0.0.0/0"

  local groups
  groups="$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --query "SecurityGroups[?IpPermissions[?IpProtocol=='tcp' && FromPort<=\`22\` && ToPort>=\`22\` && IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect security groups for SSH exposure."
    return
  fi

  if [[ -n "$groups" ]]; then
    warn "Security group(s) expose SSH port 22 to the whole IPv4 internet:"
    log "$groups"
  else
    pass "No security group exposes SSH port 22 to 0.0.0.0/0."
  fi
}

check_mysql_open_to_world() {
  log ""
  log "CHECK 3: Security groups exposing MySQL (3306) to 0.0.0.0/0"

  local groups
  groups="$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --query "SecurityGroups[?IpPermissions[?IpProtocol=='tcp' && FromPort<=\`3306\` && ToPort>=\`3306\` && IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect security groups for MySQL exposure."
    return
  fi

  if [[ -n "$groups" ]]; then
    fail "Security group(s) expose MySQL port 3306 to the whole IPv4 internet:"
    log "$groups"
  else
    pass "No security group exposes MySQL port 3306 to 0.0.0.0/0."
  fi
}

check_rds_public_access() {
  log ""
  log "CHECK 4: RDS public accessibility"

  local public_dbs
  public_dbs="$(aws rds describe-db-instances \
    --region "$REGION" \
    --query 'DBInstances[?PubliclyAccessible==`true`].[DBInstanceIdentifier]' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect RDS DB instances."
    return
  fi

  if [[ -n "$public_dbs" ]]; then
    fail "Publicly accessible RDS DB instance(s) found:"
    log "$public_dbs"
  else
    pass "No RDS DB instance is publicly accessible."
  fi
}

check_ebs_encryption() {
  log ""
  log "CHECK 5: EBS volume encryption"

  local unencrypted
  unencrypted="$(aws ec2 describe-volumes \
    --region "$REGION" \
    --query 'Volumes[?Encrypted==`false`].[VolumeId,State,Size]' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect EBS volumes."
    return
  fi

  if [[ -n "$unencrypted" ]]; then
    warn "Unencrypted EBS volume(s) found:"
    log "$unencrypted"
  else
    pass "All discovered EBS volumes are encrypted."
  fi
}

log "============================================================"
log "AWS SECURITY AND COST AUDIT"
log "Name: $FULL_NAME"
log "Region: $REGION"
log "Started: $(date)"
log "============================================================"

for check in "${checks[@]}"; do
  "$check"
done

log ""
log "============================================================"
log "FINAL SUMMARY"
log "PASS: $PASS_COUNT"
log "WARN: $WARN_COUNT"
log "FAIL: $FAIL_COUNT"
log "Report: $REPORT_FILE"
log "============================================================"

if [[ $FAIL_COUNT -gt 0 ]]; then
  log "OVERALL STATUS: FAIL"
  exit 2
elif [[ $WARN_COUNT -gt 0 ]]; then
  log "OVERALL STATUS: WARN"
  exit 1
else
  log "OVERALL STATUS: HEALTHY"
  exit 0
fi

# ============================================================
# AWS Security and Cost Audit
# Read-only: this script must never modify AWS resources.
# ============================================================

FULL_NAME="Peace Offor Nwadinachi"
REGION="eu-north-1"
REPORT_DIR="reports"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
REPORT_FILE="${REPORT_DIR}/aws-audit-${TIMESTAMP}.txt"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

checks=(
  "check_s3_public_access"
  "check_ssh_open_to_world"
  "check_mysql_open_to_world"
  "check_rds_public_access"
  "check_ebs_encryption"
)

mkdir -p "$REPORT_DIR"

log() {
  echo "$1" | tee -a "$REPORT_FILE"
}

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  log "[PASS] $1"
}

warn() {
  WARN_COUNT=$((WARN_COUNT + 1))
  log "[WARN] $1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  log "[FAIL] $1"
}

check_s3_public_access() {
  log ""
  log "CHECK 1: S3 public-access settings"

  local buckets
  buckets="$(aws s3api list-buckets \
    --query 'Buckets[].Name' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to list S3 buckets."
    return
  fi

  if [[ -z "$buckets" ]]; then
    pass "No S3 buckets found."
    return
  fi

  local finding=0

  for bucket in $buckets; do
    local block
    block="$(aws s3api get-public-access-block \
      --bucket "$bucket" \
      --query 'PublicAccessBlockConfiguration.[BlockPublicAcls,IgnorePublicAcls,BlockPublicPolicy,RestrictPublicBuckets]' \
      --output text 2>/dev/null)"

    if [[ $? -ne 0 ]]; then
      warn "Bucket $bucket has no readable bucket-level Public Access Block configuration."
      finding=1
      continue
    fi

    if [[ "$block" == $'True\tTrue\tTrue\tTrue' ]]; then
      log "  $bucket: all bucket-level Public Access Block settings enabled."
    else
      warn "Bucket $bucket does not have all four bucket-level Public Access Block settings enabled."
      finding=1
    fi
  done

  if [[ $finding -eq 0 ]]; then
    pass "S3 bucket-level Public Access Block settings passed."
  fi
}

check_ssh_open_to_world() {
  log ""
  log "CHECK 2: Security groups exposing SSH (22) to 0.0.0.0/0"

  local groups
  groups="$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --query "SecurityGroups[?IpPermissions[?IpProtocol=='tcp' && FromPort<=\`22\` && ToPort>=\`22\` && IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect security groups for SSH exposure."
    return
  fi

  if [[ -n "$groups" ]]; then
    warn "Security group(s) expose SSH port 22 to the whole IPv4 internet:"
    log "$groups"
  else
    pass "No security group exposes SSH port 22 to 0.0.0.0/0."
  fi
}

check_mysql_open_to_world() {
  log ""
  log "CHECK 3: Security groups exposing MySQL (3306) to 0.0.0.0/0"

  local groups
  groups="$(aws ec2 describe-security-groups \
    --region "$REGION" \
    --query "SecurityGroups[?IpPermissions[?IpProtocol=='tcp' && FromPort<=\`3306\` && ToPort>=\`3306\` && IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect security groups for MySQL exposure."
    return
  fi

  if [[ -n "$groups" ]]; then
    fail "Security group(s) expose MySQL port 3306 to the whole IPv4 internet:"
    log "$groups"
  else
    pass "No security group exposes MySQL port 3306 to 0.0.0.0/0."
  fi
}

check_rds_public_access() {
  log ""
  log "CHECK 4: RDS public accessibility"

  local public_dbs
  public_dbs="$(aws rds describe-db-instances \
    --region "$REGION" \
    --query 'DBInstances[?PubliclyAccessible==`true`].[DBInstanceIdentifier]' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect RDS DB instances."
    return
  fi

  if [[ -n "$public_dbs" ]]; then
    fail "Publicly accessible RDS DB instance(s) found:"
    log "$public_dbs"
  else
    pass "No RDS DB instance is publicly accessible."
  fi
}

check_ebs_encryption() {
  log ""
  log "CHECK 5: EBS volume encryption"

  local unencrypted
  unencrypted="$(aws ec2 describe-volumes \
    --region "$REGION" \
    --query 'Volumes[?Encrypted==`false`].[VolumeId,State,Size]' \
    --output text 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    fail "Unable to inspect EBS volumes."
    return
  fi

  if [[ -n "$unencrypted" ]]; then
    warn "Unencrypted EBS volume(s) found:"
    log "$unencrypted"
  else
    pass "All discovered EBS volumes are encrypted."
  fi
}

log "============================================================"
log "AWS SECURITY AND COST AUDIT"
log "Name: $FULL_NAME"
log "Region: $REGION"
log "Started: $(date)"
log "============================================================"

for check in "${checks[@]}"; do
  "$check"
done

log ""
log "============================================================"
log "FINAL SUMMARY"
log "PASS: $PASS_COUNT"
log "WARN: $WARN_COUNT"
log "FAIL: $FAIL_COUNT"
log "Report: $REPORT_FILE"
log "============================================================"

if [[ $FAIL_COUNT -gt 0 ]]; then
  log "OVERALL STATUS: FAIL"
  exit 2
elif [[ $WARN_COUNT -gt 0 ]]; then
  log "OVERALL STATUS: WARN"
  exit 1
else
  log "OVERALL STATUS: HEALTHY"
  exit 0
fi
