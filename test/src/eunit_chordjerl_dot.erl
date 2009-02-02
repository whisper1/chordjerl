-module(eunit_chordjerl_dot).
-include_lib("eunit/include/eunit.hrl").
-include_lib("../../include/defines.hrl").

-define(MOD, chordjerl_srv).

setup() -> % todo, figure out how to tear-down
     % start three nodes
     chordjerl_srv:start_named(testnode1),
     chordjerl_srv:start_named(testnode2),
     chordjerl_srv:start_named(testnode3),
     ok = gen_server:call(testnode1, {create_ring}),
     Node1  = gen_server:call(testnode1, {return_finger_ref}),
     ok     = gen_server:call(testnode2, {join, Node1}),
     Node2  = gen_server:call(testnode2, {return_finger_ref}),
     ok     = gen_server:call(testnode3, {join, Node2}),
     {ok}.

generate_diagram_test_() ->
  {
      setup, fun setup/0,
      fun () ->
         Response = chordjerl_dot:generate_server_graph(testnode3),
         {ok, FileId} = file:open("server.dot", [read, write]),
         io:fwrite(FileId, "~s~n", [Response]),
         file:close(FileId),
         {ok}
      end
  }.

