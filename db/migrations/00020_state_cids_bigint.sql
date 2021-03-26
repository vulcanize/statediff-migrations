-- +goose Up
ALTER SEQUENCE eth.state_cids_id_seq as bigint NO MAXVALUE;
ALTER SEQUENCE eth.storage_cids_id_seq as bigint NO MAXVALUE;

-- +goose Down
ALTER SEQUENCE eth.storage_cids_id_seq as int NO MAXVALUE;
ALTER SEQUENCE eth.state_cids_id_seq as int NO MAXVALUE;