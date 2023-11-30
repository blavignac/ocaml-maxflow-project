open Graph

let clone_nodes (gr: 'a graph) = n_fold gr (new_node) empty_graph;;

let gmap gr f = e_fold gr (fun gr1 {src;tgt;lbl} -> new_arc gr1 {src;tgt;lbl = (f lbl)}) (clone_nodes gr);;

let add_arc g id1 id2 n = 
  match find_arc g id1 id2 with
    | None -> new_arc g {src=id1;tgt=id2;lbl=n}
    | Some {src;tgt;lbl} -> new_arc g {src;tgt;lbl = lbl + n}
;;

let string_to_int_graph gr = gmap gr (fun x -> int_of_string x);; 

let int_to_string_graph gr = gmap gr (fun x -> string_of_int x);;

let print_path p = 
  match p with 
    | []-> Printf.printf "\n\n[]\n\n";
    | x::rest -> Printf.printf "\n\n[%d" x; 
      let rec loop p = 
        match p with
          | [] -> Printf.printf "]\n\n"
          | x::rest when rest == [] -> Printf.printf ", %d]\n\n" x
          | x::rest -> Printf.printf ", %d" x; loop rest
      in 
      loop rest;
