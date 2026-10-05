# Integrantes
#- Nombre jhoan steven gonzalez upegui - 1092456579
#- Nombre santiago rico arango - 1090274268
#- Nombre jose federico rincon ramos- 1092456434


defmodule Datos do
  @doc """
  #SECCION CAMBIO DE DATOS
  Retorna la lista de los 10 confeccionistas registrados.
  """
  def confeccionistas do
    [
      %{codigo: "C01", nombre: "María Gómez", alquiler: true},
      %{codigo: "C02", nombre: "Carlos Pérez", alquiler: false},
      %{codigo: "C03", nombre: "Ana Rodríguez", alquiler: true},
      %{codigo: "C04", nombre: "Luis Martínez", alquiler: false},
      %{codigo: "C05", nombre: "Elena Torres", alquiler: true},
      %{codigo: "C06", nombre: "Jorge Ramírez", alquiler: true},
      %{codigo: "C07", nombre: "Sofia López", alquiler: false},
      %{codigo: "C08", nombre: "Diego Hernández", alquiler: false},
      %{codigo: "C09", nombre: "Laura Morales", alquiler: false},
      %{codigo: "C10", nombre: "Pedro Sánchez", alquiler: false}
    ]
  end

  @doc """
  Retorna las 4 líneas de producción del taller.
  """
  def lineas do
    [
      %{id: "L1", nombre: "Camisas y Camisetas"},
      %{id: "L2", nombre: "Pantalones y Jeans"},
      %{id: "L3", nombre: "Chaquetas y Abrigos"},
      %{id: "L4", nombre: "Ropa Deportiva"}
    ]
  end

  @doc """
  Retorna la lista combinada de 90 lotes (80 válidos y 10 inválidos).
  """
  def lotes do
    lotes_validos() ++ lotes_invalidos()
  end

  # =========================================================================
  # FUNCIONES PRIVADAS DE DATOS ENCAPSULADAS


  # 80 LOTES VALIDOS
  defp lotes_validos do
  [
    #  CONFECCIONISTA C01 (8 lotes)
    %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 130, defectos: 1.5},
    %{confeccionista: "C01", linea: "L1", dia: 2, prendas: 140, defectos: 2.0},
    %{confeccionista: "C01", linea: "L2", dia: 3, prendas: 125, defectos: 0.5},
    %{confeccionista: "C01", linea: "L2", dia: 4, prendas: 135, defectos: 1.0},
    %{confeccionista: "C01", linea: "L3", dia: 5, prendas: 150, defectos: 2.5},
    %{confeccionista: "C01", linea: "L3", dia: 6, prendas: 160, defectos: 1.8},
    %{confeccionista: "C01", linea: "L4", dia: 1, prendas: 110, defectos: 0.0},
    %{confeccionista: "C01", linea: "L4", dia: 2, prendas: 120, defectos: 1.2},

    # CONFECCIONISTA C02 (8 lotes)
    %{confeccionista: "C02", linea: "L2", dia: 1, prendas: 110, defectos: 3.0},
    %{confeccionista: "C02", linea: "L3", dia: 2, prendas: 105, defectos: 2.1},
    %{confeccionista: "C02", linea: "L3", dia: 3, prendas: 115, defectos: 1.5},
    %{confeccionista: "C02", linea: "L4", dia: 4, prendas: 100, defectos: 1.0},
    %{confeccionista: "C02", linea: "L4", dia: 5, prendas: 125, defectos: 0.8},
    %{confeccionista: "C02", linea: "L1", dia: 6, prendas: 130, defectos: 2.0},
    %{confeccionista: "C02", linea: "L1", dia: 1, prendas: 140, defectos: 1.1},
    %{confeccionista: "C02", linea: "L2", dia: 2, prendas: 118, defectos: 0.5},

    # CONFECCIONISTA C03 (8 lotes)
    %{confeccionista: "C03", linea: "L3", dia: 1, prendas: 145, defectos: 1.0},
    %{confeccionista: "C03", linea: "L3", dia: 2, prendas: 150, defectos: 2.2},
    %{confeccionista: "C03", linea: "L4", dia: 3, prendas: 140, defectos: 1.5},
    %{confeccionista: "C03", linea: "L4", dia: 4, prendas: 130, defectos: 0.9},
    %{confeccionista: "C03", linea: "L1", dia: 5, prendas: 135, defectos: 1.8},
    %{confeccionista: "C03", linea: "L1", dia: 6, prendas: 155, defectos: 2.0},
    %{confeccionista: "C03", linea: "L2", dia: 1, prendas: 160, defectos: 1.2},
    %{confeccionista: "C03", linea: "L2", dia: 2, prendas: 128, defectos: 0.7},

    # CONFECCIONISTA C04 (8 lotes)
    %{confeccionista: "C04", linea: "L4", dia: 1, prendas: 90,  defectos: 0.5},
    %{confeccionista: "C04", linea: "L4", dia: 2, prendas: 95,  defectos: 0.0},
    %{confeccionista: "C04", linea: "L1", dia: 3, prendas: 105, defectos: 1.4},
    %{confeccionista: "C04", linea: "L1", dia: 4, prendas: 110, defectos: 2.0},
    %{confeccionista: "C04", linea: "L2", dia: 5, prendas: 115, defectos: 1.1},
    %{confeccionista: "C04", linea: "L2", dia: 6, prendas: 120, defectos: 0.8},
    %{confeccionista: "C04", linea: "L3", dia: 3, prendas: 100, defectos: 1.5},
    %{confeccionista: "C04", linea: "L3", dia: 4, prendas: 108, defectos: 1.0},

    #  CONFECCIONISTA C05 (8 lotes)
    %{confeccionista: "C05", linea: "L1", dia: 1, prendas: 160, defectos: 4.0},
    %{confeccionista: "C05", linea: "L1", dia: 2, prendas: 170, defectos: 3.5},
    %{confeccionista: "C05", linea: "L2", dia: 3, prendas: 150, defectos: 2.8},
    %{confeccionista: "C05", linea: "L2", dia: 4, prendas: 155, defectos: 2.0},
    %{confeccionista: "C05", linea: "L3", dia: 5, prendas: 165, defectos: 3.1},
    %{confeccionista: "C05", linea: "L3", dia: 6, prendas: 180, defectos: 1.9},
    %{confeccionista: "C05", linea: "L4", dia: 1, prendas: 140, defectos: 2.2},
    %{confeccionista: "C05", linea: "L4", dia: 2, prendas: 145, defectos: 1.7},

    # CONFECCIONISTA C06 (8 lotes)
    %{confeccionista: "C06", linea: "L2", dia: 1, prendas: 115, defectos: 1.2},
    %{confeccionista: "C06", linea: "L2", dia: 2, prendas: 120, defectos: 2.5},
    %{confeccionista: "C06", linea: "L3", dia: 3, prendas: 125, defectos: 1.8},
    %{confeccionista: "C06", linea: "L3", dia: 4, prendas: 130, defectos: 0.9},
    %{confeccionista: "C06", linea: "L4", dia: 5, prendas: 135, defectos: 1.0},
    %{confeccionista: "C06", linea: "L4", dia: 6, prendas: 140, defectos: 2.1},
    %{confeccionista: "C06", linea: "L1", dia: 3, prendas: 110, defectos: 0.5},
    %{confeccionista: "C06", linea: "L1", dia: 4, prendas: 122, defectos: 1.4},

    # CONFECCIONISTA C07 (8 lotes)
    %{confeccionista: "C07", linea: "L3", dia: 1, prendas: 105, defectos: 0.8},
    %{confeccionista: "C07", linea: "L3", dia: 2, prendas: 112, defectos: 1.0},
    %{confeccionista: "C07", linea: "L4", dia: 3, prendas: 118, defectos: 1.6},
    %{confeccionista: "C07", linea: "L4", dia: 4, prendas: 124, defectos: 2.0},
    %{confeccionista: "C07", linea: "L1", dia: 5, prendas: 130, defectos: 0.4},
    %{confeccionista: "C07", linea: "L1", dia: 6, prendas: 135, defectos: 1.2},
    %{confeccionista: "C07", linea: "L2", dia: 5, prendas: 100, defectos: 0.9},
    %{confeccionista: "C07", linea: "L2", dia: 6, prendas: 108, defectos: 1.5},

    #  CONFECCIONISTA C08 (8 lotes)
    %{confeccionista: "C08", linea: "L4", dia: 1, prendas: 125, defectos: 1.7},
    %{confeccionista: "C08", linea: "L4", dia: 2, prendas: 130, defectos: 1.1},
    %{confeccionista: "C08", linea: "L1", dia: 3, prendas: 138, defectos: 2.3},
    %{confeccionista: "C08", linea: "L1", dia: 4, prendas: 142, defectos: 0.6},
    %{confeccionista: "C08", linea: "L2", dia: 5, prendas: 148, defectos: 1.8},
    %{confeccionista: "C08", linea: "L2", dia: 6, prendas: 152, defectos: 2.4},
    %{confeccionista: "C08", linea: "L3", dia: 1, prendas: 115, defectos: 0.5},
    %{confeccionista: "C08", linea: "L3", dia: 2, prendas: 121, defectos: 1.0},

    # ONFECCIONISTA C09 (8 lotes)
    %{confeccionista: "C09", linea: "L1", dia: 1, prendas: 135, defectos: 2.0},
    %{confeccionista: "C09", linea: "L1", dia: 2, prendas: 140, defectos: 1.3},
    %{confeccionista: "C09", linea: "L2", dia: 3, prendas: 145, defectos: 0.7},
    %{confeccionista: "C09", linea: "L2", dia: 4, prendas: 150, defectos: 1.9},
    %{confeccionista: "C09", linea: "L3", dia: 5, prendas: 155, defectos: 2.2},
    %{confeccionista: "C09", linea: "L3", dia: 6, prendas: 160, defectos: 1.1},
    %{confeccionista: "C09", linea: "L4", dia: 3, prendas: 128, defectos: 0.8},
    %{confeccionista: "C09", linea: "L4", dia: 4, prendas: 132, defectos: 1.6},

    #  CONFECCIONISTA C10 (8 lotes)
    %{confeccionista: "C10", linea: "L2", dia: 1, prendas: 140, defectos: 1.5},
    %{confeccionista: "C10", linea: "L2", dia: 2, prendas: 145, defectos: 0.9},
    %{confeccionista: "C10", linea: "L3", dia: 3, prendas: 150, defectos: 2.1},
    %{confeccionista: "C10", linea: "L3", dia: 4, prendas: 158, defectos: 1.4},
    %{confeccionista: "C10", linea: "L4", dia: 5, prendas: 162, defectos: 0.3},
    %{confeccionista: "C10", linea: "L4", dia: 6, prendas: 170, defectos: 1.8},
    %{confeccionista: "C10", linea: "L1", dia: 5, prendas: 138, defectos: 2.0},
    %{confeccionista: "C10", linea: "L1", dia: 6, prendas: 144, defectos: 1.1}
  ]
