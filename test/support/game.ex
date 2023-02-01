defmodule Game do
  use TypedStruct

  typedstruct module: Default, opaque: true do
    plugin TypedStructOpaque

    field :name, String.t()
  end

  typedstruct module: WithPrefixes, opaque: true do
    plugin TypedStructOpaque, prefixes: [get: "get_", set: "set_"]

    field :name, String.t()
  end
end
