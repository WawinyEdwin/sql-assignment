-- messages exchanged between two individuals
CREATE TABLE individual_chat_messages (
    message_id INT REFERENCES messages(id) PRIMARY KEY,
    chat_id INT REFERENCES individual_chats(id) NOT NULL
);