end

  # 10 Lotes de prueba diseñados para fallar exactamente en 1 de las 5 reglas definidas.


  defp lotes_invalidos do
    [
      # Regla 1: Confeccionista no existe
      %{confeccionista: "C99", linea: "L1", dia: 1, prendas: 100, defectos: 2.0},
      %{confeccionista: "CX",  linea: "L2", dia: 2, prendas: 100, defectos: 1.0},

      # Regla 2: Línea no existe
      %{confeccionista: "C01", linea: "L9", dia: 1, prendas: 100, defectos: 2.0},
      %{confeccionista: "C02", linea: "LZ", dia: 2, prendas: 100, defectos: 1.0},

      # Regla 3: Día fuera del rango (debe ser entre 1 y 6)
      %{confeccionista: "C01", linea: "L1", dia: 0, prendas: 100, defectos: 2.0},
      %{confeccionista: "C02", linea: "L2", dia: 7, prendas: 100, defectos: 1.0},

      # Regla 4: Cantidad de prendas inválida (debe ser mayor a 0)
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 0,   defectos: 2.0},
      %{confeccionista: "C02", linea: "L2", dia: 2, prendas: -15, defectos: 1.0},

      # Regla 5: porcentaje de defectos fuera de rango (debe estar entre 0.0 y 100.0)
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 100, defectos: -0.5},
      %{confeccionista: "C02", linea: "L2", dia: 2, prendas: 100, defectos: 105.0}
    ]
  end
end
