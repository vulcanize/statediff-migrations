-- +goose Up
ALTER TABLE eth.header_cids
ADD COLUMN base_fee BIGINT;

-- +goose Down
ALTER TABLE eth.header_cids
DROP COLUMN base_fee;
