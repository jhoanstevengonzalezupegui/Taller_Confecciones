# Integrantes:
# - Jhoan Steven González Upegui - 1092456579
# - Santiago Rico Arango - 1090274268
# - José Federico Rincón Ramos - 1092456434

defmodule Liquidacion do
  @moduledoc """
  Módulo encargado del cálculo financiero y la liquidación de nómina de confeccionistas.
  Aplica las tarifas base por prenda, factores de ajuste por porcentaje de defectos,
  bonificaciones por productividad diaria y descuentos por alquiler de maquinaria.
  """

  # Parámetros constantes del negocio
  @tarifa_base 3200
  @minimo_bonificacion 120
  @valor_bonificacion 18000
  @valor_alquiler 15000

  @doc """
  Calcula el valor base bruto de un lote multiplicando la cantidad de prendas
  por la tarifa base ($3.200).
  """
  def valor_base_lote(prendas) when is_integer(prendas) and prendas > 0 do
    prendas * @tarifa_base
  end

  @doc """
  Determina el factor multiplicador de ajuste según el porcentaje de defectos
  registrado en el lote.
  """
  def ajuste_defectos(defectos) when is_number(defectos) do
    cond do
      defectos <= 2.0 -> 1.07
      defectos <= 5.0 -> 1.00
      defectos <= 10.0 -> 0.88
      true -> 0.75
    end
  end

  @doc """
  Calcula el valor económico final ajustado de un lote individual combinando
  su valor base con el factor de ajuste por defectos.
  """
  def valor_lote(lote) when is_map(lote) do
    base = valor_base_lote(lote.prendas)
    factor = ajuste_defectos(lote.defectos)
    base * factor
  end

  @doc """
  Evalúa la producción acumulada de un día y retorna la bonificación ($18.000)
  si alcanza o supera el mínimo requerido (120 prendas).
  """
  def bonificacion_diaria(prendas_dia) when is_integer(prendas_dia) do
    if prendas_dia >= @minimo_bonificacion, do: @valor_bonificacion, else: 0
  end

  @doc """
  Calcula el valor total del descuento por alquiler de maquinaria ($15.000 por
  día trabajado) en caso de que el confeccionista aplique para dicho cobro.
  """
  def descuento_alquiler(dias_trabajados, tiene_alquiler) do
    if tiene_alquiler, do: dias_trabajados * @valor_alquiler, else: 0
  end

  @doc """
  Procesa y consolida la liquidación individual de un confeccionista a partir
  de la lista total de lotes válidos.
  Retorna un mapa con el resumen de prendas, total bruto, bonificaciones,
  descuento de alquiler y neto a pagar.
  """
  def liquidar_confeccionista(confeccionista, lotes_validos) do
    lotes = Enum.filter(lotes_validos, fn l -> l.confeccionista == confeccionista.codigo end)

    # Mapeo y suma idiomática de Elixir
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

  @doc """
  Genera la lista completa de liquidaciones finales iterando sobre la totalidad
  de confeccionistas registrados.
  """
  def liquidar_todos(confeccionistas, lotes_validos) do
    Enum.map(confeccionistas, fn c -> liquidar_confeccionista(c, lotes_validos) end)
  end
end
