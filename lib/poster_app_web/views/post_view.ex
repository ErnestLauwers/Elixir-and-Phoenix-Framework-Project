defmodule PosterAppWeb.PostView do
  use PosterAppWeb, :view

  def hashtag_input(form, field, opts \\ []) do
    hashtags = Phoenix.HTML.Form.input_value(form, field)
    Phoenix.HTML.Form.text_input(form, field, [value: hashtags_to_text(hashtags)] ++ opts)
  end

  defp hashtags_to_text(hashtags) do
    hashtags
    |> Enum.map(fn h -> h.name end)
    |> Enum.join(", ")
  end
end
