var express = require("express"),
    app = express(),
    http = require("http").createServer(app),
    io = require("socket.io").listen(http),
    redis = require('redis').createClient();

app.set("ipaddr", "127.0.0.1");
app.set("port", 5001);

redis.subscribe('rtchange');

io.on('connection', function(socket){
    //socket.broadcast.emit('connected', "1");
    redis.on('message', function(channel, message){
        socket.emit('rtchange', JSON.parse(message));
    });
});

http.listen(app.get("port"), app.get("ipaddr"), function() {
    console.log("RUN");
}).on("error", function(error){
    console.log(error);
});