const clientId = Date.now();
const ws = new WebSocket(`ws://localhost:8000/ws/${clientId}`);

ws.onmessage = function(event) {
    const messages = document.getElementById('messages');
    const message = document.createElement('div');
    message.textContent = event.data;
    messages.appendChild(message);
    messages.scrollTop = messages.scrollHeight;
};

function sendMessage() {
    const input = document.getElementById("message-input");
    ws.send(input.value);
    input.value = '';
}

document.getElementById("message-input").addEventListener("keyup", function(event) {
    if (event.key === "Enter") {
        sendMessage();
    }
});