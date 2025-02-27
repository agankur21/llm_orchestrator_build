BUILD_SHARED_LIBS="BUILD_SHARED_LIBS": "ON", "BOOST_LINK_STATIC": "OFF"
INSTALL_DIR=/usr/local
PYTHON_INSTALL_DIR=/usr/local
PYTHON_INCLUDE_DIR=/usr/include/python3.12/
PYTHON_LIBRARY=/usr/lib/aarch64-linux-gnu/libpython3.12.so
PY_CMAKE="PYTHON_PACKAGE_INSTALL_DIR": "$(PYTHON_INSTALL_DIR)", "PYTHON_INCLUDE_DIR": "$(PYTHON_INCLUDE_DIR)", "PYTHON_LIBRARY": "$(PYTHON_LIBRARY)", "PYTHON_LIBRARIES": "$(PYTHON_LIBRARY)", "PYTHON_EXTENSIONS": "ON", "thriftpy3": "ON"
CMAKE_C_FLAGS=
CMAKE_CXX_FLAGS=-std=gnu++20 -O2 -I$(PYTHON_INCLUDE_DIR)
CMAKE_DEBUG="CMAKE_VERBOSE_MAKEFILE": "ON", "CMAKE_VERBOSE_DEBUG": "ON"
CMAKE_DEFINES='{$(PY_CMAKE), "CMAKE_CXX_STANDARD": "20", "CMAKE_POSITION_INDEPENDENT_CODE": "ON", "CMAKE_CXX_FLAGS": "$(CMAKE_CXX_FLAGS)", $(BUILD_SHARED_LIBS), $(CMAKE_DEBUG)}'
JMTEST_BUILD_DIR=/tmp/jmtest

.PHONY: build install 



install:
	make build target=fmt   # centos fmt version is old
	make build target=folly
	make build target=fizz
	make build target=wangle
	make build target=mvfst
	make build target=fbthrift
	make build target=fb303
	make build target=proxygen


build:
	./build/fbcode_builder/getdeps.py \
		--allow-system-packages \
		build $(target) \
		--extra-cmake-defines $(CMAKE_DEFINES) \
		--extra-b2-args "cxxflags=-fPIC" --extra-b2-args "cflags=-fPIC" \
		--install-dir $(INSTALL_DIR) \
		--no-test --clean --no-deps  --shared-libs --verbose \
		2>&1 | tee /var/log/build_$(target).log

