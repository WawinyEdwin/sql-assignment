-- Notifications broadcasted to users
CREATE TABLE NOTIFICATIONS (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) NOT NULL,
    body JSON NOT NULL,
    created_at DEFAULT CURRENT_TIMESTAMP,
    --- the below columns are useful if we have a dedicated section in the app where users can view notifications
    is_read BOOLEAN DEFAULT FALSE,
    is_seen BOOLEAN DEFAULT FALSE,
)