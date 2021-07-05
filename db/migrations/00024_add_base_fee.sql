-- +goose Up
ALTER TABLE eth.header_cids
ADD COLUMN base_fee BIGINT DEFAULT 0;

-- +goose Down
ALTER TABLE eth.header_cids
DROP COLUMN base_fee;
