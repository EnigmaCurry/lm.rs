set export

current_dir := `pwd`
RUST_LOG := "debug"
RUST_BACKTRACE := "1"
GIT_REMOTE := "origin"

# print help for Just targets
help:
    @just -l

model:
    mkdir -p _model && \
    cd _model && \
    curl -L -C - -O "https://huggingface.co/samuel-vitorino/gemma2-9b-it-q8_0-LMRS/resolve/main/gemma2-9b-it-q80.lmrs" && \
    curl -L -C - -O "https://huggingface.co/samuel-vitorino/gemma2-9b-it-q8_0-LMRS/resolve/main/tokenizer.bin" && \
    curl -L -C - -O "https://huggingface.co/samuel-vitorino/gemma2-9b-it-q8_0-LMRS/resolve/main/README.md"

build:
    RUSTFLAGS="-C target-cpu=native" cargo build --release --bin chat

chat *args: build
    cd _model && ../target/release/chat --model=gemma2-9b-it-q80.lmrs {{args}}
