#include <mruby.h>

#include <mruby/require/require.h>

void
mrb_mruby_test_bench_bootstrap_gem_init(mrb_state* mrb) {
  mrb_register_compiled_feature(mrb, "test_bench/bootstrap");

  return;
}

void
mrb_mruby_test_bench_bootstrap_gem_final(mrb_state* mrb) {
  return;
}
