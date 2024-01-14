type coloc =
  { name: string ;
    id: int ;
    value: int;}

let read_file path =
  let infile = open_in path in
  (* Read all lines until end of file. *)
    let rec loop people id total=
      try
        let line = input_line infile in 
          (* The first cn;i;v;0haracter of a line determines its content : % represents comment, anything else is a coloc name. *)
          match line.[0] with
            | '%' -> loop people id total
            | _ ->  
                let cl = String.split_on_char ' ' line in
                  match cl with 
                    | [x;y] -> loop ({name=x; id=id; value= (int_of_string y);}::people) (id+1) (total+(int_of_string y))
                    | _ -> raise (Not_found) 
      with 
        | End_of_file -> (people, id, total) (* Done *)
    in
    loop [] 2 0;
    (* close_in infile  *)
;;


let _update_coloc coloc_list total = 
  let part = total/(List.length coloc_list) in
  let rec loop coloc_list acu = 
    match coloc_list with
      | {name=n;id=i;value=v;}::rest -> let res = v - part in if res = 0 then loop rest acu else loop rest ({name=n;id=i;value=res;}::acu)
      | [] -> acu
  in
    loop coloc_list []
;;

let _add_in_out graph coloc_list = 
  List.fold_left (fun gr {name=_;id=i;value=v;} -> if v > 0 then Tools.add_arc  gr i 1 v  else (if v = 0 then gr else Tools.add_arc  gr 0 i (abs v))) graph coloc_list
;;

let _add_in_between graph coloc_list total =
  let rec loop graph1 coloc_ll =
    match coloc_ll with
    | {name=_;id=i;value=_;}::rest -> loop (List.fold_left (fun gr {name=_;id=i1;value=_;} -> Tools.add_arc (Tools.add_arc gr i i1 (total)) i1 i (total)) graph1 rest) rest
    | [] -> graph1
  in
  loop graph coloc_list
;;

let build_graph coloc_list _total = 
  let coloc_list = _update_coloc coloc_list _total in
  let graph = List.fold_left (fun gr {name=_;id;_} -> Graph.new_node gr id) (Graph.new_node (Graph.new_node Graph.empty_graph 0) 1) coloc_list 
in
  let graph = _add_in_out graph coloc_list in
  let graph = _add_in_between graph coloc_list _total in
  let graph = Fordfulkerson.flow_graph (Tools.int_to_string_graph graph) in
  let (graph,_) = Fordfulkerson.ford_fulkerson graph 0 1 in
  graph
;;
  