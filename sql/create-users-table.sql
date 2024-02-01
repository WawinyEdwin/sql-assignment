-- 
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    fcm_token TEXT, -- my assumption is the we are using Firebase Cloud Messaging(the device token is send to the server from the device)
    created_at DEFAULT CURRENT_TIMESTAMP
);