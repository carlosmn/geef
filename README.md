Geef (Git NIF)
================

Geef is a simple Erlang NIF that exposes some of the libgit2 library functions
to Erlang.

INSTALLING AND RUNNING
========================

First you need to install libgit2, which requires [CMake](https://cmake.org/):

    $ git clone git://github.com/libgit2/libgit2.git
    $ cd libgit2
    $ mkdir build && cd build
    $ cmake ..
    $ cmake --build

Now, if you have Erlang OTP_R13B04 installed, you can compile this NIF to run
in it.

    $ git clone git://github.com/carlosmn/geef.git
    $ cd geef
    $ make
    $ mix # if you want to build the elixir modules

The API looks basically like this:

```erlang
{ok, Repo} = geef_repo:open(".").
Workdir = geef_repo:workdir(Repo).
{ok, Blob} = geef_blob:lookup(Repo, geef_oid:parse("abcde...")).
```

Elixir
======

Most functions are available from the elixir modules so you can make use of some elixir-specific
things, like `Repository.open!`, or `Reference.resolve!`.

```elixir
alias Geef.Repository
alias Geef.Reference
repo = Repository.open!(".")
ref = Reference.lookup!(repo, "HEAD") |> Reference.resolve!
```

references, objects, etc are elixir records. Trees implement the Access protocol

```elixir
%Reference{name: name} = Reference.lookup!(repo, "refs/heads/master")
IO.puts name
{:ok, tree} = Tree.lookup(repo, "abcde...")
IO.inspect tree["src/geef_pkt.erl"]
```

CONTRIBUTING
==============

Fork carlosmn/geef on GitHub, make it awesomer (preferably in a branch named
for the topic), send a pull request.


AUTHORS 
==============

* Carlos Martín Nieto <cmn@dwim.me>
* Scott Chacon <schacon@gmail.com>


LICENSE
==============

MIT.
