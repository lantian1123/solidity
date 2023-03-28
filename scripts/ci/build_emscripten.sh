#!/usr/bin/env bash

#------------------------------------------------------------------------------
# This script builds the solidity binary using Emscripten.
# Emscripten is a way to compile C/C++ to JavaScript.
#
# http://kripken.github.io/emscripten-site/
#
# First run install_dep.sh OUTSIDE of docker and then
# run this script inside a docker image trzeci/emscripten
#
# The documentation for solidity is hosted at:
#
# https://docs.soliditylang.org
#
# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016 solidity contributors.
#------------------------------------------------------------------------------

set -ev

SCRIPT_DIR="$(realpath "$(dirname "$0")/..")"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

function build() {
    local build_dir="$1"
    local prerelease_source="${2:-ci}"

    cd /root/project
	cp scripts/docker/buildpack-deps/emscripten.jam /usr/src

	apt-get update && \
	apt-get install lz4 --no-install-recommends && \
	\
	cd /usr/src && \
	git clone https://github.com/Z3Prover/z3.git -b z3-4.11.2 --depth 1 && \
	cd z3 && \
	mkdir build && \
	cd build && \
	emcmake cmake \
		-DCMAKE_INSTALL_PREFIX=$(em-config CACHE)/sysroot/usr \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DZ3_BUILD_LIBZ3_SHARED=OFF \
		-DZ3_ENABLE_EXAMPLE_TARGETS=OFF \
		-DZ3_BUILD_TEST_EXECUTABLES=OFF \
		-DZ3_BUILD_EXECUTABLE=OFF \
		-DZ3_SINGLE_THREADED=ON \
		-DCMAKE_CXX_FLAGS="-s DISABLE_EXCEPTION_CATCHING=0 -pthread -s USE_PTHREADS=1" \
		-DCMAKE_STATIC_LINKER_FLAGS="-s -pthread -s USE_PTHREADS=1" \
		.. && \
	make && \
	make install && \
	rm -r /usr/src/z3 && \
	cd /usr/src && \
	\
	wget -q 'https://boostorg.jfrog.io/artifactory/main/release/1.75.0/source/boost_1_75_0.tar.bz2' -O boost.tar.bz2 && \
	test "$(sha256sum boost.tar.bz2)" = "953db31e016db7bb207f11432bef7df100516eeb746843fa0486a222e3fd49cb  boost.tar.bz2" && \
	tar -xf boost.tar.bz2 && \
	rm boost.tar.bz2 && \
	cd boost_1_75_0 && \
	mv ../emscripten.jam . && \
	./bootstrap.sh && \
	echo "using emscripten : : em++ ;" >> project-config.jam && \
	./b2 toolset=emscripten link=static variant=release threading=single runtime-link=static \
		--with-system --with-filesystem --with-test --with-program_options \
		cxxflags="-s DISABLE_EXCEPTION_CATCHING=0 -pthread -s USE_PTHREADS=1 -Wno-unused-local-typedef -Wno-variadic-macros -Wno-c99-extensions -Wno-all" \
	       --prefix=$(em-config CACHE)/sysroot/usr install && \
	rm -r /usr/src/boost_1_75_0

    # shellcheck disable=SC2166
    if [[ "$CIRCLE_BRANCH" = release || -n "$CIRCLE_TAG" || -n "$FORCE_RELEASE" || "$(git tag --points-at HEAD 2>/dev/null)" == v* ]]
    then
        echo -n >prerelease.txt
    else
        # Use last commit date rather than build date to avoid ending up with builds for
        # different platforms having different version strings (and therefore producing different bytecode)
        # if the CI is triggered just before midnight.
        TZ=UTC git show --quiet --date="format-local:%Y.%-m.%-d" --format="${prerelease_source}.%cd" >prerelease.txt
    fi
    if [ -n "$CIRCLE_SHA1" ]
    then
        echo -n "$CIRCLE_SHA1" >commit_hash.txt
    fi

    # Disable warnings for unqualified `move()` calls, introduced and enabled by
    # default in clang-16 which is what the emscripten docker image uses.
    # Additionally, disable the warning for unknown warnings here, as this script is
    # also used with earlier clang versions.
    # TODO: This can be removed if and when all usages of `move()` in our codebase use the `std::` qualifier.
    CMAKE_CXX_FLAGS="-Wno-unqualified-std-cast-call"

    mkdir -p "$build_dir"
    cd "$build_dir"
    emcmake cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBoost_USE_STATIC_LIBS=1 \
        -DBoost_USE_STATIC_RUNTIME=1 \
        -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}" \
        -DTESTS=0 \
    ..
    make soljson

    cd ..
    mkdir -p upload
    scripts/ci/pack_soljson.sh "$build_dir/libsolc/soljson.js" "$build_dir/libsolc/soljson.wasm" upload/soljson.js
    cp upload/soljson.js ./

    OUTPUT_SIZE=$(ls -la soljson.js)

    echo "Emscripten output size: $OUTPUT_SIZE"
}

function show_help() {
cat << EOF
Usage: ${0##*/} [-h|--help] [--build-dir DIR] [--prerelease-source prerelease_source]
Build Solidity emscripten binary
    -h | --help          Display this help message
    --build-dir          The emscripten build directory
    --prerelease-source  The prerelease source string. E.g. 'nightly' or 'ci'.
EOF
}

function main() {
    local build_dir="emscripten_build"
    local prerelease_source=""

    while (( $# > 0 )); do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            --build-dir)
                [[ -n "$2" ]] || fail "Option --build-dir cannot be empty"
                build_dir="$2"
                shift 2
                ;;
            --prerelease-source)
                [[ -n "$2" ]] || fail "Option --prerelease-source cannot be empty"
                prerelease_source="$2"
                shift 2
                ;;
            *) fail "Invalid option: $1" ;;
        esac
    done
    build "$build_dir" "$prerelease_source"
}

main "$@"
