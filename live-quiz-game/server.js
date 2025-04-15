// const express = require('express');
// const http = require('http');
// const socketIo = require('socket.io');
// const mongoose = require('mongoose');

// // Connect to MongoDB
// mongoose.connect('mongodb+srv://admin:your-secure-password@cluster0.y6vsi.mongodb.net/', {
//     useNewUrlParser: true,
//     useUnifiedTopology: true
// })
//     .then(() => console.log('Connected to MongoDB'))
//     .catch(err => console.error('Error connecting to MongoDB:', err));

// // Define a User schema for MongoDB
// const userSchema = new mongoose.Schema({
//     socketId: { type: String, unique: true }, // Store socket.id as a unique field
//     username: String,
//     score: Number,
//     joinedAt: { type: Date, default: Date.now }
// });

// // Create a User model based on the schema
// const User = mongoose.model('User', userSchema);

// const app = express();
// const server = http.createServer(app);
// const io = socketIo(server);

// // Serve static files (for the client)
// app.use(express.static('public'));

// let questions = [
//     {
//         question: "What is the capital of France?",
//         options: ["Berlin", "Madrid", "Paris", "Rome"],
//         answer: 2
//     },
//     {
//         question: "Which planet is known as the Red Planet?",
//         options: ["Earth", "Mars", "Jupiter", "Venus"],
//         answer: 1
//     },
//     {
//         question: "What is the largest mammal?",
//         options: ["Elephant", "Blue Whale", "Giraffe", "Shark"],
//         answer: 1
//     }
// ];

// // Shuffle questions to randomize order
// function shuffleQuestions(arr) {
//     for (let i = arr.length - 1; i > 0; i--) {
//         const j = Math.floor(Math.random() * (i + 1));
//         [arr[i], arr[j]] = [arr[j], arr[i]];
//     }
// }

// // Initial state variables
// let currentQuestionIndex = 0;
// let scores = {};
// let players = {};
// let timer;

// // Handle connection
// io.on('connection', (socket) => {
//     console.log('A user connected:', socket.id);

//     // Send welcome message and prompt for username
//     socket.emit('usernamePrompt');

//     socket.on('setUsername', (username) => {
//         players[socket.id] = username;
//         scores[socket.id] = 0; // Initialize score to 0

//         // Create a new user and save it to MongoDB with socket.id as a unique identifier
//         const newUser = new User({ socketId: socket.id, username: username, score: 0 });
//         newUser.save()
//             .then(() => {
//                 console.log(`User ${username} connected with socket.id: ${socket.id}`);
//             })
//             .catch(err => {
//                 console.error('Error saving user to MongoDB:', err);
//             });
//     });

//     // Start game handler
//     socket.on('startGame', () => {
//         shuffleQuestions(questions); // Randomize questions
//         currentQuestionIndex = 0;    // Reset question index
//         startNextQuestion();
//     });

//     // Listen for answers from clients
//     socket.on('answer', (data) => {
//         const { answer } = data;

//         console.log("Current Question Index:", currentQuestionIndex);

//         if (currentQuestionIndex >= questions.length) {
//             console.error("Received answer but no valid question exists.");
//             return; // Ignore the answer if no valid question
//         }

//         const question = questions[currentQuestionIndex];
//         console.log("Question:", question || "No question found");

//         // Check if the answer is correct
//         if (answer === question.answer) {
//             if (scores[socket.id] !== undefined) {
//                 scores[socket.id]++; // Increment score for the user based on socket.id
//             }
//             console.log(`${players[socket.id]} answered correctly! Score: ${scores[socket.id]}`);
//         } else {
//             console.log(`${players[socket.id]} answered incorrectly. Score: ${scores[socket.id]}`);
//         }

//         // Update the user's score in MongoDB
//         User.findOneAndUpdate(
//             { socketId: socket.id },
//             { $set: { score: scores[socket.id] } }, // Update the score in MongoDB
//             { new: true }
//         )
//             .then(updatedUser => {
//                 console.log(`User ${updatedUser.username}'s score updated in MongoDB: ${updatedUser.score}`);
//             })
//             .catch(err => {
//                 console.error('Error updating user score in MongoDB:', err);
//             });

//         // Move to the next question or end the quiz
//         currentQuestionIndex++;
//         if (currentQuestionIndex < questions.length) {
//             startNextQuestion();
//         } else {
//             io.emit('end', scores);
//         }
//     });

//     // Handle disconnection
//     socket.on('disconnect', () => {
//         console.log('A user disconnected:', socket.id);
//         delete players[socket.id];
//         delete scores[socket.id];

