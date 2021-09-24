-- +goose Up
-- +goose StatementBegin
-- returns if a state leaf node was removed within the provided block number
CREATE OR REPLACE FUNCTION was_state_leaf_removed(key character varying, hash character varying) RETURNS boolean
    LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT state_cids.node_type
               FROM eth.state_cids
                        INNER JOIN eth.header_cids ON (state_cids.header_id = header_cids.id)
               WHERE state_leaf_key = key
                 AND block_number <= (SELECT block_number FROM eth.header_cids WHERE block_hash = hash)
               ORDER BY state_cids.id DESC LIMIT 1
        LOOP
            IF rec.node_type = 3 THEN
                RETURN TRUE;
            END IF;
        END LOOP;
    RETURN FALSE;
END;
$$;
-- +goose StatementEnd


-- +goose Down
DROP FUNCTION was_state_leaf_removed;