defmodule Mix.Tasks.Compile.Nif do
  @moduledoc """
  A task to compile C code into a NIF.

  To use, define a function in your project called `nif`.

  ## Configuration

  * `:paths` - directories to find source files. Defaults to
    `["c_src"]`. Can be configured as:

    ````
    [ptahs: ["c_src", "vendor/src"]]
    ````

  * `:exts` - extensions of the source files. Defaults to `[:c]`, can
    be configured as:

    ```
    [exts: [:c, :cpp]]
    ```

  * `:file` - path of the shared object to compile to. Can be configured as:

    ````
    [file: "priv/fancy.so"]
    ````

  * `:flags` - flags to pass to the compiler. Can be configured as:

     ````
     [flags: ["-lfancy", "-DDEBUG"]]
     ````

  """

  def run(_) do
    project = Mix.Project.get!

    Mix.shell.info("* Running make...")
    Mix.shell.info(:os.cmd('make'))

    if function_exported?(project, :nif, 0) do
      do_run(project.nif)
    else
      :noop
    end
  end

  def do_run(config) do
    file = Keyword.fetch!(config, :file)
    paths = Keyword.get(config, :paths, ["c_src"])
    flags = Keyword.get(config, :flags, [])
    exts = Keyword.get(config, :exts, [:c])
    compiler = Keyword.get(config, :compilers, ["cc", "gcc", "clang"]) |> find_compiler

    if cflags = System.get_env("CFLAGS") do
      # FIXME: this isn't going to work too well with quoted spaces
      # inside arguments
      flags = [flags, String.split(cflags)]
    end

    # Create the directory (e.g. "priv/")
    File.mkdir_p!(Path.dirname(file))

    # Figure out whether we should compile the NIF. Compare the source
    # files and header timestamps with the target binary. If the
    # target is older than any source file, recompile.
    to_compile = Mix.Utils.extract_files(paths, exts)
    to_check = Mix.Utils.extract_files(paths, [:h | exts])

    case Mix.Utils.extract_stale(to_check, [file]) do
      [] ->
        :noop
      _ ->
        Mix.shell.info("* Compiling #{file}")
        args = ["-shared", "-fpic", "-o", file, to_compile, flags] |> List.flatten
        port = Port.open({:spawn_executable, compiler},
                         [:stream, :binary, :use_stdio, :stderr_to_stdout, :hide,
                          :exit_status, {:args, args}])
        if do_cmd(port) != 0 do
          raise Mix.Error, message: "Error compiling #{file}"
        end
        :ok
    end
  end

  defp find_compiler([compiler | tail]) do
    case System.find_executable(compiler) do
      nil ->
        find_compiler(tail)
      path ->
        path
    end
  end

  defp do_cmd(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        do_cmd(port)
      {^port, {:exit_status, status}} ->
        status
    end
  end

end

defmodule Geef.Mixfile do
  use Mix.Project

  def project do
    [ app: :geef,
      version: "0.0.1",
      compilers: [:nif, :erlang, :elixir, :app],
      deps: deps,
      dialyzer: dialyzer ]
  end

  def nif do
    [ file: "priv/geef.so",
      flags: "-lgit2" ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end

  def dialyzer do
    [ plt_apps: [:erts, :kernel, :stdlib, :mnesia],
      flags: ["-Wunmatched_returns","-Werror_handling","-Wrace_conditions", "-Wno_opaque"]]
  end

end
