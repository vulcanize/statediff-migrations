-- +goose Up
ALTER TABLE eth.receipt_cids
RENAME COLUMN cid TO leaf_cid;

ALTER TABLE eth.receipt_cids
RENAME COLUMN mh_key TO leaf_mh_key;

ALTER INDEX eth.rct_mh_index RENAME TO rct_leaf_cid_index;
ALTER INDEX eth.rct_cid_index RENAME TO rct_leaf_mh_key_index;

-- +goose Down
DROP INDEX eth.rct_leaf_cid_index;
DROP INDEX eth.rct_leaf_mh_key_index;
ALTER TABLE eth.receipt_cids
DROP COLUMN leaf_cid,
DROP COLUMN leaf_mh_key;