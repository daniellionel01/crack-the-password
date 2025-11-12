import gleam/int
import gleam/list
import gleam/set

pub fn str_to_int(v: String) -> Int {
  let assert Ok(result) = int.base_parse(v, 10)
  result
}

pub fn sum_bools(bools: List(Bool)) -> Int {
  bools
  |> list.map(fn(b) {
    case b {
      True -> 1
      False -> 0
    }
  })
  |> list.fold(0, int.add)
}

pub fn ensure_unique(lst: List(a)) {
  let length = list.length(lst)
  let unique =
    lst
    |> set.from_list
    |> set.to_list
    |> list.length
  length == unique
}

pub fn ensure_n(lst: List(a), options: List(a), n: Int) {
  let contained =
    lst
    |> list.map(list.contains(options, _))
    |> list.filter(fn(x) { x == True })
    |> list.length
  contained == n
}
