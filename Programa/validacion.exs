# Integrantes
#- Nombre jhoan steven gonzalez upegui - 1092456579
#- Nombre santiago rico arango - 1090274268
#- Nombre jose federico rincon ramos- 1092456434
defmodule Validacion do
  @doc """
  Filtra y clasifica los lotes en válidos y rechazados.
  Devuelve un mapa %{validos: [...], rechazados: [...]}
  """
  def procesar_lotes(lotes) when is_list(lotes) do
    resultados = Enum.map(lotes, &validar_lote/1)

    validos =
      resultados
      |> Enum.filter(fn
        {:ok, _lote} -> true
        _ -> false
      end)
      |> Enum.map(fn {:ok, lote} -> lote end)

    # Mantiene la tupla {:error, motivo, lote} exacta que exige Reportes.exs
    rechazados =
      Enum.filter(resultados, fn
        {:error, _motivo, _lote} -> true
        _ -> false
      end)

    %{validos: validos, rechazados: rechazados}
  end

  @doc """
  Valida un único lote aplicando el bloque `with` sobre las 5 reglas de negocio.
  """
  def validar_lote(%{confeccionista: conf, linea: lin, dia: d, prendas: p, defectos: defs} = lote) do
    with :ok <- validar_confeccionista(conf),
         :ok <- validar_linea(lin),
         :ok <- validar_dia(d),
         :ok <- validar_prendas(p),
         :ok <- validar_defectos(defs) do
      {:ok, lote}
    else
      {:error, motivo} -> {:error, motivo, lote}
    end
  end

  def validar_lote(lote_invalido) do
    {:error, "Estructura de lote inválida o incompleta", lote_invalido}
  end

  # =========================================================================
  # REGLAS DE NEGOCIO PRIVADAS (defp + guardas + Enum.any?)
  # =========================================================================

  # Regla 1: Confeccionista existente en Datos.confeccionistas()
  defp validar_confeccionista(codigo) when is_binary(codigo) do
    if Enum.any?(Datos.confeccionistas(), fn c -> c.codigo == codigo end) do
      :ok
    else
      {:error, "El confeccionista '#{codigo}' no existe"}
    end
  end

  defp validar_confeccionista(_), do: {:error, "Código de confeccionista no válido"}

  # Regla 2: Línea existente en Datos.lineas()
  defp validar_linea(linea_id) when is_binary(linea_id) do
    if Enum.any?(Datos.lineas(), fn l -> l.id == linea_id end) do
      :ok
    else
      {:error, "La línea de producción '#{linea_id}' no existe"}
    end
  end

  defp validar_linea(_), do: {:error, "ID de línea de producción no válido"}

  # Regla 3: Día en rango de 1 a 6
  defp validar_dia(dia) when is_integer(dia) and dia >= 1 and dia <= 6, do: :ok
  defp validar_dia(dia) when is_integer(dia), do: {:error, "Día '#{dia}' fuera de rango (debe ser de 1 a 6)"}
  defp validar_dia(_), do: {:error, "El día debe ser un número entero"}

  # Regla 4: Prendas mayor a 0
  defp validar_prendas(prendas) when is_integer(prendas) and prendas > 0, do: :ok
  defp validar_prendas(prendas) when is_integer(prendas), do: {:error, "Cantidad de prendas no puede ser <= 0"}
  defp validar_prendas(_), do: {:error, "La cantidad de prendas debe ser un número entero"}

  # Regla 5: Defectos entre 0.0 y 100.0 %
  defp validar_defectos(defectos) when is_number(defectos) and defectos >= 0.0 and defectos <= 100.0, do: :ok
  defp validar_defectos(defectos) when is_number(defectos), do: {:error, "Porcentaje de defectos '#{defectos}%' fuera de rango (0 a 100)"}
  defp validar_defectos(_), do: {:error, "El porcentaje de defectos debe ser numérico"}
end
