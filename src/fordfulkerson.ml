open Graph

(*
arc(src,tgt)   :- ....
path(orig, dest) :-
*)

let find_path graph startNode endNode = 
  let ll = out_arcs graph startNode in
  let rec loop visitedList qList = 
    match qList with
      | [] -> []
      | x::_ when (x.tgt = endNode) -> [x]
      | x::rest when (List.mem x.tgt visitedList) -> loop visitedList rest
      | x::rest -> let path = loop (x.tgt::visitedList) (out_arcs graph x.tgt) in 
        match path with 
          |[] -> loop (x.tgt::visitedList) rest
          |pl -> x::pl
  in
    loop [] ll
;;
