// const mongoose = require("mongoose");
// const dotenv = require("dotenv");
// dotenv.config(); // Load environment variables
// const MONGO_URI = process.env.MONGO_URI;
// // Connect to MongoDB Atlas
// mongoose
// .connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
// .then(() => console.log("Connected to MongoDB Atlas"))
// .catch(err => console.error("MongoDB Atlas connection error:", err));
// const express = require("express");
// const mongoose = require("mongoose");
// const dotenv = require("dotenv");
// const { body, validationResult } = require("express-validator");

// dotenv.config(); // Load environment variables
// const app = express();
// const PORT = 3000; // Set server port
// const SECRET_KEY = "mysecretkey123"; // Use the same secret key for API

// const MONGO_URI = process.env.MONGO_URI; // MongoDB Atlas URI

// // Middleware
// app.use(express.json()); // For parsing JSON bodies

// // Connect to MongoDB Atlas
// mongoose
//   .connect(MONGO_URI)
//   .then(() => {
//     console.log("✅ Connected to MongoDB Atlas");

//     // Start the Express server only after the database is connected
//     app.listen(PORT, () => {
//       console.log(`🚀 Server running on port ${PORT}`);
//     });
//   })
//   .catch((err) => {
//     console.error("❌ MongoDB Atlas connection error:", err);
//   });

// // Mongoose User Model
// const User = require("./models/User");

// // Middleware to authenticate using API key
// const authenticate = (req, res, next) => {
//   const apiKey = req.header("x-api-key");
//   if (!apiKey || apiKey !== SECRET_KEY) {
//     return res.status(401).json({ message: "Unauthorized: Invalid or missing API key" });
//   }
//   next();
// };

// // Create a User (POST /users)
// app.post(
//   "/users",
//   authenticate,
//   [
//     body("id").isString().withMessage("ID must be a string"),
//     body("name").isLength({ min: 2 }).withMessage("Name must be at least 2 characters long"),
//     body("email").isEmail().withMessage("Invalid email format"),
//   ],
//   async (req, res) => {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//       return res.status(400).json({ errors: errors.array() });
//     }

//     const { id, name, email } = req.body;
//     try {
//       const user = new User({ id, name, email });
//       await user.save();
//       res.status(201).json({ message: "User created", user });
//     } catch (err) {
//       console.error(err);
//       res.status(500).json({ message: "Internal server error" });
//     }
//   }
// );

// // Fetch All Users (GET /users)
// app.get("/users", authenticate, async (req, res) => {
//   try {
//     const users = await User.find();
//     res.status(200).json(users);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ message: "Internal server error" });
//   }
// });

// const express = require("express");
// const mongoose = require("mongoose");
// const dotenv = require("dotenv");
// const { body, validationResult } = require("express-validator");

// dotenv.config();
// const app = express();
// const PORT = 3000;
// const SECRET_KEY = "mysecretkey123";

// const MONGO_URI = process.env.MONGO_URI;

// // Middleware
// app.use(express.json());

// // Connect to MongoDB Atlas
// mongoose
//   .connect(MONGO_URI)
//   .then(() => {
//     console.log("✅ Connected to MongoDB Atlas");
//     app.listen(PORT, () => {
//       console.log(`🚀 Server running on port ${PORT}`);
//     });
//   })
//   .catch((err) => {
//     console.error("❌ MongoDB Atlas connection error:", err);
//   });

// // Mongoose Task Model
// const TaskSchema = new mongoose.Schema({
//   id: { type: Number, required: true, unique: true },
//   title: { type: String, required: true },
//   description: { type: String, required: true },
//   dueDate: { type: String, required: true },
//   priority: { type: String, required: true },
//   status: { type: String, required: true },
// });

// const Task = mongoose.model("Task", TaskSchema);

// // Middleware to authenticate using API key
// const authenticate = (req, res, next) => {
//   const apiKey = req.header("x-api-key");
//   if (!apiKey || apiKey !== SECRET_KEY) {
//     return res.status(401).json({ message: "Unauthorized: Invalid or missing API key" });
//   }
//   next();
// };

