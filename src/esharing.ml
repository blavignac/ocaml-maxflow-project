
open Printf
open Graph
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

let strip_graph graph =
  let graph1 = Graph.n_fold graph (fun g n -> (Printf.printf "wow1 %d" n);if n = 1 || n = 0 then g else Graph.new_node g n) Graph.empty_graph
in
  let graph2 = 
    Graph.e_fold graph (
      fun g1 {src=id1;tgt=id2;lbl=lbl} -> 
        let _l = match (String.split_on_char '/' lbl) with
          | "0"::_ -> 0
          | _ -> 1
       in if (_l = 0 ||id1 = 0 || id1 = 1 || id2 = 0 || id2 = 1) then g1 else (Tools.add_arc g1 id1 id2 lbl)
      ) graph1 in
graph2
;;

let _export_coloc path graph coloc_list= 
  let ff = open_out path in
  (* write header code to file *)
  fprintf ff 
  "digraph finite_state_machine {\n
  fontname=\"Helvetica,Arial,sans-serif\"\n
  node [fontname=\"Helvetica,Arial,sans-serif\"]\n
  edge [fontname=\"Helvetica,Arial,sans-serif\"]\n
  rankdir=LR;\n";
  fprintf ff "node [shape = circle];\n";
  
  (* write arcs to file in their special formating *)
  let _ = e_iter graph 
    (fun arc -> 
      let src = (List.find (fun {name=_;id=i;value=_;} -> if (i = arc.src) then true else false) coloc_list).name 
      in 
      let tgt = (List.find (fun {name=_;id=i;value=_;} -> if i = arc.tgt then true else false) coloc_list).name 
      in fprintf ff "%s -> %s [label = \"%s\"];\n" src tgt arc.lbl) in
  (* write the end of file *)
  fprintf ff "}\n";

  close_out ff ;
  ()

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
  