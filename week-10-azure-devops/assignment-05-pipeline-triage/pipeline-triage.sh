#!/bin/bash

set -u

# ============================================================
# Student / Azure DevOps configuration
# ============================================================
full_name="Peace Nwadinachi Offor"
provider="azure-devops"

ado_org="https://dev.azure.com/DMI-Cohort3-PeaceOffor"
ado_project="Self-Hosted-Agent"

infra_pipeline_id="4"
app_pipeline_id="5"

# ============================================================
# Report and raw-log files
# ============================================================
base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
report_dir="$base_dir/reports"

report_file="$report_dir/pipeline-health-report.txt"
infra_log_file="$report_dir/infra-last-run.log"
app_log_file="$report_dir/app-last-run.log"

infra_run_id=""
app_run_id=""
infra_run_result=""
app_run_result=""

current_log_file=""
current_pipeline_name=""

checks=(
  check_dependency_failure
  check_build_failure
  check_test_failure
  check_auth_failure
  check_agent_failure
)

pass_count=0
warning_count=0
failure_count=0
retrieval_error=0

mkdir -p "$report_dir"
: > "$report_file"
: > "$infra_log_file"
: > "$app_log_file"

write_line() {
  echo "$1" | tee -a "$report_file"
}

mark_pass() {
  write_line "[PASS] $1"
  pass_count=$((pass_count + 1))
}

mark_warning() {
  write_line "[WARN] $1"
  warning_count=$((warning_count + 1))
}

mark_failure() {
  write_line "[FAIL] $1"
  failure_count=$((failure_count + 1))
}

print_header() {
  write_line "========================================"
  write_line "Azure DevOps Dual-Pipeline Triage Report"
  write_line "========================================"
  write_line "Full Name: $full_name"
  write_line "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  write_line "Provider: $provider"
  write_line "Project: $ado_project"
  write_line ""
}

# ============================================================
# Read-only Azure DevOps retrieval functions
# ============================================================

get_latest_run_metadata() {
  local pipeline_id="$1"
  local run_id

  run_id=$(az pipelines runs list \
    --organization "$ado_org" \
    --project "$ado_project" \
    --pipeline-ids "$pipeline_id" \
    --status completed \
    --top 1 \
    --query "[0].id" \
    -o tsv 2>/dev/null || true)

  echo "$run_id"
}

get_run_result() {
  local run_id="$1"

  az pipelines runs show \
    --organization "$ado_org" \
    --project "$ado_project" \
    --id "$run_id" \
    --query "result" \
    -o tsv 2>/dev/null || true
}

get_access_token() {
  # Obtain an Azure CLI token at runtime.
  # The token is never printed, written to a report, or stored in a file.
  az account get-access-token \
    --resource 499b84ac-1321-427f-aa17-267ca6975798 \
    --query accessToken \
    -o tsv 2>/dev/null || true
}

fetch_build_logs() {
  local run_id="$1"
  local destination="$2"
  local log_ids
  local log_id
  local temp_dir

  : > "$destination"

  log_ids=$(az devops invoke \
    --organization "$ado_org" \
    --area build \
    --resource logs \
    --route-parameters \
      project="$ado_project" \
      buildId="$run_id" \
    --api-version 7.1 \
    --query "value[].id" \
    -o tsv 2>/dev/null || true)

  if [ -z "$log_ids" ]; then
    return 1
  fi

  temp_dir=$(mktemp -d)

  for log_id in $log_ids; do
    if ! az devops invoke \
      --organization "$ado_org" \
      --area build \
      --resource logs \
      --route-parameters \
        project="$ado_project" \
        buildId="$run_id" \
        logId="$log_id" \
      --api-version 7.1 \
      --accept-media-type "text/plain" \
      --out-file "$temp_dir/log-$log_id.txt" \
      >/dev/null 2>&1
    then
      rm -rf "$temp_dir"
      return 1
    fi

    {
      echo
      echo "===== Azure DevOps Log ID: $log_id ====="
      cat "$temp_dir/log-$log_id.txt"
    } >> "$destination"
  done

  rm -rf "$temp_dir"

  if [ -s "$destination" ]; then
    return 0
  else
    return 1
  fi
}

fetch_pipeline_evidence() {
  local pipeline_name="$1"
  local pipeline_id="$2"
  local destination="$3"
  local run_id
  local run_result

  run_id=$(get_latest_run_metadata "$pipeline_id")

  if [ -z "$run_id" ]; then
    write_line "[ERROR] Unable to retrieve latest completed run for $pipeline_name."
    retrieval_error=1
    return
  fi

  run_result=$(get_run_result "$run_id")

  write_line "$pipeline_name Run ID: $run_id"
  write_line "$pipeline_name Result: ${run_result:-unknown}"

  if fetch_build_logs "$run_id" "$destination"; then
    write_line "$pipeline_name console logs retrieved successfully."
  else
    write_line "[ERROR] Unable to retrieve console logs for $pipeline_name."
    retrieval_error=1
  fi

  if [ "$pipeline_name" = "Infrastructure Pipeline" ]; then
    infra_run_id="$run_id"
    infra_run_result="$run_result"
  else
    app_run_id="$run_id"
    app_run_result="$run_result"
  fi

  write_line ""
}

