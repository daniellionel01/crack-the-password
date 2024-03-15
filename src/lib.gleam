import gleam/int
import gleam/bool
import gleam/list

pub fn str_to_int(v: String) -> Int {
  let assert Ok(result) = int.base_parse(v, 10)
  result
}

pub fn sum_bools(bools: List(Bool)) -> Int {
  bools
  |> list.map(bool.to_int)
  |> list.fold(0, int.add)
}
