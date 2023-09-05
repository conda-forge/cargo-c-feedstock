set -ex

# Required for cross-compiling with pkg-config
export PKG_CONFIG_SYSROOT_DIR=$PREFIX
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

CARGO_TARGET="${HOST}"
CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/conda/unknown/")"
CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/darwin.*/darwin/")"
CARGO_TARGET="$(echo -n ${CARGO_TARGET} | sed "s/arm64/aarch64/")"

# Help the linker can find zlib
export LIBRARY_PATH=$PREFIX/lib${LIBRARY_PATH:+:$LIBRARY_PATH}

cargo install \
    --path . \
    --root "${PREFIX}" \
    --target "${CARGO_TARGET}"

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
