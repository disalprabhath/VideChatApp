
const express = require("express");
const app = express();
const server = require("http").Server(app);
const { v4: uuidv4 } = require("uuid");
const PORT = process.env.PORT || 3000;

app.set("view engine", "ejs","js");

const io = require("socket.io")(server, {
  cors: {
    origin: '*'
  }
});

const { ExpressPeerServer } = require("peer");
const { Stream } = require("stream");
const { SocketAddress } = require("net");
const peerServer = ExpressPeerServer(server, {
  debug: true,
});

app.use("/peerjs", peerServer);
app.use(express.static("public"));

app.get("/", (req, res) => {
  res.redirect(`/${uuidv4()}`);
});

app.get("/:room", (req, res) => {
  res.render("room", { roomId: req.params.room });
});

io.on("connection", (socket) => {
  socket.on("join-room", (roomId, user, userName) => {
    socket.join(roomId);
    socket.to(roomId).broadcast.emit("user-connected", user);
    socket.on("video",(Stream) => {
      
    });
    socket.on("message", (message) => {
      io.to(roomId).emit("createMessage", message, userName);
    });
  });
});

/*server.listen(process.env.PORT || 3000);*/
server.listen(PORT, () => console.log(`Server is up and running on port ${PORT}`));