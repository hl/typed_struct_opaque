defmodule TypedStructOpaque do
  use TypedStruct.Plugin

  @impl true
  @spec init(keyword()) :: Macro.t()
  defmacro init(opts) do
    quote do
      @prefixes unquote(opts)[:prefixes]
    end
  end

  @impl true
  @spec field(atom(), any(), keyword(), Macro.Env.t()) :: Macro.t()
  def field(name, type, opts, _env) do
    {get_function_name, set_function_name} =
      case Keyword.get(opts, :prefixes) do
        nil ->
          {name, name}

        prefixes ->
          {:"#{Keyword.fetch!(prefixes, :get)}#{name}",
           :"#{Keyword.fetch!(prefixes, :set)}#{name}"}
      end

    quote do
      @spec unquote(get_function_name)(t()) :: unquote(type)
      def unquote(get_function_name)(%__MODULE__{} = struct),
        do: Map.fetch!(struct, unquote(name))

      defoverridable [{unquote(get_function_name), 1}]

      @spec unquote(set_function_name)(t(), unquote(type)) :: t()
      def unquote(set_function_name)(%__MODULE__{} = struct, value),
        do: Map.put(struct, unquote(name), value)

      defoverridable [{unquote(set_function_name), 2}]
    end
  end

  @impl true
  @spec after_definition(opts :: keyword()) :: Macro.t()
  def after_definition(_opts) do
    quote do
      Module.delete_attribute(__MODULE__, :prefixes)

      def new(attrs \\ []), do: struct(__MODULE__, attrs)
    end
  end
end
