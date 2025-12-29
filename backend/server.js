const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

let tasks = [];
let nextId = 1;

app.get('/tasks', (req, res) => {
  res.json(tasks);
});

app.post('/tasks', (req, res) => {
  const task = req.body;
  if (!task) return res.status(400).json({ error: 'Invalid task' });
  if (!task.id) task.id = nextId++;
  tasks.push(task);
  res.status(201).json(task);
});

app.listen(port, () => {
  console.log(`Backend listening at http://localhost:${port}`);
});
