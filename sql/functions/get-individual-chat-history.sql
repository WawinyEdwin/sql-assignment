CREATE
OR REPLACE FUNCTION get_individual_chat_history (in_chat_id INT) RETURNS TABLE (
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
    individual_chat_messages icm
    JOIN messages m ON icm.message_id = m.id
WHERE
    icm.chat_id = in_chat_id
ORDER BY
    m.created_at;

END;

$ $ LANGUAGE plpgsql;