# Integrantes
#- Nombre jhoan steven gonzalez upegui - 1092456579
#- Nombre santiago rico arango - 1090274268
#- Nombre jose federico rincon ramos- FEDE PONGA SU CEDULA AQUI


defmodule Util do

    #FUCIONES PURAS
  @doc """
  Convierte un texto o entero a un número entero de forma segura.
  Ejemplo: "120\n" -> 120
  """
  def parse_entero(texto) when is_binary(texto) do
    case Integer.parse(String.trim(texto)) do
      {num, ""} -> num
      _ -> {:error, "Número entero no válido"}
    end
  end

  def parse_entero(numero) when is_integer(numero), do: numero

  @doc """
  Convierte un texto, entero o flotante a un número flotante de forma segura.
  Ejemplo: "2.5" -> 2.5
  """
  def parse_flotante(texto) when is_binary(texto) do
    case Float.parse(String.trim(texto)) do
      {num, ""} -> num
      _ -> {:error, "Número flotante no válido"}
    end
  end

  def parse_flotante(numero) when is_number(numero), do: numero / 1

  @doc """
  Formatea un monto numérico como moneda con signo pesos y separadores de miles.
  Ejemplo: 1250000 -> "$1.250.000"
  """
 def formato_moneda(monto) when is_number(monto) do
  monto
  |> round()
  |> Integer.to_string()
  |> String.reverse()
  |> String.chunk_every(3)
  |> Enum.join(".")
  |> String.reverse()
  |> then(&"$#{&1}")


  def formato_moneda(_monto_invalido) do
  {:error, "El monto debe ser un valor numérico"}
end

end

  # =========================================================================
  # FUNCIONES DE LECTURA E IMPRESIÓN EN CONSOLA (I/O)
  #FUNCIONES IMPURAS


  def mostrar_mensaje(mensaje) do
    IO.puts(mensaje)
  end

  def mostrar_error(mensaje) do
    IO.puts(:standard_error, " #{mensaje}")
  end

  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end

  def ingresar(mensaje, :entero) do
    ingresar(mensaje, &String.to_integer/1, :entero)
  end

  def ingresar(mensaje, :real) do
    ingresar(mensaje, &String.to_float/1, :real)
  end

  def ingresar(mensaje, parser, tipo_dato) do
    try do
      mensaje
      |> ingresar(:texto)
      |> parser.()
    rescue
      ArgumentError ->
        mostrar_error("Error, se esperaba un número #{tipo_dato}.\n")
        ingresar(mensaje, parser, tipo_dato)
    end
  end
end
