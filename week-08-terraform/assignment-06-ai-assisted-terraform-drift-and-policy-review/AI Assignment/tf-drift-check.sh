#!/bin/bash

set -u

full_name="Peace Offor Nwadinachi"
tf_dir="."

plan_binary="tfplan.out"
plan_json="tfplan.json"
report_dir="reports"
report_file="$report_dir/tf-drift-report.txt"

checks=(
  check_plan_exit_code
  check_destructive_actions
  check_open_ingress
)

mkdir -p "$report_dir"

plan_exit_code=0
destructive_status="PASS"
ingress_status="PASS"
overall_status="HEALTHY"

check_plan_exit_code() {
  if [ "$plan_exit_code" -eq 0 ]; then
    echo "PASS - Terraform plan exit code: 0"
  else
    echo "FAIL - Terraform plan exit code: $plan_exit_code"
    overall_status="FAIL"
  fi
}

check_destructive_actions() {
  destructive_count=$(jq '
    [
      .resource_changes[]?
      | select(
          (.change.actions | index("delete")) != null
        )
    ]
    | length
  ' "$plan_json")

  if [ "$destructive_count" -eq 0 ]; then
    echo "PASS - No destructive changes detected"
  else
    echo "FAIL - Destructive Terraform changes detected: $destructive_count"
    destructive_status="FAIL"
    overall_status="FAIL"
  fi
}

check_open_ingress() {
  unsafe_ingress_count=$(jq '
    [
      .resource_changes[]?
      | select(
          (.type == "aws_security_group_rule"
           or .type == "aws_vpc_security_group_ingress_rule")
        )
      | .change.after?
      | select(. != null)
      | select(
          ((.cidr_blocks? // []) | index("0.0.0.0/0")) != null
          or
          ((.ipv6_cidr_blocks? // []) | index("::/0")) != null
          or
          ((.cidr_ipv4? // "") == "0.0.0.0/0")
          or
          ((.cidr_ipv6? // "") == "::/0")
        )
    ]
    | length
  ' "$plan_json")

  if [ "$unsafe_ingress_count" -eq 0 ]; then
    echo "PASS - No unsafe ingress changes detected"
  else
    echo "WARN - Unsafe ingress changes detected: $unsafe_ingress_count"
    ingress_status="WARN"
    overall_status="WARN"
  fi
}

cd "$tf_dir" || exit 1

terraform plan -out="$plan_binary" -detailed-exitcode >/dev/null
plan_exit_code=$?

if [ "$plan_exit_code" -eq 0 ] || [ "$plan_exit_code" -eq 2 ]; then
  terraform show -json "$plan_binary" > "$plan_json"
else
  overall_status="FAIL"
fi

{
  echo "Terraform Drift Check Report"
  echo "============================"
  echo "Full Name: $full_name"
  echo
  echo "Terraform plan exit code: $plan_exit_code"
  echo

  if [ -f "$plan_json" ]; then
    for check in "${checks[@]}"; do
      "$check"
    done
  else
    echo "FAIL - Terraform plan JSON was not generated"
    overall_status="FAIL"
  fi

  echo
  echo "Overall Status: $overall_status"
} | tee "$report_file"

if [ "$overall_status" = "HEALTHY" ]; then
  exit 0
else
  exit 1
fi
