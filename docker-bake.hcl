target "default" {
  context  = "./"
  output = ["type=local,dest=./build"]
  tags = ["php-wasm"]
}
