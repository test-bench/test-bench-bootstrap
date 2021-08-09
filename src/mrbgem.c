#include <mruby.h>
#include <mruby/array.h>
#include <mruby/error.h>
#include <mruby/presym.h>
#include <mruby/string.h>

#include <glib.h>

#include <unistd.h>

static mrb_value
get_backtrace_frame(mrb_state* mrb, mrb_int frame_index) {
  mrb_value backtrace = mrb_get_backtrace(mrb);

  return mrb_ary_entry(backtrace, frame_index);
}

static mrb_value
mrb_test_bench_bootstrap_abort_build(mrb_state* mrb, mrb_value self) {
  struct RClass* test_bench_module = mrb_module_get(mrb, "TestBench");
  struct RClass* bootstrap_module = mrb_module_get_under(mrb, test_bench_module, "Bootstrap");

  struct RClass* abort_class = mrb_class_get_under(mrb, bootstrap_module, "Abort");

  mrb_value abort = mrb_obj_new(mrb, abort_class, 0, NULL);

  mrb_value backtrace = mrb_ary_new_capa(mrb, 1);

  const mrb_int entry_index = 3;
  mrb_ary_push(mrb, backtrace, get_backtrace_frame(mrb, entry_index));

  mrb_funcall_id(mrb, abort, MRB_SYM(set_backtrace), 1, backtrace);

  return abort;
}

static mrb_value
mrb_test_bench_bootstrap_backtrace_frame(mrb_state* mrb, mrb_value self) {
  mrb_int frame_index;

  mrb_get_args(mrb, "i", &frame_index);

  frame_index += 2;

  return get_backtrace_frame(mrb, frame_index);
}

static mrb_value
mrb_test_bench_bootstrap_path_match_p(mrb_state* mrb, mrb_value self) {
  const char* pattern;
  const char* text;

  mrb_get_args(mrb, "zz", &pattern, &text);

  mrb_bool matched = g_pattern_match_simple(pattern, text);

  return mrb_bool_value(matched);
}

static void
path_search_raw(mrb_state* mrb, const char* dir, GDir* g_dir, const char* include_pattern, const char* exclude_pattern, mrb_value files) {
  const char* entry;
  while((entry = g_dir_read_name(g_dir)) != NULL) {
    const char* path = g_build_filename(dir, entry, NULL);

    GDir* inner_dir = g_dir_open(path, 0, NULL);
    if(inner_dir != NULL) {
      path_search_raw(mrb, path, inner_dir, include_pattern, exclude_pattern, files);
      g_dir_close(inner_dir);
    } else {
      if(g_pattern_match_simple(include_pattern, path)) {
        if(exclude_pattern == NULL || !g_pattern_match_simple(exclude_pattern, path)) {
          mrb_ary_push(mrb, files, mrb_str_new_cstr(mrb, path));
        }
      }
    }
  }
}

static void
path_search(mrb_state* mrb, const char* path, const char* include_pattern, const char* exclude_pattern, mrb_value files) {
  if(g_file_test(path, G_FILE_TEST_IS_DIR)) {
    GDir* dir = g_dir_open(path, 0, NULL);

    path_search_raw(mrb, path, dir, include_pattern, exclude_pattern, files);

    g_dir_close(dir);
  } else if(g_file_test(path, G_FILE_TEST_EXISTS)) {
    mrb_ary_push(mrb, files, mrb_str_new_cstr(mrb, path));
  } else {
    mrb_raisef(mrb, mrb_exc_get_id(mrb, MRB_ERROR_SYM(LoadError)), "no such file or directory -- %s", path);
  }
}

static mrb_value
mrb_test_bench_bootstrap_path_search(mrb_state* mrb, mrb_value self) {
  const char* dir;
  const char* include_pattern = "*";
  const char* exclude_pattern = NULL;

  mrb_get_args(mrb, "z|zz", &dir, &include_pattern, &exclude_pattern);

  mrb_value files = mrb_ary_new(mrb);

  path_search(mrb, dir, include_pattern, exclude_pattern, files);

  return files;
}

static mrb_value
mrb_output_device_write(mrb_state* mrb, mrb_value self) {
  const char* text;
  size_t text_length;

  mrb_get_args(mrb, "s", &text, &text_length);

  write(STDOUT_FILENO, text, text_length);

  return mrb_fixnum_value(text_length);
}

static mrb_value
mrb_test_bench_bootstrap_defaults_output_device(mrb_state* mrb, mrb_value self) {
  struct RClass* device_cls = mrb_class_new(mrb, mrb->object_class);
  mrb_define_method(mrb, device_cls, "write", mrb_output_device_write, MRB_ARGS_REQ(1));

  return mrb_obj_new(mrb, device_cls, 0, NULL);
}

void
mrb_mruby_test_bench_bootstrap_gem_init(mrb_state* mrb) {
  struct RClass* test_bench_module = mrb_define_module(mrb, "TestBench");
  struct RClass* bootstrap_module = mrb_define_module_under(mrb, test_bench_module, "Bootstrap");

  struct RClass* abort_class = mrb_define_class_under(mrb, bootstrap_module, "Abort", mrb->eException_class);
  mrb_define_class_method(mrb, abort_class, "build", mrb_test_bench_bootstrap_abort_build, MRB_ARGS_NONE());

  struct RClass* backtrace_module = mrb_define_module_under(mrb, bootstrap_module, "Backtrace");
  mrb_define_class_method(mrb, backtrace_module, "frame", mrb_test_bench_bootstrap_backtrace_frame, MRB_ARGS_REQ(1));

  struct RClass* path_module = mrb_define_module_under(mrb, bootstrap_module, "Path");
  mrb_define_class_method(mrb, path_module, "match?", mrb_test_bench_bootstrap_path_match_p, MRB_ARGS_REQ(2));
  mrb_define_class_method(mrb, path_module, "search", mrb_test_bench_bootstrap_path_search, MRB_ARGS_ARG(1, 2));

  struct RClass* defaults_module = mrb_define_module_under(mrb, bootstrap_module, "Defaults");
  mrb_define_class_method(mrb, defaults_module, "output_device", mrb_test_bench_bootstrap_defaults_output_device, MRB_ARGS_NONE());
}

void
mrb_mruby_test_bench_bootstrap_gem_final(mrb_state* mrb) {
}
