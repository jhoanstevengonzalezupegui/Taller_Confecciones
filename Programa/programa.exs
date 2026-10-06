# Integrantes:
# - Jhoan Steven González Upegui - 1092456579
# - Santiago Rico Arango - 1090274268
# - José Federico Rincón Ramos - 1092456434

# Carga de los módulos del proyecto
Code.require_file("util.exs")
Code.require_file("datos.exs")
Code.require_file("liquidacion.exs")
Code.require_file("reportes.exs")
Code.require_file("validacion.exs")

defmodule Programa do
  @moduledoc """
  Módulo principal de entrada y orquestación del programa del Taller de Confecciones.
  Gestiona la lectura interactiva del lote adicional, coordina el flujo de
  validaciones y liquidaciones, imprime los 8 reportes del sistema y genera
  el comprobante individual de pago.
  """

  @doc """
  Punto de entrada principal de la aplicación.
  Ejecuta de forma secuencial la captura de datos, procesamiento de reglas de negocio,
  generación de reportes y consulta final de comprobantes.
  """
  def main do
    confeccionistas = Datos.confeccionistas()
    lineas = Datos.lineas()
    lotes_originales = Datos.lotes()

    # 1. Entrada opcional de Lote Adicional
    IO.puts("=== INGRESO DE LOTE ADICIONAL ===")
    IO.puts("Ingrese un lote adicional (confeccionista;linea;dia;prendas;defectos) o presione ENTER para omitir:")
    IO.puts("Ejemplo: C03;L2;4;85;3.5")
    entrada = IO.gets("> ") |> to_string() |> String.trim()

    lotes_totales = procesar_lote_adicional(entrada, lotes_originales)

    # 2. Procesamiento de Validaciones y Liquidación
    %{validos: validos, rechazados: rechazados} = Validacion.procesar_lotes(lotes_totales)
    liquidaciones = Liquidacion.liquidar_todos(confeccionistas, validos)

    # 3. Impresión Secuencial de los 8 Reportes del Sistema
    IO.puts("\n===================================================")
    IO.puts("         IMPRESIÓN DE REPORTES DEL SISTEMA          ")
    IO.puts("===================================================\n")

    IO.puts(Reportes.generar_reporte_lotes_rechazados(rechazados))
    IO.puts(Reportes.generar_reporte_productividad_lineas(lineas, validos))
    IO.puts(Reportes.generar_reporte_cumplimiento_meta(validos))
    IO.puts(Reportes.generar_reporte_liquidacion_semanal(liquidaciones))
    IO.puts(Reportes.generar_reporte_lideres_diarios(confeccionistas, validos))
    IO.puts(Reportes.generar_reporte_mejor_calidad(confeccionistas, validos))
    IO.puts(Reportes.generar_reporte_totales_y_costo_promedio(liquidaciones, validos))
    IO.puts(Reportes.generar_reporte_cobertura_lineas(confeccionistas, lineas, validos))

    # 4. Consulta de Comprobante Individual
    IO.puts("=== CONSULTA DE COMPROBANTE INDIVIDUAL ===")
    IO.write("Ingrese el código del confeccionista a consultar (ej. C01): ")
    cod_consulta = IO.gets("") |> to_string() |> String.trim()
    mostrar_comprobante(cod_consulta, confeccionistas, validos)
  end

  # =========================================================================
  # FUNCIONES PRIVADAS
  # =========================================================================

  defp procesar_lote_adicional("", lotes), do: lotes

  defp procesar_lote_adicional(texto, lotes) do
    partes = if String.contains?(texto, ";"), do: String.split(texto, ";"), else: String.split(texto)
    partes_limpias = Enum.map(partes, &String.trim/1)

    case partes_limpias do
      [conf, lin, dia_str, prendas_str, def_str] ->
        case {Integer.parse(dia_str), Integer.parse(prendas_str), Float.parse(def_str)} do
          {{dia, ""}, {prendas, ""}, {defectos, ""}} ->
            lote_nuevo = %{confeccionista: conf, linea: lin, dia: dia, prendas: prendas, defectos: defectos}
            IO.puts("-> Lote adicional registrado correctamente.\n")
            lotes ++ [lote_nuevo]

          _ ->
            IO.puts("-> Error: Los valores numéricos del lote adicional no son válidos.\n")
            lotes
        end

      _ ->
        IO.puts("-> Error: El formato del lote adicional es inválido.\n")
        lotes
    end
  end

  defp mostrar_comprobante(codigo, confeccionistas, lotes_validos) do
    case Enum.find(confeccionistas, fn c -> c.codigo == codigo end) do
      nil ->
        IO.puts("El confeccionista con código '#{codigo}' no existe.")

      c ->
        liq = Liquidacion.liquidar_confeccionista(c, lotes_validos)

        IO.puts("""
        --------------------------------------------------
        COMPROBANTE INDIVIDUAL DE LIQUIDACIÓN
        • Código: #{c.codigo} | Nombre: #{c.nombre}
        • Máquina Alquilada: #{if c.alquiler, do: "SÍ (-$15.000/día)", else: "NO"}
        • Días Trabajados: #{liq.dias_trabajados}
        • Prendas Totales: #{liq.prendas}
        • Valor Lotes (Bruto): #{Util.formato_moneda(liq.bruto)}
        • Bonificaciones Totales: #{Util.formato_moneda(liq.bonificacion)}
        • Descuento por Alquiler: -#{Util.formato_moneda(liq.alquiler_descuento)}
        • PAGO NETO TOTAL: #{Util.formato_moneda(liq.neto)}
        --------------------------------------------------
        """)
    end
  end
end

# Ejecución del programa
Programa.main()