//         // Optionally, delete the user from MongoDB (if necessary)
//         User.deleteOne({ socketId: socket.id })
//             .then(() => {
//                 console.log(`User with socket.id: ${socket.id} removed from MongoDB.`);
//             })
//             .catch(err => {
//                 console.error('Error deleting user from MongoDB:', err);
//             });
//     });
// });

// // Start the next question with a timer
// function startNextQuestion() {
//     clearTimeout(timer);

//     if (currentQuestionIndex >= questions.length) {
//         io.emit('end', scores);
//         return;
//     }

//     const question = questions[currentQuestionIndex];
//     io.emit('question', {
//         question: question.question,
//         options: question.options
//     });

//     // Start a countdown timer for the current question
//     let timeLeft = 10;
//     io.emit('timer', timeLeft);

//     timer = setInterval(() => {
//         timeLeft--;
//         io.emit('timer', timeLeft);

//         if (timeLeft === 0) {
//             clearInterval(timer);
//             currentQuestionIndex++; // Move to next question

//             if (currentQuestionIndex < questions.length) {
//                 startNextQuestion();
//             } else {
//                 io.emit('end', scores);
//             }
//         }
//     }, 1000);
// }

// // Start the server
// server.listen(3000, () => {
//     console.log('Server is running on http://localhost:3000');
// });

// const express = require('express');
// const http = require('http');
// const WebSocket = require('ws');
// const mongoose = require('mongoose');

// // Connect to MongoDB
// mongoose.connect('mongodb+srv://admin:your-secure-password@cluster0.y6vsi.mongodb.net/', {
//     useNewUrlParser: true,
//     useUnifiedTopology: true
// })
//     .then(() => console.log('Connected to MongoDB'))
//     .catch(err => console.error('Error connecting to MongoDB:', err));

// // Define a User schema for MongoDB
// const userSchema = new mongoose.Schema({
//     socketId: { type: String, unique: true }, // Store socket.id as a unique field
//     username: String,
//     score: Number,
//     joinedAt: { type: Date, default: Date.now }
// });

// // Create a User model based on the schema
// const User = mongoose.model('User', userSchema);

// const app = express();
// const server = http.createServer(app);

// // Set up WebSocket server
// const wss = new WebSocket.Server({ server });

// // Serve static files (for the client)
// app.use(express.static('public'));

// let questions = [
//     {
//         question: "What is the capital of France?",
//         options: ["Berlin", "Madrid", "Paris", "Rome"],
//         answer: 2
//     },
//     {
//         question: "Which planet is known as the Red Planet?",
//         options: ["Earth", "Mars", "Jupiter", "Venus"],
//         answer: 1
//     },
//     {
//         question: "What is the largest mammal?",
//         options: ["Elephant", "Blue Whale", "Giraffe", "Shark"],
//         answer: 1
//     }
// ];

// // Shuffle questions to randomize order
// function shuffleQuestions(arr) {
//     for (let i = arr.length - 1; i > 0; i--) {
//         const j = Math.floor(Math.random() * (i + 1));
//         [arr[i], arr[j]] = [arr[j], arr[i]];
//     }
// }

// // Initial state variables
// let currentQuestionIndex = 0;
// let scores = {};
// let players = {};
// let timer;

// // WebSocket connection handler
// wss.on('connection', (ws) => {
//     console.log('A user connected:', ws._socket.remoteAddress);

//     // Send welcome message and prompt for username
//     ws.send(JSON.stringify({ event: 'usernamePrompt' }));

//     ws.on('message', (message) => {
//         const data = JSON.parse(message);
        
//         if (data.event === 'setUsername') {
//             // Assign username and initialize score
//             players[ws._socket.remoteAddress] = data.username;
//             scores[ws._socket.remoteAddress] = 0; // Initialize score to 0

//             // Save user to MongoDB
//             const newUser = new User({ socketId: ws._socket.remoteAddress, username: data.username, score: 0 });
//             newUser.save()
//                 .then(() => {
//                     console.log(`User ${data.username} connected with address: ${ws._socket.remoteAddress}`);
//                 })
//                 .catch(err => {
//                     console.error('Error saving user to MongoDB:', err);
//                 });
//         }

//         if (data.event === 'startGame') {
//             shuffleQuestions(questions); // Randomize questions
//             currentQuestionIndex = 0;    // Reset question index
//             startNextQuestion();
//         }

//         if (data.event === 'answer') {
//             const { answer } = data;

//             console.log("Current Question Index:", currentQuestionIndex);

//             if (currentQuestionIndex >= questions.length) {
//                 console.error("Received answer but no valid question exists.");
//                 return; // Ignore the answer if no valid question
//             }

