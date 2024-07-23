/** @format */

const terminal = document.getElementById('terminal');
const ws = new WebSocket('ws://localhost:8080/ws');

ws.onopen = () => {
  terminal.innerHTML += 'Connected to WebTTY\n';
};

ws.onmessage = (event) => {
  terminal.innerHTML += event.data;
};

ws.onclose = () => {
  terminal.innerHTML += '\nConnection closed';
};

document.addEventListener('keydown', (event) => {
  ws.send(event.key);
});

let peerConnection;
const config = { iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] };

async function startWebRTC() {
  peerConnection = new RTCPeerConnection(config);

  peerConnection.onicecandidate = (event) => {
    if (event.candidate) {
      // Send the ICE candidate to the server
    }
  };

  peerConnection.ondatachannel = (event) => {
    const dataChannel = event.channel;
    dataChannel.onmessage = (event) => {
      terminal.innerHTML += event.data;
    };
  };

  const dataChannel = peerConnection.createDataChannel('terminal');
  dataChannel.onopen = () => {
    terminal.innerHTML += 'WebRTC DataChannel open\n';
  };

  document.addEventListener('keydown', (event) => {
    dataChannel.send(event.key);
  });

  const offer = await peerConnection.createOffer();
  await peerConnection.setLocalDescription(offer);
  // Send the offer to the server
}

startWebRTC();