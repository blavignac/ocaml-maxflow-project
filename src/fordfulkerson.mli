open Graph


val find_path: 'a graph -> id -> id -> 'a arc list;;

val max_flow: string graph -> int list -> int;;

val flow_graph: string graph -> string graph;;

val update_flow: string graph -> int list -> int -> string graph;;