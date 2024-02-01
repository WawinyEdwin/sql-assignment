CREATE
OR REPLACE FUNCTION insert_message_and_link_to_group_chat (
  group_sender_id INT,
  group_content TEXT,
  in_group_chat_id INT
) RETURNS VOID AS $ $ DECLARE newly_inserted_message_id INT;

BEGIN BEGIN
INSERT INTO
  messages (sender_id, content)
VALUES
  (group_sender_id, group_content) RETURNING id INTO newly_inserted_message_id;

IF FOUND THEN BEGIN
INSERT INTO
  group_chat_messages (message_id, group_chat_id)
VALUES
  (newly_inserted_message_id, in_group_chat_id);

-- This is is transaction if an exception is raised it wont commit
EXCEPTION
WHEN OTHERS THEN RAISE EXCEPTION 'An error occurred while inserting into group chat messages';

END;

END IF;

END;

END;

$ $ LANGUAGE plpgsql;