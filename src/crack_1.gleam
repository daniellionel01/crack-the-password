import gleam/io
import gleam/int
import gleam/string
import gleam/list
import lib
import gleam/option.{type Option, None, Some}

pub type Pin =
  #(Int, Int, Int)

pub fn pin_to_int(pin: Pin) -> Int {
  pin.0 * 100 + pin.1 * 10 + pin.2
}

pub fn int_to_pin(n: Int) -> Pin {
  let lst =
    n
    |> int.to_string()
    |> string.pad_left(3, "0")
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

  // [6][8][2] one number is correct and well placed
  let r1 = n1 == 6 || n2 == 8 || n3 == 2

  // [6][1][4] one number is correct but wrongly placed
  let r2 =
    { n2 == 6 || n3 == 6 } || { n1 == 1 || n3 == 1 } || { n1 == 4 || n2 == 4 }

  // [2][0][6] two numbers are correct, but wrongly placed
  let r3_1 = n2 == 2 || n3 == 2
  let r3_2 = n1 == 0 || n3 == 0
  let r3_3 = n1 == 6 || n2 == 6
  let r3 = lib.sum_bools([r3_1, r3_2, r3_3]) == 2

  // [7][3][8] nothing is correct
  let r4 = n1 != 7 && n2 != 3 && n3 != 8

  // [7][8][0] one number is correct, but wrongly place
  let r5 =
    { n2 == 7 || n3 == 7 } || { n1 == 8 || n3 == 8 } || { n1 == 0 || n2 == 0 }

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
