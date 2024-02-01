-- Can be app subscriptions
CREATE TABLE subscriptions (
    id SERIAL PRIMARY KEY,
    user_id REFERENCES users(id) NOT NULL,
    start_date TIMESTAMPZ,
    end_date TIMESTAMPZ
);