
build:
	swift build

mint:
	mint bootstrap --link

mock: 
	./scripts/development/generate_mock.sh

generate: mock
