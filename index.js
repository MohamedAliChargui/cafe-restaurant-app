const express = require('express');
const pool = require('./db');
const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static('public'));

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

app.get('/produits', async (req, res) => {
  try {
    const seulementDisponibles = req.query.disponible === 'true';
    const result = await pool.query(
      seulementDisponibles
        ? 'SELECT * FROM produits WHERE disponible = true ORDER BY id'
        : 'SELECT * FROM produits ORDER BY id'
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).send(`Erreur : ${err.message}`);
  }
});

app.get('/categories', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM categories');
    res.json(result.rows);
  } catch (err) {
    res.status(500).send(`Erreur : ${err.message}`);
  }
});
app.post('/commandes', async (req, res) => {
  const { table_id } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO commandes (table_id) VALUES ($1) RETURNING *',
      [table_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).send(`Erreur : ${err.message}`);
  }
});
app.post('/commande_details', async (req, res) => {
  const { commande_id, produit_id, quantite } = req.body;
  try {
    // Récupérer le prix actuel du produit pour figer prix_unitaire
    const produit = await pool.query('SELECT prix FROM produits WHERE id = $1', [produit_id]);
    if (produit.rows.length === 0) {
      return res.status(404).send('Produit introuvable');
    }
    const prix_unitaire = produit.rows[0].prix;

    const result = await pool.query(
      'INSERT INTO commande_details (commande_id, produit_id, quantite, prix_unitaire) VALUES ($1, $2, $3, $4) RETURNING *',
      [commande_id, produit_id, quantite || 1, prix_unitaire]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).send(`Erreur : ${err.message}`);
  }
});
app.get('/commandes/:id', async (req, res) => {
  const { id } = req.params;
  try {
    // Infos de la commande
    const commande = await pool.query('SELECT * FROM commandes WHERE id = $1', [id]);
    if (commande.rows.length === 0) {
      return res.status(404).send('Commande introuvable');
    }

    // Produits liés à cette commande, avec le nom du produit
    const details = await pool.query(
      `SELECT cd.id, cd.produit_id, p.nom, cd.quantite, cd.prix_unitaire
       FROM commande_details cd
       JOIN produits p ON cd.produit_id = p.id
       WHERE cd.commande_id = $1`,
      [id]
    );

    res.json({
      ...commande.rows[0],
      produits: details.rows
    });
  } catch (err) {
    res.status(500).send(`Erreur : ${err.message}`);
  }
});
app.get('/commandes', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT c.id, c.table_id, c.date_commande, c.statut, t.numero AS table_numero
       FROM commandes c
       JOIN tables_restaurant t ON c.table_id = t.id
       ORDER BY c.date_commande DESC`
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).send(`Erreur : ${err.message}`);
  }
});
app.put('/commandes/:id', async (req, res) => {
  const { id } = req.params;
  const { statut } = req.body;

  const statutsValides = ['en attente', 'en préparation', 'servie', 'payée'];
  if (!statutsValides.includes(statut)) {
    return res.status(400).send(`Statut invalide. Valeurs possibles : ${statutsValides.join(', ')}`);
  }

  try {
    const result = await pool.query(
      'UPDATE commandes SET statut = $1 WHERE id = $2 RETURNING *',
      [statut, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).send('Commande introuvable');
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).send(`Erreur : ${err.message}`);
  }
});
app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});
app.post('/produits', async (req, res) => {
  const { nom, description, prix, categorie_id } = req.body;
  if (!nom || prix === undefined || isNaN(Number(prix)) || Number(prix) < 0) {
    return res.status(400).send('Le nom et un prix valide (>= 0) sont obligatoires');
  }
  try {
    const result = await pool.query(
      `INSERT INTO produits (nom, description, prix, categorie_id)
       VALUES ($1, $2, $3, $4) RETURNING *`,
      [nom, description || null, prix, categorie_id || null]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    if (err.code === '23503') return res.status(400).send('Catégorie inexistante');
    res.status(500).send(`Erreur : ${err.message}`);
  }
});

app.put('/produits/:id', async (req, res) => {
  const { id } = req.params;
  const { nom, description, prix, categorie_id, disponible } = req.body;
  if (prix !== undefined && (isNaN(Number(prix)) || Number(prix) < 0)) {
    return res.status(400).send('Prix invalide');
  }
  try {
    const result = await pool.query(
      `UPDATE produits SET
         nom = COALESCE($1, nom),
         description = COALESCE($2, description),
         prix = COALESCE($3, prix),
         categorie_id = COALESCE($4, categorie_id),
         disponible = COALESCE($5, disponible)
       WHERE id = $6 RETURNING *`,
      [nom, description, prix, categorie_id, disponible, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).send('Produit introuvable');
    }
    res.json(result.rows[0]);
  } catch (err) {
    if (err.code === '23503') return res.status(400).send('Catégorie inexistante');
    res.status(500).send(`Erreur : ${err.message}`);
  }
});

app.delete('/produits/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      'UPDATE produits SET disponible = false WHERE id = $1 RETURNING *',
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).send('Produit introuvable');
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).send(`Erreur : ${err.message}`);
  }
});