//             const question = questions[currentQuestionIndex];
//             console.log("Question:", question || "No question found");

//             // Check if the answer is correct
//             if (answer === question.answer) {
//                 if (scores[ws._socket.remoteAddress] !== undefined) {
//                     scores[ws._socket.remoteAddress]++; // Increment score for the user based on socket address
//                 }
//                 console.log(`${players[ws._socket.remoteAddress]} answered correctly! Score: ${scores[ws._socket.remoteAddress]}`);
//             } else {
//                 console.log(`${players[ws._socket.remoteAddress]} answered incorrectly. Score: ${scores[ws._socket.remoteAddress]}`);
//             }

//             // Update the user's score in MongoDB
//             User.findOneAndUpdate(
//                 { socketId: ws._socket.remoteAddress },
//                 { $set: { score: scores[ws._socket.remoteAddress] } }, // Update the score in MongoDB
//                 { new: true }
//             )
//                 .then(updatedUser => {
//                     console.log(`User ${updatedUser.username}'s score updated in MongoDB: ${updatedUser.score}`);
//                 })
//                 .catch(err => {
//                     console.error('Error updating user score in MongoDB:', err);
//                 });

//             // Move to the next question or end the quiz
//             currentQuestionIndex++;
//             if (currentQuestionIndex < questions.length) {
//                 startNextQuestion();
//             } else {
//                 broadcastEndGame();
//             }
//         }
//     });

//     // Handle disconnection
//     ws.on('close', () => {
//         console.log('A user disconnected:', ws._socket.remoteAddress);
//         delete players[ws._socket.remoteAddress];
//         delete scores[ws._socket.remoteAddress];

//         // Optionally, delete the user from MongoDB
//         User.deleteOne({ socketId: ws._socket.remoteAddress })
//             .then(() => {
//                 console.log(`User with socket address: ${ws._socket.remoteAddress} removed from MongoDB.`);
//             })
//             .catch(err => {
//                 console.error('Error deleting user from MongoDB:', err);
//             });
//     });
// });

// // Start the next question with a timer
// function startNextQuestion() {
//     clearTimeout(timer);

//     if (currentQuestionIndex >= questions.length) {
//         broadcastEndGame();
//         return;
//     }

//     const question = questions[currentQuestionIndex];
//     broadcastQuestion(question);

//     // Start a countdown timer for the current question
//     let timeLeft = 10;
//     broadcastTimer(timeLeft);

//     timer = setInterval(() => {
//         timeLeft--;
//         broadcastTimer(timeLeft);

//         if (timeLeft === 0) {
//             clearInterval(timer);
//             currentQuestionIndex++; // Move to next question

//             if (currentQuestionIndex < questions.length) {
//                 startNextQuestion();
//             } else {
//                 broadcastEndGame();
//             }
//         }
//     }, 1000);
// }

// function broadcastQuestion(question) {
//     const message = JSON.stringify({
//         event: 'question',
//         question: question.question,
//         options: question.options
//     });
//     wss.clients.forEach(client => {
//         if (client.readyState === WebSocket.OPEN) {
//             client.send(message);
//         }
//     });
// }

// function broadcastTimer(timeLeft) {
//     const message = JSON.stringify({ event: 'timer', timeLeft });
//     wss.clients.forEach(client => {
//         if (client.readyState === WebSocket.OPEN) {
//             client.send(message);
//         }
//     });
// }

// function broadcastEndGame() {

//     // const message = JSON.stringify({ event: 'end', scores });
//     const message = JSON.stringify({ event: 'end', scores, playerUsernames: players });

//     wss.clients.forEach(client => {
//         if (client.readyState === WebSocket.OPEN) {
//             client.send(message);
//         }
//     });
// }

// // Start the server
// server.listen(3000, () => {
//     console.log('Server is running on http://localhost:3000');
// });
const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const mongoose = require('mongoose');

