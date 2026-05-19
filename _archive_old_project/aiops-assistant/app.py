from flask import Flask, jsonify
from kubernetes import client, config
import os

app = Flask(__name__)

NAMESPACE = os.getenv("CHECK_NAMESPACE", "3tirewebapp-dev")

try:
    config.load_incluster_config()
except:
    config.load_kube_config()

v1 = client.CoreV1Api()
apps = client.AppsV1Api()

@app.route("/")
def home():
    return jsonify({
        "service": "AIOps Assistant",
        "status": "running",
        "namespace_checked": NAMESPACE
    })

@app.route("/health")
def health():
    return jsonify({"status": "healthy"})

@app.route("/analyze")
def analyze():
    pods = v1.list_namespaced_pod(namespace=NAMESPACE)
    findings = []

    for pod in pods.items:
        pod_name = pod.metadata.name
        phase = pod.status.phase

        if phase != "Running" and phase != "Succeeded":
            findings.append({
                "pod": pod_name,
                "status": phase,
                "recommendation": "Check pod events, image pull errors, secrets, and resource limits."
            })

        for container in pod.status.container_statuses or []:
            if container.restart_count > 0:
                findings.append({
                    "pod": pod_name,
                    "container": container.name,
                    "restart_count": container.restart_count,
                    "recommendation": "Investigate logs, readiness probes, memory limits, and application errors."
                })

    if not findings:
        findings.append({
            "message": "No major pod issues detected.",
            "recommendation": "Cluster workload looks healthy."
        })

    return jsonify({
        "namespace": NAMESPACE,
        "findings": findings
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)