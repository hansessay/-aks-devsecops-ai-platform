from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

NAMESPACE = "3tirewebapp-dev"


def run_cmd(cmd):
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        return result.stderr
    return result.stdout


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


@app.route("/ask", methods=["POST"])
def ask():
    question = request.json.get("question", "").lower()

    if "pods" in question or "status" in question or "issues" in question or "failed" in question:
        pods_raw = run_cmd(["kubectl", "get", "pods", "-n", NAMESPACE])

        lines = pods_raw.split("\n")[1:]
        summary = []
        issues = []

        for line in lines:
            if not line.strip():
                continue

            parts = line.split()
            name = parts[0]
            ready = parts[1]
            status = parts[2]
            restarts = parts[3]
            age = parts[4]

            summary.append({
                "pod": name,
                "ready": ready,
                "status": status,
                "restarts": restarts,
                "age": age
            })

            if status not in ["Running", "Completed"]:
                issues.append({
                    "pod": name,
                    "problem": f"Pod is in {status}",
                    "recommendation": "Check pod logs and Kubernetes events."
                })

            if restarts != "0":
                issues.append({
                    "pod": name,
                    "problem": f"Pod has {restarts} restarts",
                    "recommendation": "Check application logs for crashes or readiness probe failures."
                })

        if not issues:
            issues.append({
                "status": "healthy",
                "message": "No obvious pod issues detected."
            })

        return jsonify({
            "answer": "Pod health analysis completed.",
            "namespace": NAMESPACE,
            "summary": summary,
            "issues": issues
        })

    if "services" in question or "svc" in question:
        services = run_cmd(["kubectl", "get", "svc", "-n", NAMESPACE])
        return jsonify({
            "answer": "Here are the services.",
            "data": services
        })

    if "events" in question:
        events = run_cmd(["kubectl", "get", "events", "-n", NAMESPACE, "--sort-by=.lastTimestamp"])
        return jsonify({
            "answer": "Here are recent Kubernetes events.",
            "data": events[-4000:]
        })

    return jsonify({
        "answer": "Ask me about pod status, failed pods, services, or events."
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)