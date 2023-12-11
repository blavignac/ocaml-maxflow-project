type coloc =
  { name: string ;
    id: int ;
    value: int }

let read_file path =
  let infile = open_in path in
  (* Read all lines until end of file. *)
  let rec loop bGuys gGuys id total=
    try
      let line = input_line infile in
      (* Remove leading and trailing spaces. *)
      let line = String.trim line in
        (* Ignore empty lines *)
        if line = "" then loop bGuys gGuys id total
        (* The first character of a line determines its content : n or e. *)
        else match line.[0] with
          | '%' -> loop bGuys gGuys id total
          | _ -> 
              let cl = String.split_on_char '#' line in
                let value_contributed = int_of_string (List.nth cl 1) in
                  if (value_contributed = 0) 
                    then loop ({name=List.hd cl; id=id;value=value_contributed}::bGuys) gGuys (id+1) total
                    else loop bGuys ({name=List.hd cl; id=id;value=value_contributed}::gGuys) (id+1) (total+value_contributed)
    with End_of_file -> (bGuys, gGuys, id, total) (* Done *)
  in
  close_in infile ;
  loop [] [] 2;
;;

let graph_in_out = 
  let graph = Graph.new_node Graph.empty_graph 0 in
  let graph = Graph.new_node graph 1 in
    graph;;

let build_graph coloc_list = 
  List.fold_left (fun gr {name=_;id;_} -> Graph.new_node gr id) graph_in_out coloc_list;;
let add_arcs coloc_list total = 
  let graph = List.fold_left (fun gr {name=_;id;_} -> Graph.new_arc gr {})