open Graph

let clone_nodes (gr: 'a graph) = n_fold gr (new_node) empty_graph;;

let gmap gr f = e_fold gr (fun gr1 {src;tgt;lbl} -> new_arc gr1 {src;tgt;lbl = (f lbl)}) (clone_nodes gr);;

let add_arc g id1 id2 n = 
  match find_arc g id1 id2 with
    | None -> new_arc g {src=id1;tgt=id2;lbl=n}
    | Some {src;tgt;lbl} -> new_arc g {src;tgt;lbl = lbl + n}
;;

let int_arc gr = gmap gr (fun x -> int_of_string x);; 

let string_arc gr = gmap gr (fun x -> string_of_int x);;


