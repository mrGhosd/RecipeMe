window.RecipeMe.realtime = {
    connect : function(){
        window.RecipeMe.socket = io.connect("http://188.166.99.8:5001");
        //window.RecipeMe.socket = io.connect("http://0.0.0.0:5001");

        window.RecipeMe.socket.on("rt-change", function(message){
            // publish the change on the client side, the channel == the resource
            for(var key in message.obj){
                if(key == "image" || key == "avatar"){
                    continue;
                } else {
                    message.obj[key] = decodeURIComponent(escape(message.obj[key]));
                }
            }
            Backbone.trigger(message.resource, message);
        });
    }
}