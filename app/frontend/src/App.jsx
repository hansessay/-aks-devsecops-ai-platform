import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import "./style.css";

const API_URL = import.meta.env.VITE_API_URL || "/api";

function App() {
  const [employees, setEmployees] = useState([]);
  const [form, setForm] = useState({
    name: "",
    role: "",
    department: "",
    email: ""
  });

  const loadEmployees = async () => {
    const res = await fetch(`${API_URL}/employees`);
    const data = await res.json();
    setEmployees(data);
  };

  useEffect(() => {
    loadEmployees();
  }, []);

  const createEmployee = async (e) => {
    e.preventDefault();

    await fetch(`${API_URL}/employees`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(form)
    });

    setForm({ name: "", role: "", department: "", email: "" });
    loadEmployees();
  };

  const deleteEmployee = async (id) => {
    await fetch(`${API_URL}/employees/${id}`, {
      method: "DELETE"
    });

    loadEmployees();
  };

  return (
    <main className="container">
      <section className="hero">
        <h1>AKS DevSecOps Employee Portal</h1>
        <p>Frontend → Backend API → PostgreSQL running on Kubernetes</p>
      </section>

      <section className="card">
        <h2>Add Employee</h2>
        <form onSubmit={createEmployee} className="form">
          <input placeholder="Name" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} required />
          <input placeholder="Role" value={form.role} onChange={(e) => setForm({ ...form, role: e.target.value })} required />
          <input placeholder="Department" value={form.department} onChange={(e) => setForm({ ...form, department: e.target.value })} required />
          <input placeholder="Email" type="email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} required />
          <button type="submit">Create</button>
        </form>
      </section>

      <section className="card">
        <h2>Employees</h2>
        <div className="grid">
          {employees.map((employee) => (
            <div className="employee" key={employee.id}>
              <h3>{employee.name}</h3>
              <p>{employee.role}</p>
              <p>{employee.department}</p>
              <p>{employee.email}</p>
              <button className="danger" onClick={() => deleteEmployee(employee.id)}>
                Delete
              </button>
            </div>
          ))}
        </div>
      </section>
    </main>
  );
}

createRoot(document.getElementById("root")).render(<App />);