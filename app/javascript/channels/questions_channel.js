import consumer from "./consumer";

consumer.subscriptions.create(
    { channel: "QuestionsChannel" },
    {
        received(data) {
            $(".questions-list").append(data["partial"]);
        },
    }
);