const express = require('express');
const bodyParser = require('body-parser');
const { pool, generateUniqueId } = require('./db'); // Ensure this import is correct
const bcrypt = require('bcrypt');
const uuid = require('uuid');
const geolib = require('geolib'); //The "geolib" library is used to calculate distances between coordinates.
const nodemailer = require('nodemailer');
require('dotenv').config();
const multer = require('multer');
const path = require('path');
const fs = require('fs');


const app = express();
const port = 3000;

app.use(bodyParser.json());
// Middleware to parse JSON bodies
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Server is running');
});

// Helper function to check user credentials
const checkUserCredentials = async (email, password) => {
  const tables = ['patients_buffer', 'medical_experts_buffer', 'technicalexperts_buffer', 'remote_technical_experts_buffer'];
  for (const table of tables) {
    const result = await pool.query(`SELECT * FROM ${table} WHERE email = $1`, [email]);
    if (result.rows.length > 0) {
      const user = result.rows[0];
      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (isPasswordValid) {
        return { user, type: table };
      }
    }
  }
  return null;
};

//Endpoint to handle user login
app.post('/login', async (req, res) => {
  console.log('Login endpoint called');
  const { username, password } = req.body;

  try {
    console.log('Checking user credentials');
    const userInfo = await checkUserCredentials(username, password);

    if (userInfo) {
      console.log('Login successful');
      res.status(200).json({ message: 'Login successful', user: userInfo.user, type: userInfo.type });
    } else {
      console.log('Invalid username or password');
      res.status(401).json({ message: 'Invalid username or password' });
    }
  } catch (error) {
    console.error('Error logging in:', error);
    res.status(500).json({ message: 'Error logging in', error: error.message });
  }
});

// Endpoint to register a new patient
app.post('/register_patient', async (req, res) => {
  const { name, gender, age, mobile_number, email, dob, height, weight, blood_group, aadhaar_no, marital_status, occupation, emergency_contact_no, smoking, alcohol_consumption, address, password } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const uniqueId = await generateUniqueId();

    const result = await pool.query(
      `INSERT INTO patients_buffer (unique_id, name, gender, age, mobile_number, email, dob, height, weight, blood_group, aadhaar_no, marital_status, occupation, emergency_contact_no, smoking, alcohol_consumption, address, password)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)
      RETURNING id`,
      [uniqueId, name, gender, age, mobile_number, email, dob, height, weight, blood_group, aadhaar_no, marital_status, occupation, emergency_contact_no, smoking, alcohol_consumption, address, hashedPassword]
    );

    res.status(201).json({ id: result.rows[0].id, unique_id: uniqueId });
  } catch (error) {
    res.status(500).send('Error registering patient: ' + error.message);
  }
});

