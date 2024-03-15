import gleam/io
import gleam/list
import crack_1
import crack_2

pub fn main() {
  io.debug("cracking 1")
  crack_1.solve()
  |> list.map(crack_1.pin_to_string)
  |> list.map(io.debug)

  io.println("")
  io.debug("cracking 2")
  crack_2.solve()
  |> list.map(crack_2.pin_to_string)
  |> list.map(io.debug)
}
