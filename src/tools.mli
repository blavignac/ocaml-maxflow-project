open Graph

val clone_nodes: 'a graph -> 'b graph
val gmap: 'a graph -> ('a -> 'b) -> 'b graph
val add_arc: 'a graph -> id -> id -> 'a -> 'a graph
val string_to_int_graph: string graph -> int graph
val int_to_string_graph: int graph -> string graph
val print_path: 'a arc list -> unit

