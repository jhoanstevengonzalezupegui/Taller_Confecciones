# Integrantes
#- Nombre jhoan steven gonzalez upegui - 1092456579
#- Nombre santiago rico arango - 1090274268
#- Nombre jose federico rincon ramos- 1092456434


defmodule Reportes do

  # Constante para la meta diaria del Reporte 3
  @meta_diaria 600

  # 1. RANKING Y ORDENAMIENTO DE LIQUIDACIONES (INVESTIGACIÓN C.1)

  def ranking(liquidaciones, opts \\ []) do
    campo = Keyword.get(opts, :campo, :neto)
    orden = Keyword.get(opts, :orden, :desc)
    limite = Keyword.get(opts, :limite, nil)

    campo_valido = if campo in [:neto, :prendas, :bruto], do: campo, else: :neto

    liquidaciones_ordenadas =
      Enum.sort_by(
        liquidaciones,
        fn liq -> Map.get(liq, campo_valido, 0) end,
        fn val1, val2 ->
          if orden == :asc do
            val1 <= val2
          else
            val1 >= val2
          end
        end
      )

    if is_integer(limite) and limite > 0 do
      Enum.take(liquidaciones_ordenadas, limite)
    else
      liquidaciones_ordenadas
    end
  end

  # 2. REPORTE DE LOTES RECHAZADOS Y MOTIVOS DE FALLA

  def generar_reporte_lotes_rechazados(rechazados) do
    if Enum.empty?(rechazados) do
      """
      === REPORTE DE LOTES RECHAZADOS Y MOTIVOS DE FALLA ===
      No se registraron lotes rechazados durante la semana.
      """
    else
      # Detalle uno por uno
      lista_detalles = Enum.map(rechazados, fn {:error, motivo, lote} ->
        "• Día #{lote.dia} | Confeccionista: #{lote.confeccionista} | Línea: #{lote.linea} -> Motivo: #{motivo}"
      end)
      detalles_texto = Enum.join(lista_detalles, "\n")

      # Conteo por cada motivo
      mapa_conteos = Enum.frequencies_by(rechazados, fn {:error, motivo, _lote} -> motivo end)

      lista_conteos = Enum.map(mapa_conteos, fn {motivo, cantidad} ->
        "• #{motivo}: #{cantidad} lote(s)"
      end)
      conteos_texto = Enum.join(lista_conteos, "\n")

      """
      === REPORTE DE LOTES RECHAZADOS Y MOTIVOS DE FALLA ===
      --- Detalle de Lotes Rechazados ---
      #{detalles_texto}

      --- Conteo por Motivo de Rechazo ---
      #{conteos_texto}
      """
    end
  end


  # 3. REPORTE DE PRODUCCIÓN Y PRODUCTIVIDAD POR LÍNEA

  def generar_reporte_productividad_lineas(lineas, lotes_validos) do
    # Calcular prendas y productividad de cada línea
    datos_lineas = Enum.map(lineas, fn linea ->
      lotes_linea = Enum.filter(lotes_validos, fn lote -> lote.linea == linea.id end)
      lista_prendas = Enum.map(lotes_linea, fn lote -> lote.prendas end)
      total_prendas = Enum.sum(lista_prendas)

      puestos = Map.get(linea, :puestos, 1)

      productividad =
        if puestos > 0 do
          total_prendas / puestos
        else
          0.0
        end

      %{
        id: linea.id,
        nombre: linea.nombre,
        puestos: puestos,
        prendas: total_prendas,
        productividad: productividad
      }
    end)

    # Ordenar por productividad de mayor a menor
    lineas_ordenadas = Enum.sort_by(datos_lineas, fn item -> item.productividad end, :desc)

    filas = Enum.map(lineas_ordenadas, fn item ->
      prod_fmt = :erlang.float_to_binary(item.productividad * 1.0, [decimals: 2])
      "• Línea #{item.id} (#{item.nombre}): #{item.prendas} prendas | #{item.puestos} puestos | Productividad: #{prod_fmt} prendas/puesto"
    end)
    filas_texto = Enum.join(filas, "\n")

    """
    === REPORTE DE PRODUCCIÓN Y PRODUCTIVIDAD POR LÍNEA ===
    #{filas_texto}
    """
  end


  # 4. REPORTE DE PRODUCCIÓN DIARIA Y CUMPLIMIENTO DE META

  def generar_reporte_cumplimiento_meta(lotes_validos) do
    meta_diaria = 600

    datos_dias = Enum.map(1..6, fn dia ->
      lotes_dia = Enum.filter(lotes_validos, fn lote -> lote.dia == dia end)
      lista_prendas = Enum.map(lotes_dia, fn lote -> lote.prendas end)
      total_prendas = Enum.sum(lista_prendas)

      cumplio = total_prendas >= meta_diaria
      {dia, total_prendas, cumplio}
    end)

    lista_filas = Enum.map(datos_dias, fn {dia, prendas, cumplio} ->
      estado = if cumplio, do: "CUMPLIÓ META", else: "NO CUMPLIÓ META"
      "• Día #{dia}: #{prendas} prendas -> #{estado}"
    end)
    filas_texto = Enum.join(lista_filas, "\n")

    cumplio_todos = Enum.all?(datos_dias, fn {_dia, _prendas, cumplio} -> cumplio end)
    cumplio_alguno = Enum.any?(datos_dias, fn {_dia, _prendas, cumplio} -> cumplio end)

    texto_todos = if cumplio_todos, do: "SÍ", else: "NO"
    texto_alguno = if cumplio_alguno, do: "SÍ", else: "NO"

    """
    === REPORTE DE PRODUCCIÓN DIARIA Y CUMPLIMIENTO DE META (600 PRENDAS) ===
    #{filas_texto}
    --------------------------------------------------
    ¿Alcanzó la meta todos los días?: #{texto_todos}
    ¿Alcanzó la meta al menos un día?: #{texto_alguno}
    """
  end

  # 5. REPORTE DE LIQUIDACIÓN SEMANAL DE CONFECCIONISTAS

  def generar_reporte_liquidacion_semanal(liquidaciones) do
    liquidaciones_ordenadas = ranking(liquidaciones, campo: :neto, orden: :desc)

    lista_con_posicion = Enum.with_index(liquidaciones_ordenadas, 1)

    filas = Enum.map(lista_con_posicion, fn {liq, posicion} ->
      bruto_str = Util.formato_moneda(liq.bruto)
      bonif_str = Util.formato_moneda(liq.bonificacion)
      alq_str = Util.formato_moneda(liq.alquiler_descuento)
      neto_str = Util.formato_moneda(liq.neto)

      "#{posicion}. [#{liq.codigo}] #{liq.nombre}\n   Prendas: #{liq.prendas} | Valor Lotes: #{bruto_str} | Bonificación: #{bonif_str} | Alquiler: -#{alq_str} | NETO: #{neto_str}"
    end)
    filas_texto = Enum.join(filas, "\n")

    """
    === REPORTE DE LIQUIDACIÓN SEMANAL DE CONFECCIONISTAS ===
    #{filas_texto}
    """
  end

   # 6. REPORTE DE MAYOR PRODUCTOR DIARIO (R5)
  

  def generar_reporte_lideres_diarios(confeccionistas, lotes_validos) do
    filas = Enum.map(1..6, fn dia ->
      lotes_dia = Enum.filter(lotes_validos, fn l -> l.dia == dia end)
      if Enum.empty?(lotes_dia) do
        "• Día #{dia}: Sin lotes válidos."
      else
        por_conf = Enum.group_by(lotes_dia, fn l -> l.confeccionista end)
        totales = Enum.map(por_conf, fn {cod, lotes} ->
          conf = Enum.find(confeccionistas, fn c -> c.codigo == cod end)
          {conf.nombre, Enum.sum(Enum.map(lotes, fn l -> l.prendas end))}
        end)
        max_prendas = elem(Enum.max_by(totales, fn {_nom, p} -> p end), 1)
        ganadores = Enum.filter(totales, fn {_nom, p} -> p == max_prendas end)
        nombres = Enum.map_join(ganadores, ", ", fn {nom, _p} -> nom end)
        "• Día #{dia}: #{nombres} (#{max_prendas} prendas)"
      end
    end)

    """
    === REPORTE DE MAYOR PRODUCTOR DIARIO ===
    #{Enum.join(filas, "\n")}
    """
  end

  
  # 7. REPORTE DE MEJOR CALIDAD PONDERADA (R6)
  

  def generar_reporte_mejor_calidad(confeccionistas, lotes_validos) do
    candidatos = Enum.filter(confeccionistas, fn c ->
      length(Enum.filter(lotes_validos, fn l -> l.confeccionista == c.codigo end)) >= 3
    end)

    if Enum.empty?(candidatos) do
      """
      === REPORTE DE MEJOR CALIDAD (PORCENTAJE PONDERADO) ===
      Ningún confeccionista cumple con el mínimo de 3 lotes válidos.
      """
    else
      evaluacion = Enum.map(candidatos, fn c ->
        lotes = Enum.filter(lotes_validos, fn l -> l.confeccionista == c.codigo end)
        total_prendas = Enum.sum(Enum.map(lotes, fn l -> l.prendas end))
        suma_defectos = Enum.sum(Enum.map(lotes, fn l -> l.defectos * l.prendas end))
        ponderado = suma_defectos / total_prendas
        {c, ponderado}
      end)

      {mejor, porcentaje} = Enum.min_by(evaluacion, fn {_c, pond} -> pond end)
      fmt = :erlang.float_to_binary(porcentaje, [decimals: 2])

      """
      === REPORTE DE MEJOR CALIDAD (PORCENTAJE PONDERADO) ===
      • Confeccionista con mejor calidad: [#{mejor.codigo}] #{mejor.nombre}
      • Porcentaje ponderado de defectos: #{fmt}%
      """
    end
  end


  # 8. REPORTE DE TOTALES GLOBALES Y COSTO PROMEDIO (R7)


  def generar_reporte_totales_y_costo_promedio(liquidaciones, lotes_validos) do
    total_pagado = Enum.sum(Enum.map(liquidaciones, fn l -> l.neto end))
    total_prendas = Enum.sum(Enum.map(lotes_validos, fn l -> l.prendas end))

    promedio_str =
      if total_prendas > 0 do
        Util.formato_moneda(total_pagado / total_prendas)
      else
        "No se puede calcular (0 prendas válidas)"
      end

    """
    === REPORTE DE TOTALES GLOBALES Y COSTO PROMEDIO ===
    • Total acumulado a pagar por el taller: #{Util.formato_moneda(total_pagado)}
    • Total de prendas válidas elaboradas: #{total_prendas}
    • Costo promedio pagado por prenda válida: #{promedio_str}
    """
  end


  # 9. REPORTE DE COBERTURA COMPLETA DE LÍNEAS (R8)


  def generar_reporte_cobertura_lineas(confeccionistas, lineas, lotes_validos) do
    total_lineas = length(lineas)

    cumplen = Enum.filter(confeccionistas, fn c ->
      lineas_trabajadas =
        lotes_validos
        |> Enum.filter(fn l -> l.confeccionista == c.codigo end)
        |> Enum.map(fn l -> l.linea end)
        |> Enum.uniq()

      length(lineas_trabajadas) == total_lineas
    end)

    texto =
      if Enum.empty?(cumplen) do
        "Ningún confeccionista elaboró lotes en todas las líneas de producción."
      else
        Enum.map_join(cumplen, "\n", fn c -> "• [#{c.codigo}] #{c.nombre}" end)
      end

    """
    === REPORTE DE COBERTURA COMPLETA DE LÍNEAS ===
    #{texto}
    """
  end

end
