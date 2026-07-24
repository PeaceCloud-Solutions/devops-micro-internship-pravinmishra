const awsAccessKey = "AKIAIOSFODNN7EXAMPLE";

console.log("DEBUG: testing the PR-ready workflow");

function getDeploymentStatus() {
  return "ready";
}

console.log(getDeploymentStatus());