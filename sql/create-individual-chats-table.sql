-- a P2P chat
CREATE TABLE individual_chats (
    id SERIAL PRIMARY KEY,
    user1_id INT REFERENCES users(id) NOT NULL,
    user2_id INT REFERENCES users(id) NOT NULL,
    UNIQUE(user1_id, user2_id)
);