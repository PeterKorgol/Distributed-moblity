
// // Import the WebSocket library
// const WebSocket = require('ws');
// // Create a WebSocket server that listens on port 8080
// const wss = new WebSocket.Server({ port: 8080 });
// // When a client connects
// wss.on('connection', (ws) => {
//     console.log('A client connected!');
//     // Send a welcome message to the client
//     ws.send('Hello, client! Welcome to the WebSocket server.');
//     // When the server receives a message from the client
//     ws.on('message', (message) => {
//     console.log(`Received message: ${message}`);
//     // Echo the received message back to the client
//     ws.send(`Server says: ${message}`);
//     });
//     // When the connection is closed
//     ws.on('close', () => {
//     console.log('A client disconnected');
//     });
//     });
//     console.log('WebSocket server is running on ws://localhost:8080');

// // Import the WebSocket library
// const WebSocket = require('ws');
// // Create a WebSocket server that listens on port 8080
// const wss = new WebSocket.Server({ port: 8080 });
// // Store all connected clients
// const clients = [];
// // When a client connects
// wss.on('connection', (ws) => {
// console.log('A client connected!');
// // Add the new client to the clients array
// clients.push(ws);
// // Send a welcome message to the new client
// ws.send('Hello, client! Welcome to the WebSocket server.');
// // When the server receives a message from the client
// ws.on('message', (message) => {
// console.log(`Received message: ${message}`);
// // Broadcast the message to all connected clients
// clients.forEach(client => {
// if (client !== ws && client.readyState === WebSocket.OPEN) {
// client.send(message);
// }
// });
// });
// // When the connection is closed, remove the client from the clients array
// ws.on('close', () => {
// console.log('A client disconnected');
// const index = clients.indexOf(ws);
// if (index !== -1) {
// clients.splice(index, 1); // Remove the client from the list
// }
// });
// // Handle any WebSocket errors
// ws.on('error', (error) => {
// console.error(`WebSocket error: ${error}`);
// });
// });
// console.log('WebSocket server is running on ws://localhost:8080');

const WebSocket = require('ws');
const mongoose = require('mongoose');
const Message = require('./messageModel');


mongoose.connect('mongodb+srv://admin:your-secure-password@cluster0.y6vsi.mongodb.net/', {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch((err) => console.error('MongoDB connection error:', err));


const wss = new WebSocket.Server({ port: 8080 });


const clients = new Set();

wss.on('connection', (ws) => {
    console.log('A client connected');
    clients.add(ws);

    
    const welcomeMessage = {
        sender: "Server",
        message: "Hello, client! Welcome to the WebSocket server.",
        timestamp: new Date().toISOString()
    };
    ws.send(JSON.stringify(welcomeMessage));

    ws.on('message', async (message) => {
        console.log(`Received message: ${message}`);

        try {
          
            const receivedMessage = JSON.parse(message);

    
            const newMessage = new Message({
                username: receivedMessage.sender || "Client 2", 
                message: receivedMessage.message,
                timestamp: new Date()
            });


            await newMessage.save();
            console.log('Message saved to database:', newMessage);

        
            const formattedMessage = {
                sender: newMessage.username,
                message: newMessage.message,
                timestamp: newMessage.timestamp.toISOString()
            };

            clients.forEach(client => {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(JSON.stringify(formattedMessage));
                }
            });

        } catch (error) {
            console.error('Error processing message:', error);
        }
    });

    ws.on('close', () => {
        console.log('A client disconnected');
        clients.delete(ws);
    });

    ws.on('error', (error) => {
        console.error(`WebSocket error: ${error}`);
    });
});

console.log('WebSocket server running on ws://localhost:8080');
