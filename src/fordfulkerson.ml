open Graph

(*
arc(src,tgt)   :- ....
path(orig, dest) :-
*)

let flow_graph gr = Tools.gmap gr (fun x -> "0/"^x);;

let max_flow ll =
  let rec loop ll max = 
    match ll with
      | [] -> max
      | x::rest -> 
          let stl = String.split_on_char '/' x.lbl in
          let new_max = ((int_of_string (List.nth stl 1)) - (int_of_string (List.hd stl))) in if max > new_max then loop rest new_max else loop rest max
  in
  match ll with
    | [] -> 0
    | x::rest -> let stl = String.split_on_char '/' x.lbl in
      loop rest ((int_of_string (List.nth stl 1)) - (int_of_string (List.hd stl)))
;;

let find_path graph startNode endNode = 
  let ll = out_arcs graph startNode in
  let rec loop visitedList qList = 
    match qList with
      | [] -> []
      | x::_ when (x.tgt = endNode) -> [x]
      | x::rest when (List.mem x.tgt visitedList) -> loop visitedList rest
      | x::rest when (max_flow [x] = 0) -> loop visitedList rest
      | x::rest -> let path = loop (x.tgt::visitedList) (out_arcs graph x.tgt) in 
        match path with 
          |[] -> loop (x.tgt::visitedList) rest
          |pl -> x::pl
  in
    loop [] ll
;;

let update_flow gr ll flow =
  let rec loop ll gr =
    match ll with
      | [] -> gr
      | x::rest -> 
        match (find_arc gr x.src x.tgt) with
        | None -> loop rest gr
        | Some a -> let stl = String.split_on_char '/' a.lbl in
            loop rest (Tools.add_arc gr a.src a.tgt (String.concat "/" ((string_of_int ((int_of_string (List.hd stl)) + flow))::(List.nth stl 1)::[])))
  in
    loop ll gr
;;