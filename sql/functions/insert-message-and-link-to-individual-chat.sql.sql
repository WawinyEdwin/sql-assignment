CREATE
OR REPLACE FUNCTION insert_message_and_link_to_individual_chat (
    in_sender_id INT,
    in_content TEXT,
    in_individual_chat_id INT
) RETURNS VOID AS $ $ DECLARE newly_inserted_message_id INT;

BEGIN BEGIN
INSERT INTO
    messages (sender_id, content)
VALUES
    (in_sender_id, in_content) RETURNING id INTO newly_inserted_message_id;

IF FOUND THEN BEGIN
INSERT INTO
    individual_chat_messages (message_id, chat_id)
VALUES
    (newly_inserted_message_id, in_individual_chat_id);

-- Here you can make the http request to the edge function used to send the notifications
-- The edge function I created can be used for this as it is generic
-- This is is transaction if an exception is raised it wont commit
EXCEPTION
WHEN OTHERS THEN RAISE EXCEPTION 'An error occurred while inserting into individual_chat_messages';

END;

END IF;

END;

END;

$ $ LANGUAGE plpgsql;