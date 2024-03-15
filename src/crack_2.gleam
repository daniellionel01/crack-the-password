import gleam/int
import gleam/string
import gleam/list
import gleam/bool
import gleam/set
import lib
import gleam/option.{type Option, None, Some}

pub type Pin =
  #(Int, Int, Int, Int)

pub fn pin_to_int(pin: Pin) -> Int {
  pin.0 * 1000 + pin.1 * 100 + pin.2 * 10 + pin.3
}

pub fn int_to_pin(n: Int) -> Pin {
  let lst =
    n
    |> int.to_string()
    |> string.pad_left(4, "0")
    |> string.split("")
    |> list.map(lib.str_to_int)

  case lst {
    [n1, n2, n3, n4] -> #(n1, n2, n3, n4)
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
  <> "]["
  <> int.to_string(pin.3)
  <> "]"
}

fn ensure_unique(lst: List(a)) {
  let length = list.length(lst)
  let unique =
    lst
    |> set.from_list
    |> set.to_list
    |> list.length
  length == unique
}

pub fn validate_pin(pin: Pin) -> Bool {
  let #(n1, n2, n3, n4) = pin

  // [9][2][8][5] one number is correct but wrong placed
  let r1_1 = list.contains([2, 8, 5], n1)
  let r1_2 = list.contains([9, 8, 5], n2)
  let r1_3 = list.contains([9, 2, 5], n3)
  let r1_4 = list.contains([9, 2, 8], n4)
  let r1 = lib.sum_bools([r1_1, r1_2, r1_3, r1_4]) == 1

  // [1][9][3][7] two numbers are correct but wrong placed
  let r2_1 = list.contains([9, 3, 7], n1)
  let r2_2 = list.contains([1, 3, 7], n2)
  let r2_3 = list.contains([1, 9, 7], n3)
  let r2_4 = list.contains([1, 9, 3], n4)
  let r2 = lib.sum_bools([r2_1, r2_2, r2_3, r2_4]) == 2

  // [5][2][0][1] one number is right and well placed
  let r3 = lib.sum_bools([n1 == 5, n2 == 2, n3 == 0, n4 == 1]) == 1

  // [6][5][0][7] nothing is correct
  let r4 =
    [6, 5, 0, 7]
    |> list.map(fn(i) { list.contains([n1, n2, n3, n4], i) })
    |> list.contains(True)
    |> bool.negate()

  // [8][5][2][4] two numbers are correct but wrong placed
  let r5_1 = list.contains([5, 2, 4], n1)
  let r5_2 = list.contains([8, 2, 4], n2)
  let r5_3 = list.contains([8, 5, 4], n3)
  let r5_4 = list.contains([8, 5, 2], n4)
  let r5 = lib.sum_bools([r5_1, r5_2, r5_3, r5_4]) == 2

  r1 && r2 && r3 && r4 && r5 && ensure_unique([n1, n2, n3, n4])
}

pub fn next_pin(pin: Pin) -> Option(Pin) {
  case pin {
    #(9, 9, 9, 9) -> None
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
  solve_loop(#(0, 0, 0, 0), [])
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
