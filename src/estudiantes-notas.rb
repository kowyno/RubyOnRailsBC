require 'faker'

RNG = Random.new(Random.new_seed)

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

  def get_promedio_general
    valorPromedios = 0

    ASIGNATURAS.each{|nombre_asignatura|
      valorPromedios += get_promedio_asignatura(nombre_asignatura)
    }

    promedio_general = valorPromedios / (ASIGNATURAS.size)
    return promedio_general
  end

  # Muestra en la terminal las notas y el promedio de la asignatura de forma ordenada
  def display_data_asignatura(nombre_asignatura)
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

  def display_informe_de_notas
    log "#{prefijo} Mostrando Informe de notas"

    @notas.each{|sym_asignatura, array_notas|
      nombre_asignatura = sym_asignatura.to_s
      asignatura_seleccionada = get_asignatura(nombre_asignatura)

      log " || - Asignatura: #{nombre_asignatura}"
      log " ||      || Notas: #{asignatura_seleccionada.join(" - ")}"
      log " ||      || Promedio: #{get_promedio_asignatura(nombre_asignatura)}"
    }

    log " ||"
    log " || Promedio general: #{self.get_promedio_general}"
    log " -- "
  end

  # Inserta una nota en el array de la asignatura
  # Solo se toma el primer decimal de la nota para ser guardado
  def agregar_nota(nota, nombre_asignatura, silentUpdate = nil)
    asignatura_seleccionada = get_asignatura(nombre_asignatura)
    if asignatura_seleccionada.nil?
      return
    end

    asignatura_seleccionada.push(nota.truncate(1))

    # No muestra nada en la terminal si se envia el parametro "true" como tercer argumento (silent update)
    if silentUpdate.nil?
      log "#{prefijo} Se le ha agregado la nota #{nota} a la asignatura #{nombre_asignatura}."
      display_data_asignatura(nombre_asignatura)
    end
  end


end

# Identificador: Ciclo (Pre basica, primer ciclo (1-4), segundo ciclo (5-8), ensseñanza media) + Numero/Letra
# Estudiantes (Hartas instancias)
CICLOS = {
  prebasica: [ "PK", "K" ],
  primerciclo: [ "1", "2", "3", "4" ],
  segundociclo: [ "5", "6", "7", "8" ],
  media: [ "I", "II", "III", "IV" ],
  debug: ["IV"]
}

