defmodule CatFinder do


  @doc """
  Returns a message to the sender containing a tuple with the given filename
  and the number of times 'cat' appears in the given file.
  """
  def count_cats(filename, sender) do
    result =
      filename
      |> File.read!()
      |> String.split("\s")
      |> Enum.count(&(&1 == "cat"))

    send(sender, {filename, result})
  end


  @doc """
  Returns a tuple with the given filename and the number of times 'cat' appears
  in the given file.
  """
  def count_cats_sync(filename) do
    result =
      filename
      |> File.read!()
      |> String.split("\s")
      |> Enum.count(&(&1 == "cat"))

    {filename, result}
  end


  @doc """
  Accepts a parameter containing a list of file paths and returns a list of
  tuples each containing the filename and the number of times 'cat' appears in
  the file. Uses a single process thread to calculate the result.
  """
  def run_sync(filenames) do
    filenames
    |> Enum.map(fn filename -> count_cats_sync(filename) end)
  end


  @doc """
  Accepts a parameter containing a list of file paths and returns a list of
  tuples each containing the filename and the number of times 'cat' appears in
  the file.

  The files returned may not be in the same order as they were given in. One
  process thread per file is used to calculate the result.
  """
  def run(filenames) do
    filenames
    |> Enum.map(fn filename ->
      spawn(CatFinder, :count_cats, [filename, self()])
    end)
    |> Enum.map(fn _pid ->
      receive do
        message -> message
      end
    end)
  end
end
