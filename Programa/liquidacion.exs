# Integrantes
#- Nombre jhoan steven gonzalez upegui - 1092456579
#- Nombre santiago rico arango - 1090274268
#- Nombre jose federico rincon ramos-1092456434


defmodule Liquidacion do

  # Parámetros Constantes del negocio
  @tarifa_base 3200
  @minimo_bonificacion 120
  @valor_bonificacion 18000
  @valor_alquiler 15000

  # 1. Valor base de un lote ($3.200 por prenda)
  def valor_base_lote(prendas) when is_integer(prendas) and prendas > 0 do
    prendas * @tarifa_base
  end

  # 2. Factor de ajuste según el % de defectos
  def ajuste_defectos(defectos) when is_number(defectos) do
    cond do
      defectos <= 2.0 -> 1.07
      defectos <= 5.0 -> 1.00
      defectos <= 10.0 -> 0.88
      true -> 0.75
    end
  end

  # 3. Valor económico final ajustado de un lote
  def valor_lote(lote) when is_map(lote) do
    base = valor_base_lote(lote.prendas)
    factor = ajuste_defectos(lote.defectos)
    base * factor
  end

  # 4. Bonificación diaria por productividad (>= 120 prendas)
  def bonificacion_diaria(prendas_dia) when is_integer(prendas_dia) do
    if prendas_dia >= @minimo_bonificacion, do: @valor_bonificacion, else: 0
  end

  # 5. Descuento por alquiler de maquinaria ($15.000 por día trabajado)
  def descuento_alquiler(dias_trabajados, tiene_alquiler) do
    if tiene_alquiler, do: dias_trabajados * @valor_alquiler, else: 0
  end

  # 6. Liquidar un confeccionista individual
  def liquidar_confeccionista(confeccionista, lotes_validos) do
    lotes = Enum.filter(lotes_validos, fn l -> l.confeccionista == confeccionista.codigo end)

    # Mapeo + Suma idiomático de Elixir
    total_prendas = lotes |> Enum.map(fn l -> l.prendas end) |> Enum.sum()
    bruto = lotes |> Enum.map(&valor_lote/1) |> Enum.sum()

    lotes_por_dia = Enum.group_by(lotes, fn l -> l.dia end)
    dias_trabajados = map_size(lotes_por_dia)

    bonificacion =
      lotes_por_dia
      |> Enum.map(fn {_dia, lotes_dia} ->
        prendas_dia = lotes_dia |> Enum.map(fn l -> l.prendas end) |> Enum.sum()
        bonificacion_diaria(prendas_dia)
      end)
      |> Enum.sum()

    alquiler = descuento_alquiler(dias_trabajados, confeccionista.alquiler)
    neto = bruto + bonificacion - alquiler

    %{
      codigo: confeccionista.codigo,
      nombre: confeccionista.nombre,
      alquiler: confeccionista.alquiler,
      prendas: total_prendas,
      bruto: bruto,
      bonificacion: bonificacion,
      alquiler_descuento: alquiler,
      dias_trabajados: dias_trabajados,
      neto: neto
    }
  end

  # 7. Liquidar a todos los confeccionistas registrados
  def liquidar_todos(confeccionistas, lotes_validos) do
    Enum.map(confeccionistas, fn c -> liquidar_confeccionista(c, lotes_validos) end)
  end
end
