import crack_1
import crack_2
import gleam/io
import gleam/list

pub fn main() {
  io.println("cracking 1")
  crack_1.solve()
  |> list.map(crack_1.pin_to_string)
  |> list.map(io.println)

  io.println("")
  io.println("cracking 2")
  crack_2.solve()
  |> list.map(crack_2.pin_to_string)
  |> list.map(io.println)
}
