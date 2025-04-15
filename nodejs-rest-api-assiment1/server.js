const express = require("express");
const bodyParser = require("body-parser");
const { body, param, validationResult } = require("express-validator");

const app = express();
const PORT = 3000;
const SECRET_KEY = "mysecretkey123"; // Use a secure key in production

app.use(bodyParser.json());

let tasks = []; // In-memory task storage

// Middleware to authenticate API key
const authenticate = (req, res, next) => {
    const apiKey = req.header("x-api-key");
    if (!apiKey || apiKey !== SECRET_KEY) {
        return res.status(401).json({ message: "Unauthorized: Invalid or missing API key" });
    }
    next();
};

// Task validation middleware
const validateTask = [
    body("title").isLength({ min: 3 }).withMessage("Title must be at least 3 characters long"),
    body("description").optional().isString().withMessage("Description must be a string"),
    body("dueDate").isISO8601().withMessage("Invalid date format"),
    body("priority").isIn(["low", "medium", "high"]).withMessage("Priority must be 'low', 'medium', or 'high'"),
    body("status").isIn(["pending", "in-progress", "completed"]).withMessage("Invalid status"),
];

// Create a Task (POST /tasks)
app.post("/tasks", authenticate, validateTask, (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { title, description, dueDate, priority, status } = req.body;
    const id = tasks.length + 1; // Simple incremental ID
    const newTask = { id, title, description, dueDate, priority, status };
    tasks.push(newTask);

    res.status(201).json({ message: "Task created", task: newTask });
});

// Get All Tasks (GET /tasks)
app.get("/tasks", authenticate, (req, res) => {
    res.json(tasks);
});

// Get a Specific Task (GET /tasks/:id)
app.get("/tasks/:id", authenticate, param("id").isInt().withMessage("ID must be an integer"), (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const task = tasks.find(t => t.id === parseInt(req.params.id));
    if (!task) {
        return res.status(404).json({ message: "Task not found" });
    }

    res.json(task);
});

// Update a Task (PUT /tasks/:id)
app.put("/tasks/:id", authenticate, [
    param("id").isInt().withMessage("ID must be an integer"),
    body("title").optional().isLength({ min: 3 }).withMessage("Title must be at least 3 characters"),
    body("description").optional().isString(),
    body("dueDate").optional().isISO8601(),
    body("priority").optional().isIn(["low", "medium", "high"]),
    body("status").optional().isIn(["pending", "in-progress", "completed"]),
], (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const taskIndex = tasks.findIndex(t => t.id === parseInt(req.params.id));
    if (taskIndex === -1) {
        return res.status(404).json({ message: "Task not found" });
    }

    tasks[taskIndex] = { ...tasks[taskIndex], ...req.body };
    res.json({ message: "Task updated", task: tasks[taskIndex] });
});

// Delete a Task (DELETE /tasks/:id)
app.delete("/tasks/:id", authenticate, param("id").isInt().withMessage("ID must be an integer"), (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const taskIndex = tasks.findIndex(t => t.id === parseInt(req.params.id));
    if (taskIndex === -1) {
        return res.status(404).json({ message: "Task not found" });
    }

    tasks.splice(taskIndex, 1);
    res.json({ message: "Task deleted" });
});

// Catch-all Route for Undefined Endpoints
app.use((req, res) => {
    res.status(404).json({ message: "Endpoint not found" });
});

// Start Server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
