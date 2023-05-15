const socket = io("/");
const videoGrid = document.getElementById("video-grid");
const myVideo = document.createElement("video");
const showChat = document.querySelector("#showChat");
const backBtn = document.querySelector(".header__back");
myVideo.muted = true;

backBtn.addEventListener("click", () => {
  document.querySelector(".main__left").style.display = "flex";
  document.querySelector(".main__left").style.flex = "1";
  document.querySelector(".main__right").style.display = "none";
  document.querySelector(".header__back").style.display = "none";
});
showChat.addEventListener("click", () => {
  document.querySelector(".main__right").style.display = "flex";
  document.querySelector(".main__right").style.flex = "1";
  document.querySelector(".main__left").style.display = "none";
  document.querySelector(".header__back").style.display = "block";
});

const user = prompt("Enter your name");

var peer = new Peer(undefined, {
  path: "peerjs",
  host: "/",
  port: "3000",
});

let myVideoStream;

navigator.mediaDevices.getUserMedia({
  audio: true,
  video: true,
})
.then((stream) => {
  myVideoStream = stream;
  addVideoStream(myVideo, stream);

  peer.on("call", (call) => {
    call.answer(stream);
    const video = document.createElement("video");
    call.on("stream", (userVideoStream) => {
      addVideoStream(video, userVideoStream);
    });
  });

  socket.on("user-connected", (user) => {
    connectToNewUser(user, stream);
  });
});

const connectToNewUser = (user, stream) => {
const call = peer.call(user, stream);
const video = document.createElement("video");
call.on("stream", (userVideoStream) => {
  addVideoStream(video, userVideoStream);
});
};

peer.on("open", (id) => {
socket.emit("join-room", ROOM_ID, id, user);
});

const addVideoStream = (video, stream) => {
video.srcObject = stream;
video.addEventListener("loadedmetadata", () => {
  video.play();
  videoGrid.append(video);
});
};


videochatapp-group10

