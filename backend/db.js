const { Pool } = require('pg');

// Configure the PostgreSQL connection pool
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'LabDiagnosticApp',
  password: 'charu0517',
  port: 5432,
});

// Function to handle database connection errors
pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

// Log a message when the connection to the database is established successfully
pool.on('connect', () => {
  console.log('Connected to PostgreSQL database');
});

// Function to generate a unique 12-digit ID
const generateUniqueId = async () => {
  while (true) {
    const uniqueId = Math.floor(100000000000 + Math.random() * 900000000000).toString();
    const result = await pool.query(
      'SELECT unique_id FROM patients WHERE unique_id = $1 UNION SELECT unique_id FROM patients_buffer WHERE unique_id = $1 UNION SELECT unique_id FROM medical_experts WHERE unique_id = $1 UNION SELECT unique_id FROM medical_experts_buffer WHERE unique_id = $1',
      [uniqueId]
    );
    if (result.rows.length === 0) {
      return uniqueId;
    }
  }
};

module.exports = { pool, generateUniqueId };


// const admin = require('firebase-admin');
// const serviceAccount = require('C:\Users\Charumadhi\Downloads\labdiagnosticsapp-firebase-adminsdk-s32e6-8c6132071c.json');

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount)
// });

// const db = admin.firestore();


// const generateUniqueId = async () => {
//   while (true) {
//     const uniqueId = Math.floor(100000000000 + Math.random() * 900000000000).toString();

//     // // Check PostgreSQL
//     // const result = await pool.query(
//     //   'SELECT unique_id FROM patients WHERE unique_id = $1 UNION SELECT unique_id FROM patients_buffer WHERE unique_id = $1 UNION SELECT unique_id FROM medical_experts WHERE unique_id = $1 UNION SELECT unique_id FROM medical_experts_buffer WHERE unique_id = $1',
//     //   [uniqueId]
//     // );

//     if (result.rows.length === 0) {
//       // If the ID is not in PostgreSQL, check Firebase
//       const patientsSnapshot = await db.collection('patients').where('unique_id', '==', uniqueId).get();
//       const expertsSnapshot = await db.collection('medical_experts').where('unique_id', '==', uniqueId).get();

//       if (patientsSnapshot.empty && expertsSnapshot.empty) {
//         return uniqueId; // Return the unique ID if not found in both databases
//       }
//     }
//   }
// };
