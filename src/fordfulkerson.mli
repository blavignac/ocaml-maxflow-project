open Graph

val find_path: string graph -> id -> id -> string arc list;;

val max_flow: string arc list -> int;;

val flow_graph: string graph -> string graph;;

val update_flow: string graph -> 'a arc list -> int -> string graph;;

val ford_fulkerson: string graph -> id -> id -> (string graph * int);;
