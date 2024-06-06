const { Pool } = require('pg');

// Configure the PostgreSQL connection pool
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'LabDiagnosticApp',
  password: 'charu0517',
  port: 5432,
});

// Function to generate a unique 12-digit ID
const generateUniqueId = async () => {
  while (true) {
    const uniqueId = Math.floor(100000000000 + Math.random() * 900000000000).toString();
    const result = await pool.query(
      'SELECT unique_id FROM patients WHERE unique_id = $1 UNION SELECT unique_id FROM patients_buffer WHERE unique_id = $1',
      [uniqueId]
    );
    if (result.rows.length === 0) {
      return uniqueId;
    }
  }
};

module.exports = { pool, generateUniqueId };
