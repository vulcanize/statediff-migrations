-- +goose Up
CREATE INDEX state_node_type_index ON eth.state_cids USING btree (node_type);
CREATE INDEX storage_node_type_index ON eth.storage_cids USING btree (node_type);

-- +goose Down
DROP INDEX eth.storage_node_type_index;
DROP INDEX eth.state_node_type_index;
