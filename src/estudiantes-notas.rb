require 'faker'

# La tipica
def log(str)
  puts "[LOG] #{str}"
end

def warn(str)
  puts "[WARN] #{str}"  
end

ASIGNATURAS = ["lenguaje", "matematicas", "historia", "ciencias", "ingles", "religion"]

# TODO:
# Función ranking de promedios de asignaturas, de forma descendiente
# Función de promedio general: Muestra la nota de todas las asignaturas, junto al promedio. Al final, muestra el promedio general del curso.
# Función emitir mensaje personalizado al finalizar el curso
class Estudiante
  attr_accessor :nombre, :curso_actual

  PROMEDIO_APROBATORIO = 4.0

  def initialize(nombre, curso = nil)
    @nombre = nombre
    @notas = {}
    @hoja_de_vida = {}
    @curso_actual = nil

    ASIGNATURAS.each {|key| 
      @notas[key.to_sym] = []
    }

    log("Se ha creado el estudiante #{nombre}")

    if curso && curso.class == Curso
      curso.inscribir_a_curso(self)
    end
  end

  # Funcion extremadamente útil
  def saludar
    puts "No gracias."
  end

  # Funcion solo de estética (para la terminal)
  def prefijo
    if @curso_actual
      return "['#{@nombre}' @ #{@curso_actual.nombre_curso}]"
    else
      return "['#{@nombre}' @ Sin Curso]"
    end
  end

  # Devuelve el array correspondiente a la asignatura, donde están almacenadas las notas
  def get_asignatura(nombre_asignatura)
    asignatura_seleccionada = @notas[nombre_asignatura.to_sym]

    if asignatura_seleccionada.nil?
      warn "#{prefijo} Asignatura no encontrada: #{nombre_asignatura}"
      return
    end

    return asignatura_seleccionada
  end

  # Devuleve el promedio de la asignatura en valor numérico
  # SOLO DEBE DE SER UTILIZADO COMO FUNCIÓN INTERNA
  def get_promedio_asignatura(nombre_asignatura)
    asignatura_seleccionada = get_asignatura(nombre_asignatura)
    if asignatura_seleccionada.nil?
      return
    end

    valorNotas = 0
    asignatura_seleccionada.each{|key|
      valorNotas += key
    }

    promedio = valorNotas / (asignatura_seleccionada.size)
    return promedio.truncate(2)
  end

  # Muestra en la terminal las notas y el promedio de la asignatura de forma ordenada
  def mostrar_data_asignatura(nombre_asignatura)
    asignatura_seleccionada = get_asignatura(nombre_asignatura)
    if asignatura_seleccionada.nil?
      return
    end

    if asignatura_seleccionada.empty?
      log "#{prefijo} No hay notas asignadas para la asignatura '#{nombre_asignatura}'"
      return
    end

    promedio = get_promedio_asignatura(nombre_asignatura)

    log "#{prefijo} Mostrando datos de la asignatura: #{nombre_asignatura}"
    log " ||- Notas: #{asignatura_seleccionada.join(" - ")}"
    log " ||- Promedio: #{promedio}"
    if promedio < PROMEDIO_APROBATORIO then
      log "[ADVERTENCIA] Este estudiante tiene un promedio ROJO en esta asignatura!"
    end
    log " -- "
  end

  # Inserta una nota en el array de la asignatura
  # Solo se toma el primer decimal de la nota para ser guardado
  def agregar_nota(nota, nombre_asignatura)
    asignatura_seleccionada = get_asignatura(nombre_asignatura)
    if asignatura_seleccionada.nil?
      return
    end

    # Me imagino que hay una función que hace esto mucho mejor
    # pero viendo la documentación del objeto 'array' me mareó demasiado
    # Ni pude entender qué se supone que hace el argumento 'index' de array#insert
    asignatura_seleccionada[asignatura_seleccionada.size] = nota.truncate(1)

    log "#{prefijo} Se le ha agregado la nota #{nota} a la asignatura #{nombre_asignatura}."
    mostrar_data_asignatura(nombre_asignatura)
  end
end

# Identificador: Ciclo (Pre basica, primer ciclo (1-4), segundo ciclo (5-8), ensseñanza media) + Numero/Letra
# Estudiantes (Hartas instancias)
CICLOS = {
  ["Pre-Básica"] => [ "PK", "K" ],
  ["Primer Ciclo"] => [ "1", "2", "3", "4" ],
  ["Segundo Ciclo"] => [ "5", "6", "7", "8" ],
  ["Enseñanza Media"] => [ "I", "II", "III", "IV" ],
} 

class Curso
  attr_accessor :ciclo, :identificador, :letra

  def initialize(identificador, letra)
    @identificador = identificador
    @letra = letra
    @estudiantes = []

    log("Se ha creado el curso #{identificador}°#{letra}")
  end

  def nombre_curso
    return "#{@identificador}°#{@letra}"
  end

  def inscribir_a_curso(estudiante)
    if estudiante.class != Estudiante
      warn "#{estudiante} no es de clase Estudiante!"
      return
    end

    log("INSCRIPCION AL CURSO: #{estudiante.nombre} => #{self.nombre_curso}")
    @estudiantes[@estudiantes.size] = estudiante
    estudiante.curso_actual = self
  end

  def ciclo
    ciclo_obtenido = nil

    # Pasa por todos los ciclos
    CICLOS.each{|ciclo, identificadores|
      identificadores.each{|identif_en_ciclo|
        if @identificador == identif_en_ciclo then
          ciclo_obtenido = ciclo[0]
          break
        end
      }
    }

    return ciclo_obtenido
  end
end

curso1 = Curso.new("I", "C")
estudiante1 = Estudiante.new("Diegox")
estudiante1.mostrar_data_asignatura("matematicas")

curso1.inscribir_a_curso(estudiante1)

estudiante1.agregar_nota(7.00, "lenguaje")
estudiante1.agregar_nota(1.00, "lenguaje")
estudiante1.agregar_nota(7.001, "lenguaje")
estudiante1.agregar_nota(1.00, "lenguaje")
estudiante1.agregar_nota(7.00, "lenguaje")
estudiante1.agregar_nota(1.001, "lenguaje")
estudiante1.agregar_nota(1.001, "lenguaje")
estudiante1.agregar_nota(1.001, "lenguaje")

estudiante1.mostrar_data_asignatura("lenguaje")

log "#{curso1.ciclo}"