# ============================================================
# Log-analysis checks
# ============================================================

check_dependency_failure() {
  if grep -qiE \
    "npm ERR!|ENOENT|ERESOLVE|pip install.*error|ModuleNotFoundError|package not found" \
    "$current_log_file" 2>/dev/null; then
    mark_failure "$current_pipeline_name: Dependency install failure detected"
  else
    mark_pass "$current_pipeline_name: No dependency install failure detected"
  fi
}

check_build_failure() {
  if grep -qiE \
    "build failed|compilation error|SyntaxError|TS[0-9]{4}|webpack.*failed|exit code 1" \
    "$current_log_file" 2>/dev/null; then
    mark_failure "$current_pipeline_name: Build or compile failure detected"
  else
    mark_pass "$current_pipeline_name: No build or compile failure detected"
  fi
}

check_test_failure() {
  if grep -qiE \
    "tests? failed|AssertionError|(^|[[:space:]])FAIL([[:space:]]|$)|[0-9]+ failing|expect\(received\)" \
    "$current_log_file" 2>/dev/null; then
    mark_failure "$current_pipeline_name: Test failure detected"
  else
    mark_pass "$current_pipeline_name: No test failure detected"
  fi
}

check_auth_failure() {
  if grep -qiE \
    "401 Unauthorized|403 Forbidden|TF400813|invalid_grant|token has expired|permission denied \(publickey\)|Bad credentials" \
    "$current_log_file" 2>/dev/null; then
    mark_failure "$current_pipeline_name: Authentication or permission failure detected"
  else
    mark_pass "$current_pipeline_name: No authentication or permission failure detected"
  fi
}

check_agent_failure() {
  if grep -qiE \
    "no agent found|agent.*offline|timed out waiting for an agent|job.*timed out|runner.*offline" \
    "$current_log_file" 2>/dev/null; then
    mark_warning "$current_pipeline_name: Agent or runner availability issue detected"
  else
    mark_pass "$current_pipeline_name: No agent or runner availability issue detected"
  fi
}

analyze_pipeline() {
  current_pipeline_name="$1"
  current_log_file="$2"

  write_line "Analyzing $current_pipeline_name..."

  for check_function in "${checks[@]}"; do
    "$check_function"
  done

  write_line ""
}

check_pipeline_results() {
  if [ "$infra_run_result" = "failed" ]; then
    mark_failure "Infrastructure Pipeline run result is 'failed'"
  elif [ "$infra_run_result" = "succeeded" ]; then
    mark_pass "Infrastructure Pipeline latest run succeeded"
  else
    mark_warning "Infrastructure Pipeline result is '${infra_run_result:-unknown}'"
  fi

  if [ "$app_run_result" = "failed" ]; then
    mark_failure "Application Pipeline run result is 'failed'"
  elif [ "$app_run_result" = "succeeded" ]; then
    mark_pass "Application Pipeline latest run succeeded"
  else
    mark_warning "Application Pipeline result is '${app_run_result:-unknown}'"
  fi
}

print_summary() {
  local overall_status
  local script_exit_code

  if [ "$retrieval_error" -gt 0 ]; then
    overall_status="ERROR"
    script_exit_code=3
  elif [ "$failure_count" -gt 0 ]; then
    overall_status="FAIL"
    script_exit_code=2
  elif [ "$warning_count" -gt 0 ]; then
    overall_status="WARN"
    script_exit_code=1
  else
    overall_status="HEALTHY"
    script_exit_code=0
  fi

  write_line "Summary:"
  write_line "PASS: $pass_count"
  write_line "WARN: $warning_count"
  write_line "FAIL: $failure_count"
  write_line "Overall Status: $overall_status"
  write_line "Script Exit Code: $script_exit_code"
  write_line "Report File: $report_file"
  write_line "Infrastructure Log File: $infra_log_file"
  write_line "Application Log File: $app_log_file"

  return "$script_exit_code"
}

# ============================================================
# Main
# ============================================================

print_header

if ! command -v az >/dev/null 2>&1; then
  write_line "[ERROR] Azure CLI is not installed or unavailable."
  exit 3
fi

if ! command -v curl >/dev/null 2>&1; then
  write_line "[ERROR] curl is not installed or unavailable."
  exit 3
fi

if ! command -v jq >/dev/null 2>&1; then
  write_line "[ERROR] jq is not installed or unavailable."
  exit 3
fi

fetch_pipeline_evidence \
  "Infrastructure Pipeline" \
  "$infra_pipeline_id" \
  "$infra_log_file"

fetch_pipeline_evidence \
  "Application Pipeline" \
  "$app_pipeline_id" \
  "$app_log_file"

analyze_pipeline "Infrastructure Pipeline" "$infra_log_file"
analyze_pipeline "Application Pipeline" "$app_log_file"

check_pipeline_results

print_summary
exit $?