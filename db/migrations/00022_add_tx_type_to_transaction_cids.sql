-- +goose Up
ALTER TABLE eth.transaction_cids
ADD COLUMN tx_type BYTEA;

-- +goose Down
ALTER TABLE eth.transaction_cids
DROP COLUMN tx_type;