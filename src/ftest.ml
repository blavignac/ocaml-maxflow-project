open Gfile
    
let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 6 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n"^
         "    🟄  exportfile: output with Graphviz conformant syntax. \n\n"
         ) ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) exportfile(5) *)
  
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)

  and exportfile = Sys.argv.(5)
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in
  

  (* Open file *)
  let graph = from_file infile in

  (* let graph = Tools.int_to_string_graph (Tools.add_arc (Tools.string_to_int_graph graph) 0 5 11) in
  let graph = Tools.int_to_string_graph (Tools.add_arc (Tools.string_to_int_graph graph) 2 0 11) in
  let graph = Tools.int_to_string_graph (Tools.add_arc (Tools.string_to_int_graph graph) 2 3 11) in
  let graph = Tools.int_to_string_graph (Tools.add_arc (Tools.string_to_int_graph graph) 2 5 11) in
  let graph = Tools.int_to_string_graph (Tools.add_arc (Tools.string_to_int_graph graph) 2 2 11) in
  let graph = Tools.int_to_string_graph (Tools.add_arc (Tools.string_to_int_graph graph) 2 1 11) in *)

  let _= Tools.print_path (Fordfulkerson.find_path (Tools.string_to_int_graph graph) _source _sink) in

  (* Rewrite the graph that has been read. *)
  let () = write_file outfile graph in
  let () = export exportfile graph in

  ()