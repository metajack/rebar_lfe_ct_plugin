%% rebar_lfe_ct_plugin.erl
%% Rebar plugin to add support for Common Test suites written in LFE.
%%
%% Copyright 2011 Jack Moffitt <jack@metajack.im>
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(rebar_lfe_ct_plugin).

-export([pre_ct/2]).

%% Rebar macros the plugin needs
-define(CONSOLE(Str, Args), io:format(Str, Args)).
-define(FAIL, throw({error, failed})).

%% The plugin runs before the normal ct task.
pre_ct(Config, _AppFile) ->
    rebar_base_compiler:run(Config, [], "test", ".lfe", "test", ".beam",
                            fun compile_lfe/3).

%% The following function was lifted and only trivially changed from
%% mainline rebar since it was not exported as public.
compile_lfe(Source, _Target, Config) ->
    case code:which(lfe_comp) of
        non_existing ->
            ?CONSOLE(<<
                       "~n"
                       "*** MISSING LFE COMPILER ***~n"
                       "  You must do one of the following:~n"
                       "    a) Install LFE globally in your erl libs~n"
                       "    b) Add LFE as a dep for your project, eg:~n"
                       "       {lfe, \"0.6.1\",~n"
                       "        {git, \"git://github.com/rvirding/lfe\",~n"
                       "         {tag, \"v0.6.1\"}}}~n"
                       "~n"
                     >>, []),
            ?FAIL;
        _ ->
            Opts = [{i, "include"}, {outdir, "test"}, report]
                ++ rebar_config:get_list(Config, erl_opts, []),
            case lfe_comp:file(Source, Opts) of
                {ok, _} ->
                    ok;
                _ ->
                    ?FAIL
            end
    end.
