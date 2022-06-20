defmodule CatFinder do
  def count_cats(filename, sender) do
    result =
      filename
      |> File.read!()
      |> String.split("\s")
      |> Enum.count(&(&1 == "cat"))

    send(sender, {filename, result})
  end

  def count_cats_sync(filename) do
    result =
      filename
      |> File.read!()
      |> String.split("\s")
      |> Enum.count(&(&1 == "cat"))

    {filename, result}
  end

  def run_sync(filenames) do
    filenames
    |> Enum.map(fn filename -> count_cats_sync(filename) end)
  end

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
