const express = require('express');
const bodyParser = require('body-parser');
const { pool, generateUniqueId } = require('./db');

const app = express();
const port = 3000;

app.use(bodyParser.json());

// Endpoint to register a new patient
app.post('/register', async (req, res) => {
  const {
    name, gender, age, mobile_number, email, dob, height, weight, blood_group,
    aadhaar_no, marital_status, occupation, emergency_contact_no, smoking,
    alcohol_consumption, address
  } = req.body;

  try {
    const uniqueId = await generateUniqueId();
    const result = await pool.query(
      `INSERT INTO patients_buffer (
        unique_id, name, gender, age, mobile_number, email, dob, height, weight,
        blood_group, aadhaar_no, marital_status, occupation, emergency_contact_no,
        smoking, alcohol_consumption, address
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17
      ) RETURNING id`,
      [
        uniqueId, name, gender, age, mobile_number, email, dob, height, weight, blood_group,
        aadhaar_no, marital_status, occupation, emergency_contact_no, smoking, alcohol_consumption, address
      ]
    );
    const newPatientId = result.rows[0].id;
    res.status(201).json({ id: newPatientId, unique_id: uniqueId });
  } catch (error) {
    res.status(500).send('Error registering patient: ' + error.message);
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
