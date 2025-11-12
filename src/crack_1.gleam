import gleam/bool
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lib

pub type Pin =
  #(Int, Int, Int)

pub fn pin_to_int(pin: Pin) -> Int {
  pin.0 * 100 + pin.1 * 10 + pin.2
}

pub fn int_to_pin(n: Int) -> Pin {
  let lst =
    n
    |> int.to_string()
    |> string.pad_start(3, "0")
    |> string.split("")
    |> list.map(lib.str_to_int)

  case lst {
    [n1, n2, n3] -> #(n1, n2, n3)
    _ -> panic
  }
}

pub fn pin_to_string(pin: Pin) -> String {
  "["
  <> int.to_string(pin.0)
  <> "]["
  <> int.to_string(pin.1)
  <> "]["
  <> int.to_string(pin.2)
  <> "]"
}

pub fn validate_pin(pin: Pin) -> Bool {
  let #(n1, n2, n3) = pin
  let lst = [n1, n2, n3]

  // [6][8][2] one number is correct and well placed
  let r1 =
    lib.sum_bools([n1 == 6, n2 == 8, n3 == 2]) == 1
    && lib.ensure_n(lst, [6, 8, 2], 1)

  // [6][1][4] one number is correct but wrongly placed
  let r2 =
    lib.sum_bools([
      list.contains([1, 4], n1),
      list.contains([6, 4], n2),
      list.contains([6, 1], n3),
    ])
    == 1
    && lib.ensure_n(lst, [6, 1, 4], 1)

  // [2][0][6] two numbers are correct, but wrongly placed
  let r3_1 = n2 == 2 || n3 == 2
  let r3_2 = n1 == 0 || n3 == 0
  let r3_3 = n1 == 6 || n2 == 6
  let r3 =
    lib.sum_bools([r3_1, r3_2, r3_3]) == 2 && lib.ensure_n(lst, [2, 0, 6], 2)

  // [7][3][8] nothing is correct
  let r4 =
    [7, 3, 8]
    |> list.map(fn(i) { list.contains([n1, n2, n3], i) })
    |> list.contains(True)
    |> bool.negate()

  // [7][8][0] one number is correct, but wrongly place
  let r5 =
    lib.sum_bools([
      list.contains([8, 0], n1),
      list.contains([7, 0], n2),
      list.contains([7, 8], n3),
    ])
    == 1
    && lib.ensure_n(lst, [7, 8, 0], 1)

  r1 && r2 && r3 && r4 && r5
}

pub fn next_pin(pin: Pin) -> Option(Pin) {
  case pin {
    #(9, 9, 9) -> None
    _ -> {
      pin
      |> pin_to_int
      |> int.add(1)
      |> int_to_pin
      |> Some
    }
  }
}

pub fn solve() {
  solve_loop(#(0, 0, 0), [])
}

fn solve_loop(pin: Pin, acc: List(Pin)) {
  let sols = case validate_pin(pin) {
    True -> list.append(acc, [pin])
    False -> acc
  }
  case next_pin(pin) {
    None -> sols
    Some(value) -> solve_loop(value, sols)
  }
}
