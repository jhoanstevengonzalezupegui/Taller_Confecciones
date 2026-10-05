# Integrantes
#- Nombre jhoan steven gonzalez upegui - 1092456579
#- Nombre santiago rico arango - 1090274268
#- Nombre jose federico rincon ramos- 1092456434


defmodule Util do


  #Funciones Puras
  @doc """
  Convierte un texto o un entero a entero de forma segura.
  ## Ejemplos

      iex> Util.parse_entero("120\\n")
      {:ok, 120}
      iex> Util.parse_entero("12abc")
      {:error, :entero_invalido}
  """
  def parse_entero(texto) when is_binary(texto) do
    case Integer.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :entero_invalido}
    end
  end

  def parse_entero(numero) when is_integer(numero), do: {:ok, numero}
  def parse_entero(_otro), do: {:error, :entero_invalido}

  @doc """
  Convierte un texto, entero o flotante a flotante de forma segura.

  ## Ejemplos

      iex> Util.parse_flotante("2.5")
      {:ok, 2.5}
      iex> Util.parse_flotante("7")
      {:ok, 7.0}
      iex> Util.parse_flotante("abc")
      {:error, :flotante_invalido}
  """
  def parse_flotante(texto) when is_binary(texto) do
    case Float.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :flotante_invalido}
    end
  end

  def parse_flotante(numero) when is_number(numero), do: {:ok, numero / 1}
  def parse_flotante(_otro), do: {:error, :flotante_invalido}

  @doc """
  Formatea un monto como moneda: signo pesos, puntos de miles y coma decimal,
  siempre con dos decimales y sin notación científica.

  ## Ejemplos

      iex> Util.formato_moneda(1250000)
      "$1.250.000,00"
      iex> Util.formato_moneda(239680.0)
      "$239.680,00"
      iex> Util.formato_moneda(-500)
      "-$500,00"
  """
  def formato_moneda(monto) when is_number(monto) do
    centavos = round(abs(monto) * 100)
    signo = if monto < 0 and centavos > 0, do: "-", else: ""
    enteros = div(centavos, 100)
    decimales = centavos |> rem(100) |> Integer.to_string() |> String.pad_leading(2, "0")

    "#{signo}$#{con_separador_de_miles(enteros)},#{decimales}"
  end

  defp con_separador_de_miles(entero) do
    entero
    |> Integer.to_string()
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.map(fn grupo -> grupo |> Enum.reverse() |> Enum.join() end)
    |> Enum.reverse()
    |> Enum.join(".")
  end
end
