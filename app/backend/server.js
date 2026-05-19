const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST || "postgres",
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "employeesdb",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "postgres"
});

app.get("/health", async (req, res) => {
  res.status(200).json({ status: "ok", service: "backend" });
});

app.get("/employees", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM employees ORDER BY id ASC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch employees" });
  }
});

app.post("/employees", async (req, res) => {
  const { name, role, department, email } = req.body;

  try {
    const result = await pool.query(
      "INSERT INTO employees (name, role, department, email) VALUES ($1, $2, $3, $4) RETURNING *",
      [name, role, department, email]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to create employee" });
  }
});

app.put("/employees/:id", async (req, res) => {
  const { id } = req.params;
  const { name, role, department, email } = req.body;

  try {
    const result = await pool.query(
      "UPDATE employees SET name=$1, role=$2, department=$3, email=$4 WHERE id=$5 RETURNING *",
      [name, role, department, email, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Employee not found" });
    }

    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to update employee" });
  }
});

app.delete("/employees/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool.query("DELETE FROM employees WHERE id=$1 RETURNING *", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Employee not found" });
    }

    res.json({ message: "Employee deleted" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete employee" });
  }
});

app.listen(port, () => {
  console.log(`Backend API running on port ${port}`);
});