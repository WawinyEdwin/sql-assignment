CREATE TABLE group_chat_messages (
    message_id INT REFERENCES messages(id) PRIMARY KEY,
    group_chat_id INT REFERENCES group_chats(id) NOT NULL
);