// Endpoint to get doctor details by email
app.get('/getDoctorDetails', async (req, res) => {
  const email = req.query.email;

  // Log the email received from the query parameter
  console.log('Received request to get doctor details for email:', email);

  if (!email) {
    console.log('No email provided in the request');
    return res.status(400).json({ error: 'Email is required' });
  }

  try {
    // Log the query being executed
    console.log('Executing query to fetch doctor details...');
    const result = await pool.query('SELECT * FROM medical_experts_buffer WHERE email = $1', [email]);

    if (result.rows.length === 0) {
      console.log('No doctor found for the provided email:', email);
      return res.status(404).json({ error: 'Doctor not found' });
    }

    const doctor = result.rows[0];

    // Log the doctor details fetched from the database
    console.log('Doctor details fetched successfully:', doctor);

    res.json({
      name: doctor.name,
      age: doctor.age,  // Include age
      dob: doctor.dob,  // Include dob
      specialization: doctor.specialization,
      experience: doctor.experience,
      qualifications: doctor.qualifications,
      registrations: doctor.registrations,
      working_hospital: doctor.working_hospital,
      email: doctor.email,
      mobile: doctor.mobile,
      address: doctor.address,
      unique_id: doctor.unique_id 
    });
    console.log("Sent to flutter!!");
  } catch (error) {
    console.error('Error fetching doctor details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


// Endpoint to get patient details by email
app.get('/getPatientDetails', async (req, res) => {
  const email = req.query.email;

  // Log the email received from the query parameter
  console.log('Received request to get patient details for email:', email);
  
  if (!email) {
    console.log('No email provided in the request');
    return res.status(400).json({ error: 'Email is required' });
  }

  try {
    // Log the query being executed
    console.log('Executing query to fetch patient details...');
    const result = await pool.query('SELECT * FROM patients_buffer WHERE email = $1', [email]);

    if (result.rows.length === 0) {
      console.log('No patient found for the provided email:', email);
      return res.status(404).json({ error: 'Patient not found' });
    }

    const patient = result.rows[0];

    // Log the patient details fetched from the database
    console.log('Patient details fetched successfully:', patient);

    res.json({
      name: patient.name,
      gender: patient.gender,
      age: patient.age,
      mobile_number: patient.mobile_number,
      email: patient.email,
      dob: patient.dob,
      height: patient.height,
      weight: patient.weight,
      blood_group: patient.blood_group,
      aadhaar_no: patient.aadhaar_no,
      marital_status: patient.marital_status,
      occupation: patient.occupation,
      emergency_contact_no: patient.emergency_contact_no,
      address: patient.address,
      smoking: patient.smoking,
      alcohol_consumption: patient.alcohol_consumption,
      unique_id: patient.unique_id 
    });
  } catch (error) {
    console.error('Error fetching patient details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.put('/updatePatientProfile', async (req, res) => {
  const patientDetails = req.body;

  const {
    email, name, gender, age, mobile_number, dob, height, weight, blood_group, aadhaar_no, marital_status, occupation, emergency_contact_no, address, smoking, alcohol_consumption
  } = patientDetails;

  try {
    const result = await pool.query(
      `UPDATE patients_buffer 
       SET name = $1, gender = $2, age = $3, mobile_number = $4, dob = $5, height = $6, weight = $7, 
           blood_group = $8, aadhaar_no = $9, marital_status = $10, occupation = $11, 
           emergency_contact_no = $12, address = $13, smoking = $14, alcohol_consumption = $15 
       WHERE email = $16`,
      [name, gender, age, mobile_number, dob, height, weight, blood_group, aadhaar_no, marital_status, 
       occupation, emergency_contact_no, address, smoking, alcohol_consumption, email]
    );

    res.status(200).json({ message: 'Profile updated successfully' });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


// Endpoint to register a new medical expert
app.post('/register_medical_expert', async (req, res) => {
  const { name, age, gender, mobile, email, dob, specialization, experience, qualifications, registrations, address, working_hospital, password } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const uniqueId = await generateUniqueId();

    const result = await pool.query(
      `INSERT INTO medical_experts_buffer (unique_id, name, age, gender, mobile, email, dob, specialization, experience, qualifications, registrations, address, working_hospital, password)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
      RETURNING id`,
      [uniqueId, name, age, gender, mobile, email, dob, specialization, experience, qualifications, registrations, address, working_hospital, hashedPassword]
    );

    res.status(201).json({ id: result.rows[0].id, unique_id: uniqueId });
  } catch (error) {
    res.status(500).send('Error registering medical expert: ' + error.message);
  }
});

// Endpoint to update doctor profile details
app.put('/updateDoctorProfile', async (req, res) => {
  const doctorDetails = req.body;

  const {
    name, age, mobile, email, dob, specialization, experience, qualifications, registrations, address, working_hospital
  } = doctorDetails;

  try {
    const result = await pool.query(
      `UPDATE medical_experts_buffer
       SET name = $1, age = $2, mobile = $3, dob = $4, specialization = $5,
           experience = $6, qualifications = $7, registrations = $8,
           address = $9, working_hospital = $10
       WHERE email = $11`,
      [
        name, age, mobile, dob, specialization, experience, qualifications, registrations, address, working_hospital, email
      ]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Doctor not found' });
    }

    res.status(200).json({ message: 'Doctor profile updated successfully' });
  } catch (error) {
    console.error('Error updating doctor profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});



app.post('/register_technical_expert', async (req, res) => {
  const {
    full_name, email, mobile_number, age, gender, dob, educational_qualification, work_experience, lab_name, lab_address, lab_mobile_number, password
  } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const uniqueId = await generateUniqueId();

    const result = await pool.query(
      'INSERT INTO technicalexperts_buffer (unique_id, full_name, email, mobile_number, age, gender, dob, educational_qualification, work_experience, lab_name, lab_address, lab_mobile_number, password) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) RETURNING *',
      [
        uniqueId, full_name, email, mobile_number, age, gender, dob, educational_qualification, work_experience, lab_name, lab_address, lab_mobile_number, hashedPassword
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Failed to register technical expert:', err);
    res.status(500).json({ error: 'Failed to register technical expert: ' + err.message });
  }
});


// Endpoint to get lab details
app.post('/getLabDetails', async (req, res) => {
  const { email } = req.body;
  console.log(email);

  try {
    // Query to fetch technical expert details based on email
    const query = {
      text: 'SELECT lab_name FROM technicalexperts_buffer WHERE email = $1',
      values: [email],
    };

    const result = await pool.query(query);
    console.log(result);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Technical expert not found' });
    }

    // Extract lab_name from the result of the first query
    const { lab_name } = result.rows[0];
    console.log(lab_name);

    // Query lab details based on lab_name
    const labQuery = {
      text: 'SELECT * FROM lab WHERE name = $1',
      values: [lab_name],
    };

    const labResult = await pool.query(labQuery);
    console.log(labResult);

    if (labResult.rows.length === 0) {
      return res.status(404).json({ error: 'Lab details not found' });
    }

    const labDetails = labResult.rows[0];

    // Send lab details to client application
    res.status(200).json({ labDetails });
    console.log(labDetails);
    console.log("Sent the lab details to flutter successfully!");

  } catch (error) {
    console.error('Error during getLabDetails:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});



app.post('/register_remote_technical_expert', async (req, res) => {
  const {
    full_name, age, gender, email, mobile_number, dob, educational_qualification, work_experience, password
  } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const uniqueId = await generateUniqueId();

    const result = await pool.query(
      'INSERT INTO remote_technical_experts_buffer (unique_id, full_name, age, gender, email, mobile_number, dob, educational_qualification, work_experience, password) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *',
      [
        uniqueId, full_name, age, gender, email, mobile_number, dob, educational_qualification, work_experience, hashedPassword
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Failed to register remote technical expert:', err);
    res.status(500).json({ error: 'Failed to register remote technical expert: ' + err.message });
  }
});



// Endpoint to retrieve patient profile details
app.post('/profile', async (req, res) => {
  const { username, password } = req.body;

  try {
    const userInfo = await checkUserCredentials(username, password);

    if (userInfo) {
      res.status(200).json(userInfo.user);
    } else {
      res.status(401).json({ message: 'Invalid username or password' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving profile', error: error.message });
  }
});

// Endpoint to update patient profile details
app.put('/update_patient_profile', async (req, res) => {
  const { id, name, gender, age, mobile_number, email, dob, height, weight, blood_group, aadhaar_no, marital_status, occupation, emergency_contact_no, smoking, alcohol_consumption, address } = req.body;

  try {
    await pool.query(
      `UPDATE patients_buffer
      SET name = $1, gender = $2, age = $3, mobile_number = $4, email = $5, dob = $6, height = $7, weight = $8, blood_group = $9, aadhaar_no = $10, marital_status = $11, occupation = $12, emergency_contact_no = $13, smoking = $14, alcohol_consumption = $15, address = $16
      WHERE id = $17`,
      [name, gender, age, mobile_number, email, dob, height, weight, blood_group, aadhaar_no, marital_status, occupation, emergency_contact_no, smoking, alcohol_consumption, address, id]
    );

    res.status(200).json({ message: 'Patient profile updated successfully' });
  } catch (error) {
    res.status(500).send('Error updating patient profile: ' + error.message);
  }
});

// Endpoint to fetch all labs
app.get('/labs', async (req, res) => {
  try {
    const client = await pool.connect();
    console.log("Fetching labs from database");
    const result = await client.query('SELECT * FROM lab ORDER BY rating desc');
    const labs = result.rows;
    client.release();
    res.json(labs);
    console.log("Sent the lab details successfully to Flutter!!!");
  } catch (e) {
    console.error('Error fetching labs:', e);
    res.status(500).send('Error fetching labs');
  }
});

// Endpoint to fetch tests for a specific lab by labId
app.get('/tests/:labId', async (req, res) => {
  const labId = req.params.labId;
  console.log(`Received labId: ${labId}`);

  try {
    const client = await pool.connect();
    console.log("Searching tests for lab");
    const result = await client.query('SELECT * FROM tests WHERE lab_unique_id = $1', [labId]);
    client.release();
    res.json(result.rows);
    console.log("Sent the tests successfully to Flutter!!!");
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).send('Error fetching tests');
  }
});


let otpStore = {}; // Temporary in-memory store for OTPs

// Configure Nodemailer
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: 'zocn bofx jejl siwx',
  },
  // Set the sender name
  defaultFrom: '"Diagnocare" <diagnocare2024@gmail.com>',
});

// Generate OTP
const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

// Endpoint to send OTP
app.post('/sendOTP', async (req, res) => {
  const { patientId } = req.body;
  console.log(patientId);

  try {
    const result = await pool.query('SELECT email FROM patients_buffer WHERE unique_id = $1', [patientId]);
    const patientEmail = result.rows[0].email;
    console.log('Patient Email:', patientEmail);

    const otp = generateOTP();
    console.log(otp);
    otpStore[patientId] = otp; // Store OTP in memory with patientId as the key

    // Send OTP via email
    await transporter.sendMail({
      from: '"Diagnocare" <diagnocare2024@gmail.com>',
      to: patientEmail,
      subject: 'OTP for Appointment Booking',
      html: `
        <p>Dear Patient,</p>
        <p>Your OTP for booking an appointment is: <strong>${otp}</strong></p>
        <p>Please use this OTP to complete your appointment booking.</p>
        <p>Best regards,<br/>Diagnocare Team</p>
      `,
    });

    res.status(200).json({ message: 'OTP sent successfully' });
  } catch (error) {
    console.error('Error sending OTP:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint to verify OTP and create appointment
app.post('/createAppointment', async (req, res) => {
  const { testName, testPrice, appointmentDate, timeSlot, labUniqueId, patientId, status, otp } = req.body;

  // Log the request body for debugging
  console.log('Received request body:', req.body);

  // Verify OTP
  const storedOtp = otpStore[patientId];
  if (otp !== storedOtp) {
    return res.status(400).json({ error: 'Invalid OTP' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO appointmentsBooking (test_name, test_price, appointment_date, time_slot, lab_unique_id, patient_id, status) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [testName, testPrice, appointmentDate, timeSlot, labUniqueId, patientId, status]
    );

    // Clear OTP from memory after successful verification and insertion
    delete otpStore[patientId];

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error inserting appointment:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Endpoint to verify OTP and create appointment
app.post('/createDocAppointment', async (req, res) => {
  const { appointmentDate, timeSlot, meduniqid, patientId, status, otp } = req.body;

  // Log the request body for debugging
  console.log('Received request body:', req.body);

  // Verify OTP
  const storedOtp = otpStore[patientId];
  if (otp !== storedOtp) {
    return res.status(400).json({ error: 'Invalid OTP' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO appDocBooking (appointment_date, time_slot, med_uniq_id, patient_id, status) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [appointmentDate, timeSlot, meduniqid, patientId, status]
    );

    // Clear OTP from memory after successful verification and insertion
    delete otpStore[patientId];

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error inserting appointment:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Function to get doctors by specialization
const getDoctorsBySpecialization = async (specialization) => {
  const client = await pool.connect();
  try {
    const res = await client.query(
      'SELECT * FROM medical_experts_buffer WHERE specialization = $1',
      [specialization]
    );
    return res.rows;
  } finally {
    client.release();
  }
};

// Endpoint to get doctors by specialization
app.get('/doctors', async (req, res) => {
  const specialization = req.query.specialization;
  console.log("Received specilization successfully: ", specialization);
  try {
    const doctors = await getDoctorsBySpecialization(specialization);
    console.log(doctors);
    res.json(doctors);
    console.log("Sent to flutter successfully!!")
  } catch (error) {
    console.error('Error fetching doctors:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint to fetch booked tests for a patient
app.get('/api/booked-tests/:patientId', async (req, res) => {
  const { patientId } = req.params;
  console.log("Patient id is: ", patientId);
  try {
    const query = `
      SELECT 
        lab.name AS lab_name,
        lab.address,
        lab.contact_number AS mobile_no,
        appointmentsBooking.test_name,
        appointmentsBooking.test_price,
        appointmentsBooking.appointment_date,
        appointmentsBooking.appointment_time,
        appointmentsBooking.time_slot,
        appointmentsBooking.status
      FROM 
        appointmentsBooking
      JOIN 
        lab ON appointmentsBooking.lab_unique_id = lab.lab_unique_id
      WHERE 
        appointmentsBooking.patient_id = $1
    `;
    const result = await pool.query(query, [patientId]);
    res.status(200).json(result.rows);
    console.log("Sent to flutter successfully!!");
  } catch (error) {
    console.error('Error fetching booked tests:', error);
    res.status(500).send('Server error');
  }
});


app.get('/api/booked-appointments/:patientId', async (req, res) => {
  const { patientId } = req.params;
  console.log("Patient id is: ", patientId);
  try {
    const result = await pool.query(
      `SELECT 
        medxpb.name AS "doctorName",
        appdb.appointment_id AS id,
        appdb.med_uniq_id,
        appdb.patient_id,
        appdb.appointment_date AS date,
        appdb.appointment_time AS time,
        appdb.time_slot AS "timeSlot",
        medxpb.address,
        medxpb.email,
        medxpb.mobile AS "mobileNo",
        appdb.status
      FROM 
        "medical_experts_buffer" AS medxpb
      JOIN 
        appDocBooking AS appdb 
      ON 
        appdb.med_uniq_id = medxpb.unique_id
      WHERE 
        appdb.patient_id = $1`,
      [patientId]
    );
    res.status(200).json(result.rows);
    console.log(result);
    console.log("Sent to flutter successfully!!");
  } catch (error) {
    console.error('Error fetching booked appointments:', error);
    res.status(500).send('Server error');
  }
});

// Endpoint to fetch patients for a specific med_unique_id and date
app.get('/api/patientsdatewise', async (req, res) => {
  const { med_unique_id, date } = req.query;
  console.log("Appointments for doctor: ", med_unique_id);
  console.log("Date: ", date);

  if (!med_unique_id || !date) {
    return res.status(400).json({ error: 'med_unique_id and date are required' });
  }

  try {
    const query = `
      SELECT ad.patient_id, ad.time_slot, p.name
      FROM appDocBooking ad
      JOIN patients_buffer p ON ad.patient_id = p.unique_id
      WHERE ad.med_uniq_id = $1 AND ad.appointment_date = $2
    `;
    const values = [med_unique_id, date];
    const result = await pool.query(query, values);

    const patients = result.rows.map(row => ({
      patient_name: row.name,
      time_slot: row.time_slot,
    }));

    res.json({ patients });
    console.log(patients);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint to fetch patients booked for tests on a specific date in a lab
app.get('/api/labpatientsdatewise', async (req, res) => {
  const { lab_unique_id, date } = req.query;
  console.log("Appointments for lab: ", lab_unique_id);
  console.log("Date: ", date);

  if (!lab_unique_id || !date) {
    return res.status(400).json({ error: 'lab_unique_id and date are required' });
  }

  try {
    const query = `
      SELECT ab.patient_id, ab.time_slot, t.test_id, ab.test_price, p.name, t.test_name, t.price, p.email
      FROM appointmentsBooking ab
      JOIN patients_buffer p ON ab.patient_id = p.unique_id
      JOIN tests t ON ab.test_name = t.test_name
      WHERE ab.lab_unique_id = $1 AND ab.appointment_date = $2
    `;
    const values = [lab_unique_id, date];
    const result = await pool.query(query, values);

    const patients = result.rows.map(row => ({
      patient_id: row.patient_id,
      patient_name: row.name,
      test_name: row.test_name,
      test_id: row.test_id,
      test_price: row.test_price,
      time_slot: row.time_slot,
      patient_email: row.email
    }));

    res.json({ patients });
    console.log(patients);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Destination folder where files will be saved
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname)); // File name with unique timestamp
  },
});

const upload = multer({ storage: storage });

/// Endpoint for technical experts to upload reports
app.post('/uploadReport', upload.single('report'), async (req, res) => {
  console.log(req.file); // Log the file details to inspect

  // Check if req.file is present and has valid data
  if (!req.file) {
    console.error('Error: No file uploaded or file data is missing.');
    return res.status(400).json({ message: 'No file uploaded or file data is missing.' });
  }

  // Continue with processing the file
  const { patient_id, lab_unique_id, test_id } = req.body;

  try {
    // Assuming req.file is correct, as per the log, you should have the file available
    const fileBuffer = fs.readFileSync(req.file.path);

    // Save the file and get the file path or URL
    const filePath = path.join(__dirname, 'uploads', req.file.filename);
    fs.writeFileSync(filePath, fileBuffer);

    // Construct the report URL (adjust as per your server setup)
    const reportUrl = `http://10.0.2.2:3000/uploads/${req.file.filename}`;

    // Store the report URL in PostgreSQL database
    const result = await pool.query(
      'INSERT INTO reports (patient_id, lab_unique_id, test_id, report_url) VALUES ($1, $2, $3, $4) RETURNING *',
      [patient_id, lab_unique_id, test_id, reportUrl]
    );

    res.status(201).json({
      message: 'Report uploaded successfully',
      report: result.rows[0], // Optional: send the inserted row back as response
    });
  } catch (error) {
    console.error('Error uploading report:', error);
    res.status(500).json({ message: 'Failed to upload report' });
  }
});



app.get('/getReports', async (req, res) => {
  const { patient_id } = req.query;
  console.log(patient_id);

  if (!patient_id) {
    return res.status(400).json({ error: 'patient_id is required' });
  }

  try {
    const query = `
      SELECT reports.report_id, reports.report_url, tests.test_name, lab.name
      FROM reports
      JOIN tests ON reports.test_id = tests.test_id
      JOIN lab ON tests.lab_unique_id = lab.lab_unique_id
      WHERE reports.patient_id = $1
    `;
    const result = await pool.query(query, [patient_id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'No reports found for the given patient_id' });
    }

    const reports = result.rows.map(row => ({
      report_id: row.report_id,
      test_name: row.test_name,
      lab_name: row.name,
      report_url: row.report_url,
    }));

    res.json(reports);
  } catch (error) {
    console.error('Error fetching reports:', error);
    res.status(500).json({ error: 'Failed to fetch reports' });
  }
});

// Serve static files from the "uploads" directory
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.get('/downloadReport', async (req, res) => {
  const { report_id, patient_id } = req.query;
  console.log('Received report_id:', report_id);
  console.log('Received patient_id:', patient_id);

  if (!report_id || !patient_id) {
    return res.status(400).json({ error: 'report_id and patient_id are required' });
  }

  try {
    const query = 'SELECT report_url FROM reports WHERE report_id = $1 AND patient_id = $2';
    const result = await pool.query(query, [report_id, patient_id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Report not found' });
    }

    const reportUrl = result.rows[0].report_url;
    console.log('Report URL:', reportUrl);

    // Assuming the report URL is a direct URL to the report file
    res.redirect(reportUrl);
  } catch (error) {
    console.error('Error downloading report:', error);
    res.status(500).json({ error: 'Failed to download report' });
  }
});


// Endpoint to fetch 10 nearest labs based on emulator's location
app.get('/nearby-labs', async (req, res) => {
  const { lat, lon } = req.query;
  console.log(lat, lon);

  if (!lat || !lon) {
    return res.status(400).send('Latitude and Longitude are required');
  }

  try {
    const result = await pool.query('SELECT * FROM lab');
    const labs = result.rows;

    // Calculate distances and sort labs by nearest first
    const nearestLabs = labs.map(lab => ({
      ...lab,
      distance: geolib.getDistance(
        { latitude: parseFloat(lat), longitude: parseFloat(lon) },
        { latitude: lab.latitude, longitude: lab.longitude }
      ),
    })).sort((a, b) => a.distance - b.distance).slice(0, 10); // Get the nearest 10 labs

    res.json(nearestLabs);
  } catch (error) {
    console.error('Error fetching nearby labs:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/search-labs', async (req, res) => {
  const { locality, city, state } = req.query;

  try {
    const query = `
      SELECT * FROM lab
      WHERE address ILIKE $1
      AND address ILIKE $2
      AND address ILIKE $3
    `;
    const values = [`%${locality}%`, `%${city}%`,`%${state}%`];

    const result = await pool.query(query, values);

    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching labs:', error);
    res.status(500).send('Server error');
  }
});

//Cancellation of clinic lab test:
app.post('/api/cancel-booking', async (req, res) => {
  const { patientId, testName } = req.body;
  console.log(patientId, testName);

  try {
    const patientResult = await pool.query(`
      SELECT email FROM patients_buffer WHERE unique_id = $1
    `, [patientId]);

    const appointmentResult = await pool.query(`
      SELECT appointment_date, test_price FROM appointmentsBooking 
      WHERE patient_id = $1 AND test_name = $2
    `, [patientId, testName]);

    if (patientResult.rows.length === 0 || appointmentResult.rows.length === 0) {
      return res.status(404).json({ message: 'Patient or Appointment not found' });
    }

    const patientEmail = patientResult.rows[0].email;
    const appointmentDate = new Date(appointmentResult.rows[0].appointment_date);
    const testPrice = appointmentResult.rows[0].test_price;
    const currentDate = new Date();
    const differenceInDays = (appointmentDate - currentDate) / (1000 * 3600 * 24);

    if (differenceInDays >= 3) {
      const refundAmount = testPrice * 0.30;

      const mailOptions = {
        from: 'Diagnocare <your-email@gmail.com>',
        to: patientEmail,
        subject: 'Appointment Cancellation Refund',
        html: `
            <p>Dear Patient,</p>
            <p>30% of your paid money (<strong>₹${refundAmount.toFixed(2)}</strong>) is refunded due to cancellation before 3 days of the appointment date.</p>
            <p>Best regards,<br/>Diagnocare Team</p>
        `,
      };

      transporter.sendMail(mailOptions, async (error, info) => {
        if (error) {
          console.error(error);
          return res.status(500).json({ message: 'Failed to send email' });
        } else {
          await pool.query(`
            UPDATE appointmentsBooking SET status = 'Cancelled' 
            WHERE patient_id = $1 AND test_name = $2
          `, [patientId, testName]);
          res.status(200).json({ message: 'Booking cancelled and email sent' });
        }
      });
    } else {
      res.status(400).json({ message: 'Cancellation not allowed within 3 days of the appointment date' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to cancel booking' });
  }
});

//Cancellation of doctor appointments:
app.post('/api/cancel-doc-booking', async (req, res) => {
  const { patientId, doctorName } = req.body;
  console.log(patientId, doctorName);

  try {
    const patientResult = await pool.query(`
      SELECT email FROM patients_buffer WHERE unique_id = $1
    `, [patientId]);

    const appointmentResult = await pool.query(`
      SELECT appdoc.appointment_date, medexp.uniq_id 
      FROM appDocBooking as appdoc
      JOIN medical_experts_buffer as medexp 
      ON appdoc.med_uniq_id = medexp.uniq_id
      WHERE appdoc.patient_id = $1 AND medexp.uniq_id = $2;
    `, [patientId, doctorName]);

    if (patientResult.rows.length === 0 || appointmentResult.rows.length === 0) {
      return res.status(404).json({ message: 'Patient or Appointment not found' });
    }

    const patientEmail = patientResult.rows[0].email;
    const appointmentDate = new Date(appointmentResult.rows[0].appointment_date);
    //const testPrice = appointmentResult.rows[0].test_price;
    const currentDate = new Date();
    const differenceInDays = (appointmentDate - currentDate) / (1000 * 3600 * 24);

    if (differenceInDays >= 3) {
      const refundAmount = testPrice * 0.30;

      const mailOptions = {
        from: 'Diagnocare <your-email@gmail.com>',
        to: patientEmail,
        subject: 'Appointment Cancellation Refund',
        html: `
            <p>Dear Patient,</p>
            <p>30% of your paid money (<strong>₹${refundAmount.toFixed(2)}</strong>) is refunded due to cancellation before 3 days of the appointment date.</p>
            <p>Best regards,<br/>Diagnocare Team</p>
        `,
      };

      transporter.sendMail(mailOptions, async (error, info) => {
        if (error) {
          console.error(error);
          return res.status(500).json({ message: 'Failed to send email' });
        } else {
          await pool.query(`
            UPDATE appDocBooking SET status = 'Cancelled' 
            WHERE patient_id = $1 AND test_name = $2
          `, [patientId, testName]);
          res.status(200).json({ message: 'Booking cancelled and email sent' });
        }
      });
    } else {
      res.status(400).json({ message: 'Cancellation not allowed within 3 days of the appointment date' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to cancel booking' });
  }
});


// Example route to verify server is running
app.get('/test', (req, res) => {
  res.send('Server is running');
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});







// const express = require('express');
// const bodyParser = require('body-parser');
// const bcrypt = require('bcrypt');
// const admin = require('firebase-admin');

// // Initialize Firebase admin SDK
// admin.initializeApp({
//   credential: admin.credential.cert(require('C:\Users\Charumadhi\Downloads\labdiagnosticsapp-firebase-adminsdk-s32e6-8c6132071c.json')),
// });

// const db = admin.firestore();

// const app = express();
// app.use(bodyParser.json());
// const port = 3000;

// // Helper function to check user credentials using Firebase Firestore
// const checkUserCredentials = async (email, password) => {
//   const collections = [
//     'patients_buffer',
//     'medical_experts_buffer',
//     'technicalexperts_buffer',
//     'remote_technical_experts_buffer'
//   ];

//   for (const collection of collections) {
//     const snapshot = await db.collection(collection).where('email', '==', email).get();

//     if (!snapshot.empty) {
//       const userDoc = snapshot.docs[0]; // Assuming the first matching document
//       const user = userDoc.data();

//       // Check if the password is valid using bcrypt
//       const isPasswordValid = await bcrypt.compare(password, user.password);

//       if (isPasswordValid) {
//         return { user, type: collection };
//       }
//     }
//   }

//   return null; // Return null if no user is found or password is invalid
// };

// // Endpoint to handle user login
// app.post('/login', async (req, res) => {
//   console.log('Login endpoint called');
//   const { username, password } = req.body; // Username assumed to be email

//   try {
//     console.log('Checking user credentials');
//     const userInfo = await checkUserCredentials(username, password); // Using Firebase for authentication

//     if (userInfo) {
//       console.log('Login successful');
//       res.status(200).json({
//         message: 'Login successful',
//         user: userInfo.user,
//         type: userInfo.type
//       });
//     } else {
//       console.log('Invalid username or password');
//       res.status(401).json({ message: 'Invalid username or password' });
//     }
//   } catch (error) {
//     console.error('Error logging in:', error);
//     res.status(500).json({ message: 'Error logging in', error: error.message });
//   }
// });

// app.listen(port, () => {
//   console.log(`Server is running on port ${port}`);
// });


// // Endpoint to register a new patient in Firebase
// app.post('/register_patient', async (req, res) => {
//   const {
//     name,
//     gender,
//     age,
//     mobile_number,
//     email,
//     dob,
//     height,
//     weight,
//     blood_group,
//     aadhaar_no,
//     marital_status,
//     occupation,
//     emergency_contact_no,
//     smoking,
//     alcohol_consumption,
//     address,
//     password
//   } = req.body;

//   try {
//     // Hash the password
//     const hashedPassword = await bcrypt.hash(password, 10);

//     // Generate a unique ID (you can reuse your uniqueId logic here, or let Firestore handle unique document IDs)
//     const uniqueId = await generateUniqueId(); // You can still keep this if you need custom IDs

//     // Store the patient data in Firestore (patients_buffer collection)
//     const patientRef = await db.collection('patients_buffer').add({
//       unique_id: uniqueId,
//       name,
//       gender,
//       age,
//       mobile_number,
//       email,
//       dob,
//       height,
//       weight,
//       blood_group,
//       aadhaar_no,
//       marital_status,
//       occupation,
//       emergency_contact_no,
//       smoking,
//       alcohol_consumption,
//       address,
//       password: hashedPassword, // Storing the hashed password
//       created_at: admin.firestore.FieldValue.serverTimestamp(), // Add a timestamp for creation
//     });

//     // Return the Firestore document ID and unique ID in the response
//     res.status(201).json({ id: patientRef.id, unique_id: uniqueId });
//   } catch (error) {
//     console.error('Error registering patient:', error);
//     res.status(500).send('Error registering patient: ' + error.message);
//   }
// });


// // Endpoint to register a new medical expert in Firebase
// app.post('/register_medical_expert', async (req, res) => {
//   const {
//     name,
//     age,
//     gender,
//     mobile,
//     email,
//     dob,
//     specialization,
//     experience,
//     qualifications,
//     registrations,
//     address,
//     working_hospital,
//     password
//   } = req.body;

//   try {
//     // Hash the password
//     const hashedPassword = await bcrypt.hash(password, 10);

//     // Generate a unique ID (custom ID logic if required)
//     const uniqueId = await generateUniqueId();

//     // Store the medical expert data in Firestore (medical_experts_buffer collection)
//     const medicalExpertRef = await db.collection('medical_experts_buffer').add({
//       unique_id: uniqueId,
//       name,
//       age,
//       gender,
//       mobile,
//       email,
//       dob,
//       specialization,
//       experience,
//       qualifications,
//       registrations,
//       address,
//       working_hospital,
//       password: hashedPassword, // Storing the hashed password
//       created_at: admin.firestore.FieldValue.serverTimestamp(), // Add a timestamp for creation
//     });

//     // Return the Firestore document ID and unique ID in the response
//     res.status(201).json({ id: medicalExpertRef.id, unique_id: uniqueId });
//   } catch (error) {
//     console.error('Error registering medical expert:', error);
//     res.status(500).send('Error registering medical expert: ' + error.message);
//   }
// });


// // Endpoint to register a new technical expert in Firebase
// app.post('/register_technical_expert', async (req, res) => {
//   const {
//     full_name,
//     email,
//     mobile_number,
//     age,
//     gender,
//     dob,
//     educational_qualification,
//     work_experience,
//     lab_name,
//     lab_address,
//     lab_mobile_number,
//     password
//   } = req.body;

//   try {
//     // Hash the password
//     const hashedPassword = await bcrypt.hash(password, 10);

//     // Generate a unique ID (use your existing logic or let Firestore handle document ID generation)
//     const uniqueId = await generateUniqueId();

//     // Store the technical expert data in Firestore (technicalexperts_buffer collection)
//     const technicalExpertRef = await db.collection('technicalexperts_buffer').add({
//       unique_id: uniqueId,
//       full_name,
//       email,
//       mobile_number,
//       age,
//       gender,
//       dob,
//       educational_qualification,
//       work_experience,
//       lab_name,
//       lab_address,
//       lab_mobile_number,
//       password: hashedPassword, // Storing the hashed password
//       created_at: admin.firestore.FieldValue.serverTimestamp() // Add a timestamp for when the record was created
//     });

//     // Respond with the document ID and unique ID
//     res.status(201).json({ id: technicalExpertRef.id, unique_id: uniqueId });
//   } catch (err) {
//     console.error('Failed to register technical expert:', err);
//     res.status(500).json({ error: 'Failed to register technical expert: ' + err.message });
//   }
// });


// // Endpoint to get patient details by email from Firebase
// app.get('/getPatientDetails', async (req, res) => {
//   const email = req.query.email;

//   // Log the email received from the query parameter
//   console.log('Received request to get patient details for email:', email);

//   if (!email) {
//     console.log('No email provided in the request');
//     return res.status(400).json({ error: 'Email is required' });
//   }

//   try {
//     // Log the Firestore query execution
//     console.log('Executing Firestore query to fetch patient details...');
    
//     // Query Firestore to find the patient by email
//     const patientQuerySnapshot = await db.collection('patients_buffer')
//                                         .where('email', '==', email)
//                                         .get();

//     if (patientQuerySnapshot.empty) {
//       console.log('No patient found for the provided email:', email);
//       return res.status(404).json({ error: 'Patient not found' });
//     }

//     // Assuming only one document exists for the email
//     const patientDoc = patientQuerySnapshot.docs[0];
//     const patient = patientDoc.data();

//     // Log the patient details fetched from Firestore
//     console.log('Patient details fetched successfully:', patient);

//     res.json({
//       name: patient.name,
//       gender: patient.gender,
//       age: patient.age,
//       mobile_number: patient.mobile_number,
//       email: patient.email,
//       dob: patient.dob,
//       height: patient.height,
//       weight: patient.weight,
//       blood_group: patient.blood_group,
//       aadhaar_no: patient.aadhaar_no,
//       marital_status: patient.marital_status,
//       occupation: patient.occupation,
//       emergency_contact_no: patient.emergency_contact_no,
//       address: patient.address,
//       smoking: patient.smoking,
//       alcohol_consumption: patient.alcohol_consumption,
//       unique_id: patient.unique_id 
//     });
//   } catch (error) {
//     console.error('Error fetching patient details from Firestore:', error);
//     res.status(500).json({ error: 'Internal server error' });
//   }
// });


// // Endpoint to update patient profile in Firebase
// app.put('/updatePatientProfile', async (req, res) => {
//   const patientDetails = req.body;

//   const {
//     email, name, gender, age, mobile_number, dob, height, weight, blood_group, aadhaar_no, marital_status, occupation, emergency_contact_no, address, smoking, alcohol_consumption
//   } = patientDetails;

//   if (!email) {
//     return res.status(400).json({ error: 'Email is required to update profile' });
//   }

//   try {
//     // Log the update operation
//     console.log('Updating patient profile for email:', email);

//     // Create an object with the fields to update
//     const updates = {
//       name,
//       gender,
//       age,
//       mobile_number,
//       dob,
//       height,
//       weight,
//       blood_group,
//       aadhaar_no,
//       marital_status,
//       occupation,
//       emergency_contact_no,
//       address,
//       smoking,
//       alcohol_consumption
//     };

//     // Update the patient document in Firestore
//     await db.collection('patients_buffer').doc(email).update(updates);

//     res.status(200).json({ message: 'Profile updated successfully' });
//   } catch (error) {
//     console.error('Error updating profile in Firestore:', error);
//     res.status(500).json({ error: 'Internal server error' });
//   }
// });


// // Endpoint to get doctor details by email from Firebase
// app.get('/getDoctorDetails', async (req, res) => {
//   const email = req.query.email;

//   // Log the email received from the query parameter
//   console.log('Received request to get doctor details for email:', email);

//   if (!email) {
//     console.log('No email provided in the request');
//     return res.status(400).json({ error: 'Email is required' });
//   }

//   try {
//     // Log the query being executed
//     console.log('Executing query to fetch doctor details...');

//     // Fetch the doctor document from Firestore
//     const doctorRef = db.collection('medical_experts_buffer').doc(email);
//     const doctorDoc = await doctorRef.get();

//     if (!doctorDoc.exists) {
//       console.log('No doctor found for the provided email:', email);
//       return res.status(404).json({ error: 'Doctor not found' });
//     }

//     const doctor = doctorDoc.data();

//     // Log the doctor details fetched from the database
//     console.log('Doctor details fetched successfully:', doctor);

//     res.json({
//       name: doctor.name,
//       age: doctor.age,  // Include age
//       dob: doctor.dob,  // Include dob
//       specialization: doctor.specialization,
//       experience: doctor.experience,
//       qualifications: doctor.qualifications,
//       registrations: doctor.registrations,
//       working_hospital: doctor.working_hospital,
//       email: doctor.email,
//       mobile: doctor.mobile,
//       address: doctor.address,
//       unique_id: doctor.unique_id 
//     });
//     console.log("Sent to Flutter!!");
//   } catch (error) {
//     console.error('Error fetching doctor details:', error);
//     res.status(500).json({ error: 'Internal server error' });
//   }
// });

// // Endpoint to update doctor profile details in Firestore
// app.put('/updateDoctorProfile', async (req, res) => {
//   const doctorDetails = req.body;

//   const {
//     name, age, mobile, email, dob, specialization, experience, qualifications, registrations, address, working_hospital
//   } = doctorDetails;

//   try {
//     // Reference to the doctor document using the email
//     const doctorRef = db.collection('medical_experts_buffer').doc(email);
    
//     // Fetch the document to check if it exists
//     const doctorDoc = await doctorRef.get();

//     if (!doctorDoc.exists) {
//       return res.status(404).json({ message: 'Doctor not found' });
//     }

//     // Update the doctor profile details
//     await doctorRef.update({
//       name,
//       age,
//       mobile,
//       dob,
//       specialization,
//       experience,
//       qualifications,
//       registrations,
//       address,
//       working_hospital
//     });

//     res.status(200).json({ message: 'Doctor profile updated successfully' });
//   } catch (error) {
//     console.error('Error updating doctor profile:', error);
//     res.status(500).json({ error: 'Internal server error' });
//   }
// });

