const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
dotenv.config(); // Load environment variables
const app = express();
const PORT = 3000;
const SECRET_KEY = process.env.SECRET_KEY;
const MONGO_URI = process.env.MONGO_URI;
app.use(bodyParser.json());
// Connect to MongoDB
mongoose
.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => console.log("Connected to MongoDB"))
.catch(err => console.error("MongoDB connection error:", err));
// Define Mongoose Schema and Model
const userSchema = new mongoose.Schema({
id: { type: String, required: true, unique: true },
name: { type: String, required: true },
email: { type: String, required: true, unique: true },
});
const User = mongoose.model("User", userSchema);
// Authentication Middleware
const authenticate = (req, res, next) => {
const apiKey = req.header("x-api-key");
if (!apiKey || apiKey !== SECRET_KEY) {
return res.status(401).json({ message: "Unauthorized: Invalid or missing API key" });
}
next();
};
// Create User (POST /users)
app.post("/users", authenticate, async (req, res) => {
try {
const { id, name, email } = req.body;
const user = new User({ id, name, email });
await user.save();
res.status(201).json({ message: "User created", user });
} catch (err) {
res.status(400).json({ message: "Error creating user", error: err.message });
}
});
// Get All Users (GET /users)
app.get("/users", authenticate, async (req, res) => {
const users = await User.find();
res.json(users);
});
// Get a User by ID (GET /users/:id)
app.get("/users/:id", authenticate, async (req, res) => {
try {
const user = await User.findOne({ id: req.params.id });
if (!user) {
return res.status(404).json({ message: "User not found" });
}
res.json(user);
} catch (err) {
res.status(400).json({ message: "Error retrieving user", error: err.message });
}
});
// Delete a User (DELETE /users/:id)
app.delete("/users/:id", authenticate, async (req, res) => {
try {
const result = await User.deleteOne({ id: req.params.id });
if (result.deletedCount === 0) {
return res.status(404).json({ message: "User not found" });
}
res.json({ message: "User deleted" });
} catch (err) {
res.status(400).json({ message: "Error deleting user", error: err.message });
}
});
// Start Server
app.listen(PORT, () => {
console.log(`Server running on port ${PORT}`);
});