// // Create a Task (POST /tasks)
// app.post(
//   "/tasks",
//   authenticate,
//   [
//     body("id").isInt().withMessage("ID must be an integer"),
//     body("title").isLength({ min: 2 }).withMessage("Title must be at least 2 characters long"),
//     body("description").isString().withMessage("Description must be a string"),
//     body("dueDate").isString().withMessage("Due date must be a valid string"),
//     body("priority").isString().withMessage("Priority must be a string"),
//     body("status").isString().withMessage("Status must be a string"),
//   ],
//   async (req, res) => {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//       return res.status(400).json({ errors: errors.array() });
//     }

//     const { id, title, description, dueDate, priority, status } = req.body;
//     try {
//       const task = new Task({ id, title, description, dueDate, priority, status });
//       await task.save();
//       res.status(201).json({ message: "Task created", task });
//     } catch (err) {
//       console.error(err);
//       res.status(500).json({ message: "Internal server error" });
//     }
//   }
// );

// // Fetch All Tasks (GET /tasks)
// app.get("/tasks", authenticate, async (req, res) => {
//   try {
//     const tasks = await Task.find();
//     res.status(200).json(tasks);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ message: "Internal server error" });
//   }
// });











const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const { body, validationResult } = require("express-validator");

dotenv.config();
const app = express();
const PORT = 3000;
const SECRET_KEY = "mysecretkey123";

const MONGO_URI = process.env.MONGO_URI;

app.use(express.json());


mongoose
  .connect(MONGO_URI)
  .then(() => {
    console.log("✅ Connected to MongoDB Atlas");
    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("❌ MongoDB Atlas connection error:", err);
  });


const TaskSchema = new mongoose.Schema({
  id: { type: Number, required: true, unique: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  dueDate: { type: String, required: true },
  priority: { type: String, required: true },
  status: { type: String, required: true },
});

const Task = mongoose.model("Task", TaskSchema);


const authenticate = (req, res, next) => {
  const apiKey = req.header("x-api-key");
  if (!apiKey || apiKey !== SECRET_KEY) {
    return res.status(401).json({ message: "Unauthorized: Invalid or missing API key" });
  }
  next();
};


app.post(
  "/tasks",
  authenticate,
  [
    body("id").isInt().withMessage("ID must be an integer"),
    body("title").isLength({ min: 2 }).withMessage("Title must be at least 2 characters long"),
    body("description").isString().withMessage("Description must be a string"),
    body("dueDate").isString().withMessage("Due date must be a valid string"),
    body("priority").isString().withMessage("Priority must be a string"),
    body("status").isString().withMessage("Status must be a string"),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { id, title, description, dueDate, priority, status } = req.body;
    try {
      const task = new Task({ id, title, description, dueDate, priority, status });
      await task.save();
      res.status(201).json({ message: "Task created", task });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: "Internal server error" });
    }
  }
);


app.get("/tasks", authenticate, async (req, res) => {
  try {
    const tasks = await Task.find();
    res.status(200).json(tasks);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});


app.get("/tasks/:id", authenticate, async (req, res) => {
  try {
    const task = await Task.findOne({ id: req.params.id });
    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }
    res.status(200).json(task);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});


app.put(
  "/tasks/:id",
  authenticate,
  [
    body("title").optional().isLength({ min: 1 }).withMessage("Title must be at least 2 characters long"),
    body("description").optional().isString().withMessage("Description must be a string"),
    body("dueDate").optional().isString().withMessage("Due date must be a valid string"),
    body("priority").optional().isString().withMessage("Priority must be a string"),
    body("status").optional().isString().withMessage("Status must be a string"),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const task = await Task.findOneAndUpdate({ id: req.params.id }, req.body, { new: true });
      if (!task) {
        return res.status(404).json({ message: "Task not found" });
      }
      res.status(200).json({ message: "Task updated", task });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: "Internal server error" });
    }
  }
);


app.delete("/tasks/:id", authenticate, async (req, res) => {
  try {
    const task = await Task.findOneAndDelete({ id: req.params.id });
    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }
    res.status(200).json({ message: "Task deleted" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});
