-- junction table
CREATE TABLE group_chat_users (
    user_id INT REFERENCES users(id) NOT NULL,
    group_chat_id INT REFERENCES group_chats(id) NOT NULL,
    joined_at TIMESTAMPZ DEFAULT CURRENT_TIMESTAMP
    PRIMARY KEY(user_id, group_chat_id)
);