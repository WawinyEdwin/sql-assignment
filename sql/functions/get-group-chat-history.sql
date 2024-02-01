CREATE
OR REPLACE FUNCTION get_group_chat_history (in_group_chat_id INT) RETURNS TABLE (
    message_id INT,
    sender_id INT,
    content TEXT,
    message_timestamp TIMESTAMPTZ
) AS $ $ BEGIN RETURN QUERY
SELECT
    m.id,
    m.sender_id,
    m.content,
    m.created_at AS message_timestamp
FROM
    group_chat_messages gcm
    JOIN messages m ON gcm.message_id = m.id
WHERE
    gcm.group_chat_id = in_group_chat_id
ORDER BY
    m.created_at;

END;

$ $ LANGUAGE plpgsql;