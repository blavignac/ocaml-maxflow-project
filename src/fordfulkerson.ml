open Graph

(*
arc(src,tgt)   :- ....
path(orig, dest) :-
*)

let flow_graph gr = Tools.gmap gr (fun x -> "0/"^x);;

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

let max_flow gr ll =
  let rec loop ll max = 
    match ll with
      | [] -> max
      | _::[] -> max
      | x::rest -> 
        let y = (List.hd rest) in
          match (find_arc gr x y) with
            | None -> loop rest 0
            | Some a -> 
              let new_max = ((int_of_char a.lbl.[3]) - (int_of_char a.lbl.[0])) in if max > new_max then loop rest new_max else loop rest max
  in
    loop ll 0
;;

let update_flow gr ll flow =
  let rec loop ll gr =
    match ll with
      | [] -> gr
      | _::[] -> gr
      | x::rest -> 
        let y = (List.hd rest) in
          match (find_arc gr x y) with
          | None -> loop rest gr
          | Some a -> loop rest (Tools.add_arc gr a.src a.tgt ((string_of_int ((int_of_char a.lbl.[0]) + flow)^String.sub a.lbl 1 2)))
  in
    loop ll gr
;;