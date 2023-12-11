open Graph
open Gfile
type coloc =
  { name: string ;
    id: int ;
    value: int }
;;

val read_file: path -> (coloc list * coloc list * int);;