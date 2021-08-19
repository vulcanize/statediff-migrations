-- +goose Up
CREATE TABLE eth.log_cids (
    id                  SERIAL PRIMARY KEY,
    receipt_id          INTEGER NOT NULL REFERENCES eth.receipt_cids (id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
    address             VARCHAR(66),
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

--
-- Name: log_topic0_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX log_topic0_index ON eth.log_cids USING btree (topic0);


--
-- Name: log_topic1_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX log_topic1_index ON eth.log_cids USING btree (topic1);


--
-- Name: log_topic2_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX log_topic2_index ON eth.log_cids USING btree (topic2);


--
-- Name: log_topic3_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX log_topic3_index ON eth.log_cids USING btree (topic3);


-- +goose Down
DROP TABLE eth.logs;