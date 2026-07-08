.PHONY: clean

clean:
	docker compose down -v --remove-orphans
	rm -rf data/loki/*
	rm -rf data/minio/*