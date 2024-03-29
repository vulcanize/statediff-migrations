-- +goose Up
CREATE TABLE eth.log_cids (
    id                  SERIAL PRIMARY KEY,
    leaf_cid            TEXT NOT NULL,
    leaf_mh_key         TEXT NOT NULL REFERENCES public.blocks (key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
    receipt_id          INTEGER NOT NULL REFERENCES eth.receipt_cids (id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
    address             VARCHAR(66) NOT NULL,
    log_data            BYTEA,
    index               INTEGER NOT NULL,
    topic0              VARCHAR(66),
    topic1              VARCHAR(66),
    topic2              VARCHAR(66),
    topic3              VARCHAR(66),
    UNIQUE (receipt_id, index)
);

ALTER TABLE eth.receipt_cids
DROP COLUMN topic0s,
DROP COLUMN topic1s,
DROP COLUMN topic2s,
DROP COLUMN topic3s,
DROP COLUMN log_contracts,
ADD COLUMN log_root VARCHAR(66);

CREATE INDEX log_rct_id_index ON eth.log_cids USING btree (receipt_id);
CREATE INDEX log_mh_index ON eth.log_cids USING btree (leaf_mh_key);
CREATE INDEX log_cid_index ON  eth.log_cids USING btree (leaf_cid);
CREATE INDEX log_topic0_index ON eth.log_cids USING btree (topic0);
CREATE INDEX log_topic1_index ON eth.log_cids USING btree (topic1);
CREATE INDEX log_topic2_index ON eth.log_cids USING btree (topic2);
CREATE INDEX log_topic3_index ON eth.log_cids USING btree (topic3);

-- +goose Down
-- log indexes

ALTER TABLE eth.receipt_cids
ADD COLUMN topic0s VARCHAR(66)[],
ADD COLUMN topic1s VARCHAR(66)[],
ADD COLUMN topic2s VARCHAR(66)[],
ADD COLUMN topic3s VARCHAR(66)[],
ADD COLUMN log_contracts VARCHAR(66)[],
DROP COLUMN log_root;

CREATE INDEX rct_topic0_index ON eth.receipt_cids USING gin (topic0s);
CREATE INDEX rct_topic1_index ON eth.receipt_cids USING gin (topic1s);
CREATE INDEX rct_topic2_index ON eth.receipt_cids USING gin (topic2s);
CREATE INDEX rct_topic3_index ON eth.receipt_cids USING gin (topic3s);
CREATE INDEX rct_log_contract_index ON eth.receipt_cids USING gin (log_contracts);

DROP INDEX eth.log_rct_id_index;
DROP INDEX eth.log_mh_index;
DROP INDEX eth.log_cid_index;
DROP INDEX eth.log_topic0_index;
DROP INDEX eth.log_topic1_index;
DROP INDEX eth.log_topic2_index;
DROP INDEX eth.log_topic3_index;

DROP TABLE eth.log_cids;
