BIN = $(GOPATH)/bin

## Migration tool
GOOSE = $(BIN)/goose
$(BIN)/goose:
	go get -u -d github.com/pressly/goose/cmd/goose
	go build -tags='no_mysql no_sqlite' -o $(BIN)/goose github.com/pressly/goose/cmd/goose

#Database
HOST_NAME = localhost
PORT = 5432
NAME =
USER = postgres
CONNECT_STRING=postgresql://$(USER)@$(HOST_NAME):$(PORT)/$(NAME)?sslmode=disable

# Parameter checks
## Check that DB variables are provided
.PHONY: checkdbvars
checkdbvars:
	test -n "$(HOST_NAME)" # $$HOST_NAME
	test -n "$(PORT)" # $$PORT
	test -n "$(NAME)" # $$NAME
	@echo $(CONNECT_STRING)

#Test
TEST_DB = vulcanize_testing
TEST_CONNECT_STRING = postgresql://$(USER)@$(HOST_NAME):$(PORT)/$(TEST_DB)?sslmode=disable

.PHONY: test
test: | $(GINKGO)
	dropdb --if-exists $(TEST_DB)
	createdb $(TEST_DB)
	$(GOOSE) -dir db/migrations postgres "$(TEST_CONNECT_STRING)" up
	$(GOOSE) -dir db/migrations postgres "$(TEST_CONNECT_STRING)" reset

## Build docker image
.PHONY: docker-build
docker-build:
	docker build -t vulcanize/statediff-migrations -f Dockerfile .

## Apply all migrations not already run
.PHONY: migrate
migrate: $(GOOSE) checkdbvars
	$(GOOSE) -dir db/migrations postgres "$(CONNECT_STRING)" up
	pg_dump -O -s $(CONNECT_STRING) > db/schema.sql