NOMBRES_CICLOS = {
  prebasica: "Pre-Básica",
  primerciclo: "Primer Ciclo",
  segundociclo: "Segundo Ciclo",
  media: "Enseñanza Media",
  debug: "Enseñanza Media"
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
    @estudiantes.push(estudiante)
    estudiante.curso_actual = self
  end

  def ciclo
    ciclo_obtenido = nil

    # Pasa por todos los ciclos
    CICLOS.each{|ciclo, identificadores|
      identificadores.each{|identif_en_ciclo|
        if @identificador == identif_en_ciclo then
          ciclo_obtenido = ciclo
          break
        end
      }
    }

    return NOMBRES_CICLOS[ciclo_obtenido]
  end
  
  def get_first_place(asignatura = nil)
    if asignatura
      # log "Consiguiendo el primer lugar de la asignatura: #{asignatura}"
      orden_estudiantes = @estudiantes.sort_by{ |estudiante| -estudiante.get_promedio_asignatura(asignatura) }

      return orden_estudiantes[0]
    else
      # log "Consiguiendo el top 1 del curso"
      orden_estudiantes = @estudiantes.sort_by{ |estudiante| -estudiante.get_promedio_general }
      return orden_estudiantes[0]
    end
  end

  # Hace un ranking de los estudiantes basado en su promedio general
  # Tambien toma el argumento "asignatura", el cual ordenará a los estudiantes segun el promedio de una asignatura en vez del general
  
  # Siento que esta funcion usa código repetido, pero tampoco encontré una forma mejor de hacerlo
  # Aún así, la función cumple con su función (lolazo)
  def rank_estudiantes(asignatura = nil)
    i = 1

    if asignatura
      log "Rankeando a los estudiantes del curso según asignatura: #{asignatura}"
      orden_estudiantes = @estudiantes.sort_by{ |estudiante| -estudiante.get_promedio_asignatura(asignatura) }

      orden_estudiantes.each{|estudiante|
        puts " || (#{i}°) #{estudiante.nombre} (#{estudiante.get_promedio_asignatura(asignatura).truncate(2)})"
        i += 1
      }
    else
      log "Rankeando a los estudiantes del curso según promedio general."
      orden_estudiantes = @estudiantes.sort_by{ |estudiante| -estudiante.get_promedio_general }

      orden_estudiantes.each{|estudiante|
        puts " || (#{i}°) #{estudiante.nombre} (#{estudiante.get_promedio_general.truncate(2)})"
        i += 1
      }
    end

    puts " -- "
  end

  def finalizar_curso
    puts " =========== [ FINALIZACIÓN DE CURSO ] ==========="  

    log "Se está realizando una ceremonia"
    log "El curso #{nombre_curso} ha finalizado!"

    if @identificador == "IV"
      log "Los estudiantes se estan graduando del colegio!"
    end

    log "A continuación, veremos una recopilación de las mejores estadisticas del curso:"

    # Muestra el ranking de cada asignatura de la clase
    ASIGNATURAS.each{|nombre_asignatura|
      rank_estudiantes(nombre_asignatura)
    }

    # Muestra a los mejores estudiantes de cada asignatura
    puts " =========== [ Premiación alumnos destacados ] ==========="
    log "Ahora, haremos la premiación a los mejores estudiantes de cada asignatura:"
    ASIGNATURAS.each{|nombre_asignatura|
      mejor_estudiante = get_first_place(nombre_asignatura)
      log "Se premia a #{mejor_estudiante.nombre} por tener el mejor promedio en #{nombre_asignatura}!"
    }

    # Muestra a los estudiantes que no pudieron pasar de curso
    puts " =========== [ Estudiantes reprobatorios ] =========== "
    @estudiantes.each{|estudiante|
      if estudiante.get_promedio_general < Estudiante::PROMEDIO_APROBATORIO
        log "Lamentablemente, el estudiante #{estudiante.nombre} no ha podido pasar de curso debido a su promedio (#{estudiante.get_promedio_general.truncate(2)})"
      end
    }

    # Muestra a los estudiantes que sí pasaron de curso
    puts " =========== [ Estudiantes aprobatorios ] =========== "
    @estudiantes.each{|estudiante|
      if estudiante.get_promedio_general >= Estudiante::PROMEDIO_APROBATORIO
        log "Felicitamos al estudiante #{estudiante.nombre} por pasar de curso! (#{estudiante.get_promedio_general.truncate(2)})"
      end
    }

    puts " =========== [ !!! ] =========== "
    log "Por último, veremos qué estudiante tuvo el mejor promedio..."
    log "..."
    log "Y ese estudiante es..."
    
    mejor_estudiante_general = get_first_place
    log "#{mejor_estudiante_general.nombre}! Felicitaciones por conseguir el mejor promedio general del curso! (#{mejor_estudiante_general.get_promedio_general.truncate(3)})"

    puts " =========== [ Término de ceremonia ] =========== "
    log " Muchas gracias por asistir a la ceremonia del curso #{nombre_curso}. Nos veremos hasta la próxima!"
  end
end

# GENERACIÓN DE COLEGIOS
# El siguiente código es solamente para generar una prueba de un colegio, en conjunto a la configuración a continuación
# Puede ser eliminado si así se desea

colegio_ciclos = [:debug] # Todos los simbolos de los ciclos pertenecientes al colegio. Todos los cursos de cada ciclo serán agregados
colegio_letras = ["C"] # Letras de cada curso. Pueden ser múltiples (A, B, C, etc.)
colegio_estudiantes_por_curso = 5 # Estudiantes por cada curso
colegio_notas_por_asignatura = 10
colegio_cursos = [] # Almacenamiento de todos los cursos (clases Curso) del colegio

# Le asignará al colegio cada uno de los cursos de los ciclos asignados
colegio_ciclos.each{|ciclo_a_agregar|

  # Se asegura de que el ciclo existe, ya que puede ser que se escribió mal.
  if CICLOS[ciclo_a_agregar].nil?
    warn "[ERROR] No se ha encontrado el ciclo: #{ciclo_a_agregar}. Escribiste bien el nombre del ciclo?"
    break
  end

  # Agrega todos los cursos del ciclo
  CICLOS[ciclo_a_agregar].each{|identificador_curso|

    # Agrega un curso por cada letra en la configuración
    colegio_letras.each{|letra|
      nuevo_curso = Curso.new(identificador_curso, letra)

      # Crea un estudiante nuevo, según configuracion (colegio_estudiantes_por_curso)
      i = 0
      loop do
        nuevo_estudiante = Estudiante.new(Faker::Name.name, nuevo_curso)

        # Asigna todas las notas necesarias para cada asignatura, según configuracion (colegio_notas_por_asignatura)
        ASIGNATURAS.each{|nombre_asignatura|
          j = 0
          loop do
            nuevo_estudiante.agregar_nota(RNG.rand(1.0..7.0), nombre_asignatura, true)
            j += 1
            if j == colegio_notas_por_asignatura
              break
            end
          end
        }

        # MOSTRAR INFORME DE NOTAS DEL ESTUDIANTE:
        # Se recomienda asignar solo 1 estudiante por curso para activar esta funcion
        # nuevo_estudiante.display_informe_de_notas

        i += 1
        if i == colegio_estudiantes_por_curso
          break
        end
      end

      # nuevo_curso.rank_estudiantes("lenguaje")
      # nuevo_curso.rank_estudiantes("matematicas")

      nuevo_curso.finalizar_curso
      colegio_cursos.push(nuevo_curso)
    }
  }
}
