const express = require('express');
const pool = require('./db');
const app = express();
const PORT = 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.send('Bienvenue sur l\'application café-restaurant !');
});

app.get('/test-db', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.send(`Connexion à la base de données réussie ! Heure serveur : ${result.rows[0].now}`);
  } catch (err) {
    res.status(500).send(`Erreur de connexion : ${err.message}`);
  }
});

app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});