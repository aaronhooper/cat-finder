defmodule CatFinder.Generate do


  @doc """
  Generates `n` files in the current directory containing between `low` and
  `high` number of words. Between 0 and 10 percent of these words in each file
  will be 'cat'.
  """
  def files(n, low, high) do
    for file_number <- 1..n do
      filename = "./#{file_number}.txt"
      File.touch!(filename)
      file = File.open!(filename, [:write])

      total_number_of_words = low + :rand.uniform(high - low + 1) - 1
      number_of_cats = :rand.uniform(div(total_number_of_words, 10) + 1) - 1
      number_of_other_words = total_number_of_words - number_of_cats

      other_words = for _ <- 1..number_of_other_words, do: random_word()
      cats = for _ <- 1..number_of_cats, do: "cat"

      contents =
        (other_words ++ cats)
        |> Enum.shuffle()
        |> Enum.join("\s")

      IO.write(file, contents)
      File.close(file)
    end
  end


  @doc """
  Returns a random word, i.e. a sequence of characters between 1 and 15
  characters long.
  """
  def random_word() do
    for(_ <- 1..:rand.uniform(15), do: Enum.random(?a..?z))
    |> to_string()
  end
end
