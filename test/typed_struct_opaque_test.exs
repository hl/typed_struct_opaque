defmodule TypedStructOpaqueTest do
  use ExUnit.Case

  test "name function exists" do
    name = "test"
    struct = Game.Default.new()

    assert updated_struct = Game.Default.name(struct, name)
    assert match?(^name, Game.Default.name(updated_struct))
  end

  test "get_name/set_name function exists" do
    name = "test"
    struct = Game.WithPrefixes.new()

    assert updated_struct = Game.WithPrefixes.set_name(struct, name)
    assert match?(^name, Game.WithPrefixes.get_name(updated_struct))
  end
end
