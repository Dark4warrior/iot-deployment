const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

let sensorData = []; // simulation d'une "base de données" en mémoire

app.post('/sensor-data', (req, res) => {
  const data = { ...req.body, timestamp: new Date() };
  sensorData.push(data);
  console.log('Received data:', data);
  res.status(200).json({ message: 'Data received', data });
});

app.get('/sensor-data', (req, res) => {
  res.json(sensorData);
});

app.listen(port, () => {
  console.log(`API IoT en écoute sur le port ${port}`);
});
