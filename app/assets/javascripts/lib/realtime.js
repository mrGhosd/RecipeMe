window.RecipeMe.realtime = {
    connect : function(){
        window.RecipeMe.socket = io.connect("http://0.0.0.0:5001");

        window.RecipeMe.socket.on("rt-change", function(message){
            // publish the change on the client side, the channel == the resource
            console.log(message.resource, message);
            Backbone.trigger(message.resource, message);
        });
    }
}