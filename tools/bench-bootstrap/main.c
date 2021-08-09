#include <mruby.h>
#include <mruby/array.h>
#include <mruby/string.h>

#include <stdlib.h>

int
main(int argc, char** argv) {
  mrb_state* mrb = mrb_open();
  if(mrb == NULL) {
    fprintf(stderr, "%s: Could not initialize mruby, exiting\n", *argv);
    return EXIT_FAILURE;
  }

  mrb_value paths = mrb_ary_new_capa(mrb, argc);

  for(int index = 1; index < argc; index++) {
    mrb_value path = mrb_str_new_cstr(mrb, argv[index]);
    mrb_ary_push(mrb, paths, path);
  }

  struct RClass* test_bench_module = mrb_module_get(mrb, "TestBench");
  struct RClass* bootstrap_module = mrb_module_get_under(mrb, test_bench_module, "Bootstrap");
  struct RClass* run_module = mrb_module_get_under(mrb, bootstrap_module, "Run");

  mrb_int arena_index = mrb_gc_arena_save(mrb);

  mrb_funcall(mrb, mrb_obj_value(run_module), "call", 1, paths);

  mrb_gc_arena_restore(mrb, arena_index);

  int exit_status = EXIT_FAILURE;

  if(mrb->exc) {
    mrb_print_error(mrb);
  } else {
    exit_status = EXIT_SUCCESS;
  }

  mrb_close(mrb);

  return exit_status;
}
