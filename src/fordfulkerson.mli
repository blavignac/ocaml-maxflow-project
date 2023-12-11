open Graph


val find_path: 'a graph -> id -> id -> 'a arc list;;

val max_flow: string arc list -> int;;

val flow_graph: string graph -> string graph;;

val update_flow: string graph -> 'a arc list -> int -> string graph;;