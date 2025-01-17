#!/bin/bash
#
# Copyright 2018 Delphix
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# shellcheck disable=SC2034

DEFAULT_PACKAGE_GIT_URL="https://github.com/delphix/bcc.git"

UPSTREAM_GIT_URL=https://github.com/iovisor/bcc.git
UPSTREAM_GIT_BRANCH=master

function prepare() {
	logmust install_pkgs \
		arping \
		bison \
		build-essential \
		clang-format-6.0 \
		cmake \
		flex \
		git \
		iperf \
		libclang-6.0-dev \
		libedit-dev \
		libelf-dev \
		libllvm6.0 \
		llvm-6.0-dev \
		luajit \
		luajit-5.1-dev \
		netperf \
		python \
		python-netaddr \
		python-pyroute2 \
		zlib1g-dev
}

function build() {
	logmust cd "$WORKDIR/repo"
	# Note: the string to determine the version was copied from bcc's
	# debian/rules file.
	PACKAGE_VERSION=$(dpkg-parsechangelog | sed -rne 's,^Version: (.*),\1,p')

	logmust dpkg_buildpackage_default

	# Install libbcc which is required to build bpftrace
	logmust install_pkgs "$WORKDIR/artifacts"/libbcc_*.deb
}

function update_upstream() {
	logmust update_upstream_from_git
}
