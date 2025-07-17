#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Refreshing upstream-lib"
echo "= = ="

gem_dir="gems"
ruby_engine="$(ruby -e "puts RUBY_ENGINE")"
ruby_platform_version="$(ruby -rrbconfig -e "puts RbConfig::CONFIG['ruby_version']")"
install_dir="$gem_dir/$ruby_engine/$ruby_platform_version"

export GEM_HOME="$(realpath .)/$install_dir"

rm -rf upstream-lib

mkdir -p upstream-lib/test_bench_bootstrap

for gem_dir in $install_dir/gems/*; do
  for input_file in $(find $gem_dir -type f); do
    file=${input_file/#$gem_dir\//}
    file=${file/#lib/upstream-lib\/test_bench_bootstrap}

    if [ ${file%%/*} != "upstream-lib" ]; then
      continue
    fi

    mkdir -p $(dirname $file)

    ed --quiet --verbose --extended-regexp $input_file <<ED
#
## Update require statements
,g/^require '.*'$/s/^require '(.*)'$/require 'test_bench_bootstrap\/\1'/
#
## Correct require statements for standard libraries
,g/^require '.*'$/s/^require 'test_bench_bootstrap\/(json|fileutils|tempfile|shellwords)'$/require '\1'/
#
## Find all outermost module and class declarations, then indent every line, ...
,g/^(module|class)/,s/^(.)/  \\1/\\
## ..., then prepend 'module TestBenchBootstrap', ...\\
0i\\
module TestBenchBootstrap\\
.\\
## ..., then append 'end'\\
\$a\\
end
#
## Replace TestBench::CLI with TestBenchBootstrap::TestBench::CLI
,g/^TestBench::CLI\.\(\)$/c\\
TestBenchBootstrap::TestBench::CLI.()
#
## Write file
w $file
ED

    if [ -f $file ]; then
      echo $file
    else
      echo -e "\e[1;31mError: couldn't write $file\e[39;22m"
      false
    fi
  done
done

echo "Done ($(basename "$0"))"
