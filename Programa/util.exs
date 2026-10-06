# Integrantes:
# - Jhoan Steven González Upegui - 1092456579
# - Santiago Rico Arango - 1090274268
# - José Federico Rincón Ramos - 1092456434

defmodule Util do
  @moduledoc """
  Módulo de utilidades auxiliares y funciones puras para el Taller de Confecciones.
  Provee parseo seguro de datos numéricos y formateo de montos en moneda local ($).
  """

  @doc """
  Convierte un texto o entero a un resultado estructurado `{:ok, entero}` o `{:error, :entero_invalido}`.
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
  Convierte un texto, entero o flotante a un resultado estructurado `{:ok, flotante}` o `{:error, :flotante_invalido}`.
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
  Formatea un monto numérico como moneda ($): incluye signo de pesos, punto
  como separador de miles y coma para los dos dígitos decimales.
  """
  def formato_moneda(monto) when is_number(monto) do
    centavos = round(abs(monto) * 100)
    signo = if monto < 0 and centavos > 0, do: "-", else: ""
    enteros = div(centavos, 100)
    decimales = centavos |> rem(100) |> Integer.to_string() |> String.pad_leading(2, "0")

    "#{signo}$#{con_separador_de_miles(enteros)},#{decimales}"
  end

  # =========================================================================
  # FUNCIONES PRIVADAS
  # =========================================================================

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
