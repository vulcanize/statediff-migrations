-- +goose Up

DROP FUNCTION was_storage_removed;
DROP FUNCTION was_state_removed;
DROP FUNCTION "ethHeaderCidByBlockNumber"(bigint);

-- +goose StatementBegin
-- returns if a state leaf node was removed within the provided block number
CREATE OR REPLACE FUNCTION was_state_leaf_removed(key character varying, hash character varying)
    RETURNS boolean AS $$
    SELECT state_cids.node_type = 3
    FROM eth.state_cids
             INNER JOIN eth.header_cids ON (state_cids.header_id = header_cids.id)
    WHERE state_leaf_key = key
      AND block_number <= (SELECT block_number
                           FROM eth.header_cids
                           WHERE block_hash = hash)
    ORDER BY block_number DESC LIMIT 1;
$$
language sql;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- returns if a storage node at the provided path was removed in the range > the provided height and <= the provided block hash
CREATE OR REPLACE FUNCTION was_storage_removed(path BYTEA, height BIGINT, hash VARCHAR(66)) RETURNS BOOLEAN
AS $$
SELECT exists(SELECT 1
              FROM eth.storage_cids
                INNER JOIN eth.state_cids ON (storage_cids.state_id = state_cids.id)
                INNER JOIN eth.header_cids ON (state_cids.header_id = header_cids.id)
              WHERE storage_path = path
                AND block_number > height
                AND block_number <= (SELECT block_number
                                     FROM eth.header_cids
                                     WHERE block_hash = hash)
                AND storage_cids.node_type = 3
              LIMIT 1);
$$ LANGUAGE SQL;
-- +goose StatementEnd

-- +goose StatementBegin
-- returns if a state node at the provided path was removed in the range > the provided height and <= the provided block hash
CREATE OR REPLACE FUNCTION was_state_removed(path BYTEA, height BIGINT, hash VARCHAR(66)) RETURNS BOOLEAN
AS $$
SELECT exists(SELECT 1
              FROM eth.state_cids
                INNER JOIN eth.header_cids ON (state_cids.header_id = header_cids.id)
              WHERE state_path = path
                AND block_number > height
                AND block_number <= (SELECT block_number
                                     FROM eth.header_cids
                                     WHERE block_hash = hash)
                AND state_cids.node_type = 3
              LIMIT 1);
$$ LANGUAGE SQL;
-- +goose StatementEnd

-- +goose StatementBegin
CREATE FUNCTION "ethHeaderCidByBlockNumber"(n bigint) returns SETOF eth.header_cids
    stable
    language sql
as
$$
SELECT * FROM eth.header_cids WHERE block_number=$1 ORDER BY id
$$;
-- +goose StatementEnd

DROP FUNCTION was_state_leaf_removed;