// Connect to MongoDB
mongoose.connect('mongodb+srv://admin:your-secure-password@cluster0.y6vsi.mongodb.net/', {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('Error connecting to MongoDB:', err));

// Define a User schema for MongoDB
const userSchema = new mongoose.Schema({
    socketId: { type: String, unique: true }, // Store socketId as a unique field
    username: String,
    score: Number,
    joinedAt: { type: Date, default: Date.now }
});

// Create a User model based on the schema
const User = mongoose.model('User', userSchema);

const app = express();
const server = http.createServer(app);

// Set up WebSocket server
const wss = new WebSocket.Server({ server });

// Serve static files (for the client)
app.use(express.static('public'));

let questions = [
    {
        question: "What is the capital of France?",
        options: ["Berlin", "Madrid", "Paris", "Rome"],
        answer: 2
    },
    {
        question: "Which planet is known as the Red Planet?",
        options: ["Earth", "Mars", "Jupiter", "Venus"],
        answer: 1
    },
    {
        question: "What is the largest mammal?",
        options: ["Elephant", "Blue Whale", "Giraffe", "Shark"],
        answer: 1
    }
];

// Shuffle questions to randomize order
function shuffleQuestions(arr) {
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
}

// Initial state variables
let currentQuestionIndex = 0;
let scores = {};
let players = {};
let timer;

// WebSocket connection handler
wss.on('connection', (ws) => {
    console.log('A user connected');

    // Generate a random socketId
    const socketId = Math.floor(Math.random() * 1000000).toString();  // Random number as socketId

    // Send welcome message and prompt for username
    ws.send(JSON.stringify({ event: 'usernamePrompt' }));

    ws.on('message', (message) => {
        const data = JSON.parse(message);

        if (data.event === 'setUsername') {
            // Assign username and initialize score
            players[socketId] = data.username;
            scores[socketId] = 0; // Initialize score to 0

            // Save user to MongoDB
            const newUser = new User({ socketId: socketId, username: data.username, score: 0 });
            newUser.save()
                .then(() => {
                    console.log(`User ${data.username} connected with socketId: ${socketId}`);
                })
                .catch(err => {
                    console.error('Error saving user to MongoDB:', err);
                });
        }

        if (data.event === 'startGame') {
            shuffleQuestions(questions); // Randomize questions
            currentQuestionIndex = 0;    // Reset question index
            startNextQuestion();
        }

        if (data.event === 'answer') {
            const { answer } = data;

            console.log("Current Question Index:", currentQuestionIndex);

            if (currentQuestionIndex >= questions.length) {
                console.error("Received answer but no valid question exists.");
                return; // Ignore the answer if no valid question
            }

            const question = questions[currentQuestionIndex];
            console.log("Question:", question || "No question found");

            // Check if the answer is correct
            if (answer === question.answer) {
                if (scores[socketId] !== undefined) {
                    scores[socketId]++; // Increment score for the user based on socketId
                }
                console.log(`${players[socketId]} answered correctly! Score: ${scores[socketId]}`);
            } else {
                console.log(`${players[socketId]} answered incorrectly. Score: ${scores[socketId]}`);
            }

            // Update the user's score in MongoDB
            User.findOneAndUpdate(
                { socketId: socketId },
                { $set: { score: scores[socketId] } }, // Update the score in MongoDB
                { new: true }
            )
                .then(updatedUser => {
                    console.log(`User ${updatedUser.username}'s score updated in MongoDB: ${updatedUser.score}`);
                })
                .catch(err => {
                    console.error('Error updating user score in MongoDB:', err);
                });

            // Move to the next question or end the quiz
            currentQuestionIndex++;
            if (currentQuestionIndex < questions.length) {
                startNextQuestion();
            } else {
                broadcastEndGame();
            }
        }
    });

    // Handle disconnection
    ws.on('close', () => {
        console.log('A user disconnected:', socketId);
        delete players[socketId];
        delete scores[socketId];

        // Optionally, delete the user from MongoDB
        User.deleteOne({ socketId: socketId })
            .then(() => {
                console.log(`User with socketId: ${socketId} removed from MongoDB.`);
            })
            .catch(err => {
                console.error('Error deleting user from MongoDB:', err);
            });
    });
});

// Start the next question with a timer
function startNextQuestion() {
    clearTimeout(timer);

    if (currentQuestionIndex >= questions.length) {
        broadcastEndGame();
        return;
    }

    const question = questions[currentQuestionIndex];
    broadcastQuestion(question);

    // Start a countdown timer for the current question
    let timeLeft = 10;
    broadcastTimer(timeLeft);

    timer = setInterval(() => {
        timeLeft--;
        broadcastTimer(timeLeft);

        if (timeLeft === 0) {
            clearInterval(timer);
            currentQuestionIndex++; // Move to next question

            if (currentQuestionIndex < questions.length) {
                startNextQuestion();
            } else {
                broadcastEndGame();
            }
        }
    }, 1000);
}

function broadcastQuestion(question) {
    const message = JSON.stringify({
        event: 'question',
        question: question.question,
        options: question.options
    });
    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(message);
        }
    });
}

function broadcastTimer(timeLeft) {
    const message = JSON.stringify({ event: 'timer', timeLeft });
    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(message);
        }
    });
}

function broadcastEndGame() {
    const message = JSON.stringify({ event: 'end', scores, playerUsernames: players });

    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(message);
        }
    });
}

// Start the server
server.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});
