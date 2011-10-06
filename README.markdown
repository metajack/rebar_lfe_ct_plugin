# Rebar LFE Commonn Test Plugin

This plugin allows Common Test suites to be written in LFE. It runs
before the normal `rebar ct` task and compiles all `.lfe` files in the
`test` subdirectory.

## Usage

In the `rebar.config` file of your project, add:

    {plugins, [rebar_lfe_ct_plugin]}.

And copy `rebar_lfe_ct_plugin.erl` to your project's `plugins`
directory.

You will also need to make sure LFE is a dependency of your project by
adding the following dependency information to the `deps` section of
your `rebar.config`.

    {lfe, ".*", {git, "git://github.com/rvirding/lfe.git", "head"}}
    
## Example LFE Common Test Suite

    (defmodule example_SUITE
      (export (all 0)
      (should_fail 1)
      (should_pass 1)))

    (defmacro assert (pat expr)
      `(let* ((val ,expr)
              (pat val))
         val))

    (defun all ()
      (list 'should_fail 'should_pass))

    (defun should_fail (config)
      (assert 1 2))

    (defun should_pass (config)
      (assert 1 1))
    
