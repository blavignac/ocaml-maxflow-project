open Graph
open Gfile
type coloc =
  { name: string ;
    id: int ;
    value: int }
;;

val read_file: path -> (coloc list * int * int);;
val strip_graph: string graph -> string graph;;
val _export_coloc:  path -> string graph -> coloc list -> unit;;
val build_graph: coloc list -> int -> string graph;;