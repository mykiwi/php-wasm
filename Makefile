build-wasm: Dockerfile docker-bake.hcl
	docker buildx bake
	@touch -f $@

.PHONY: build-data
build-data:
	@mkdir -p $@
	@docker run \
		-v $(PWD)/demo/src:/src \
		-v $(PWD)/build-data:/dist \
		-w /dist \
		soyuka/php-wasm:latest \
		python3 \
			/emsdk/upstream/emscripten/tools/file_packager.py \
			php-web.data \
			--use-preload-cache \
			--lz4 \
			--preload "/src" \
			--js-output=php-web.data.js \
			--no-node \
			--exclude '*/.*' \
			--export-name=createPhpModule
	@touch -f $@

demo: build-wasm build-data
	sed '/--pre-js/r build-data/php-web.data.js' build-wasm/php-web.mjs > demo/public/php-web.mjs

.PHONY: clean
clean:
	rm -rf \
		build-wasm \
		build-data \
		demo/public/php-web.mjs
