import { useState, useEffect } from 'react';

function WebSocketComponent() {
    const [socket, setSocket] = useState(null);
    const [messages, setMessages] = useState([]);
    const [username, setUsername] = useState('');
    const [chatId, setChatId] = useState('');
    const [connected, setConnected] = useState(false);

    const [messageText, setMessageText] = useState('');
    const [selectedTone, setSelectedTone] = useState('HAPPY');

    const tonesWithEmoji = [
        { name: 'HAPPY', emoji: '😁' },
        { name: 'SAD', emoji: '🙁' },
        { name: 'INTELLIGENT', emoji: '🤓' },
        { name: 'ANGRY', emoji: '😡' },
        { name: 'LOVE', emoji: '😍' }
    ];

    const connect = () => {
        if (!username || !chatId) {
            alert("Please enter both username and chatId");
            return;
        }

        const ws = new WebSocket(`wss://7v06mm1h35.execute-api.eu-west-1.amazonaws.com/dev?chatId=${chatId}&user=${username}`);

        ws.onopen = () => {
            console.log('Connected to WebSocket');
            setConnected(true);
        };

        ws.onmessage = (event) => {
            try {
                const message = JSON.parse(event.data);
                console.log("Parsed message:", message);
                setMessages((prevMessages) => [...prevMessages, message]);
            } catch (err) {
                console.error("Error parsing message:", err);
            }
        };

        ws.onerror = (error) => {
            console.error('WebSocket error:', error);
        };

        ws.onclose = () => {
            console.log('Disconnected from WebSocket');
            setConnected(false);
        };

        setSocket(ws);
    };

    const sendMessage = () => {
        if (socket && socket.readyState === WebSocket.OPEN) {
            const message = {
                action: 'sendmessage',
                message: messageText,
                tone: selectedTone
            };
            socket.send(JSON.stringify(message));
            setMessageText(''); // Clear after send
        } else {
            console.warn("WebSocket is not open");
        }
    };

    useEffect(() => {
        return () => {
            if (socket) {
                socket.close();
            }
        };
    }, [socket]);

    return (
        <div>
            <h1>MeGpt Chat</h1>

            {!connected && (
                <div style={{ marginBottom: '1rem' }}>
                    <input
                        type="text"
                        placeholder="Username"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                        style={{ marginRight: '0.5rem' }}
                    />
                    <input
                        type="text"
                        placeholder="Chat ID"
                        value={chatId}
                        onChange={(e) => setChatId(e.target.value)}
                        style={{ marginRight: '0.5rem' }}
                    />
                    <button onClick={connect}>Connect</button>
                </div>
            )}

            {connected && (
                <>
                    <div style={{ marginBottom: '1rem' }}>
                        <input
                            type="text"
                            placeholder="Type your message..."
                            value={messageText}
                            onChange={(e) => setMessageText(e.target.value)}
                            style={{ marginRight: '0.5rem' }}
                        />
                        <select
                            value={selectedTone}
                            onChange={(e) => setSelectedTone(e.target.value)}
                            style={{ marginRight: '0.5rem' }}
                        >
                            {tonesWithEmoji.map((tone) => (
                                <option key={tone.name} value={tone.name}>{tone.emoji}</option>
                            ))}
                        </select>
                        <button onClick={sendMessage}>Send Message</button>
                    </div>

                    <div>
                        {messages.map((msg, index) => (
                            <div key={index}>
                                <strong>{msg.user || 'Anonymous'}:</strong> {msg.message} <em>({msg.tone})</em>
                            </div>
                        ))}
                    </div>
                </>
            )}
        </div>
    );
}

export default WebSocketComponent;
