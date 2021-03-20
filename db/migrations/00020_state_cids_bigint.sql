-- +goose Up
ALTER SEQUENCE eth.state_cids_id_seq as bigint NO MAXVALUE;

-- +goose Down
ALTER SEQUENCE eth.state_cids_id_seq as int NO MAXVALUE;