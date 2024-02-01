-- Postgres Extensions
CREATE EXTENSION IF NOT EXISTS http;
CREATE EXTENSION IF NOT EXISTS pg_cron;

CREATE
OR REPLACE FUNCTION check_subscription_and_notify () RETURNS TRIGGER AS $ $ DECLARE subscription_row subscriptions % ROWTYPE;

BEGIN -- Fetch users with subscriptions that are about to expire
FOR subscription_row IN
SELECT
    *
FROM
    subscriptions
WHERE
    CURRENT_TIMESTAMP + INTERVAL '7 days' >= end_date LOOP
    -- I turned off JWT verification as the call is made from a secure env(Inside the DB) based on my requirements
    -- send a notification to the user
    url := 'https://tbvkvsxgntavgnllkxhd.supabase.co/functions/v1/notify';

request_body := json_build_object(
    'title',
    'Your mytrailpals subscription is about to expire',
    'body',
    'Jump back in to renew subscription',
    'user_id',
    subscription_row.id
) :: text;

-- Make the API call
response := http_post(
    url,
    request_body,
    ARRAY ['Content-Type: application/json']
);

END LOOP;

RETURN NULL;

END;

$ $ LANGUAGE plpgsql;

-- Schedule the function to run daily at 12:00 AM
-- This can be changed to a time the users are mostlikely to interact with the app
SELECT
    cron.schedule (
        '0 0 * * *',
        $ $
        SELECT
            check_subscription_and_notify() $ $
    );