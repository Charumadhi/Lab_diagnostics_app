const bcrypt = require('bcrypt');

const enteredPassword = 'Susila7777'; // This should come from user input
const storedHash = '$2b$10$Io4feOmghRM6lXq3rEMpy.B1Qj77Y5mETkqbCr4Ue/dAPjMjPNmpO'; // Stored hash in your database

bcrypt.compare(enteredPassword, storedHash, (err, result) => {
  if (result) {
    console.log('Password is correct');
  } else {
    console.log('Password is incorrect');
  }
});
