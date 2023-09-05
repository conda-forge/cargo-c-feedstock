# set -ex

# # Required for cross-compiling with pkg-config
# export PKG_CONFIG_SYSROOT_DIR=$PREFIX
# export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

# # Help the linker can find zlib
# export LIBRARY_PATH=$PREFIX/lib${LIBRARY_PATH:+:$LIBRARY_PATH}

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_HOME="$BUILD_PREFIX/cargo"
mkdir $CARGO_HOME

if [[ "$c_compiler" == "clang" ]]; then
  echo "-L$BUILD_PREFIX/lib -Wl,-rpath,$BUILD_PREFIX/lib" > $BUILD_PREFIX/bin/$BUILD.cfg
  echo "-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib" > $BUILD_PREFIX/bin/$HOST.cfg
fi

(
  # Needed to bootstrap itself into the conda ecosystem
  unset CARGO_BUILD_TARGET
  export CARGO_BUILD_RUSTFLAGS=$(echo $CARGO_BUILD_RUSTFLAGS | sed "s@$PREFIX@$BUILD_PREFIX@g")
  export RUSTFLAGS=$CARGO_BUILD_RUSTFLAGS
  export PKG_CONFIG_PATH=${BUILD_PREFIX}/lib/pkgconfig
  unset MACOSX_DEPLOYMENT_TARGET
  unset CFLAGS
  unset CPPFLAGS
  unset LDFLAGS
  unset PREFIX
  # Check that all downstream libraries licenses are present
  export PATH=$CARGO_HOME/bin:$PATH
)

echo $CONDA_RUST_HOST, $CONDA_RUST_TARGET

export RUSTFLAGS=$CARGO_BUILD_RUSTFLAGS

# build statically linked binary with Rust
cargo install --verbose --locked --root "$PREFIX" --path .

# strip debug symbols
"$STRIP" "$PREFIX/bin/cargo-c"

# remove extra build file
rm -f "${PREFIX}/.crates.toml"
