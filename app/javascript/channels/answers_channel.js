import consumer from "./consumer";

consumer.subscriptions.create(
    { channel: "AnswersChannel", question_id: gon.question_id },
    {
         connected() {
             //console.log("connected");
             //this.perform("follow");
        },

        received(data) {
            //console.log(data);
            //$(".answers").append(data["partial"]);
            // Called when there's incoming data on the websocket for this channel
        },
    }
);
