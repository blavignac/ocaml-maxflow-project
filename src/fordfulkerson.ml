open Graph

(*
arc(src,tgt)   :- ....
path(orig, dest) :-
*)

let out_node gr id = 
  let rec loop aL acu =
    match aL with
      | [] -> List.rev acu
      | {src=_;tgt;lbl=_}::rest -> loop rest (tgt::acu)
  in
  loop (out_arcs gr id) []
;;

let find_path graph startNode endNode = 
  let rec loop visitedList qList = 
    match qList with
      | [] -> []
      | x::_ when (x = endNode) -> [x]
      | x::rest when (List.mem x visitedList) -> loop visitedList rest
      | x::rest -> let path = loop (x::visitedList) (out_node graph x) in 
        match path with 
          |[] -> loop (x::visitedList) rest
          |pl -> x::pl
  in
    loop [] [startNode]
;;
