require 'faker'

# La tipica
def log(str)
  puts "[LOG] #{str}"
end

def warn(str)
  puts "[WARN] #{str}"  
end

ASIGNATURAS = ["lenguaje", "matematicas", "historia", "ciencias", "ingles", "religion"]

CICLOS = {
  ["Pre-Básica"] => [ "PK", "K" ],
  ["Primer Ciclo"] => [ "1", "2", "3", "4" ],
  ["Segundo Ciclo"] => [ "5", "6", "7", "8" ],
  ["Enseñanza Media"] => [ "I", "II", "III", "IV" ],
}

class Estudiante
  attr_accessor :nombre, :curso_actual

  def initialize(nombre, curso = nil)
    @nombre = nombre

    @notas = {}
    @hoja_de_vida = {}

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
    return "[Estudiante '#{@nombre}']"
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
    return promedio
  end


  # Muestra en la terminal las notas y el promedio de la asignatura de forma ordenada
  def mostrar_notas(nombre_asignatura)
    asignatura_seleccionada = get_asignatura(nombre_asignatura)
    if asignatura_seleccionada.nil?
      return
    end

    if asignatura_seleccionada.empty?
      log "#{prefijo} No hay notas asignadas para la asignatura '#{nombre_asignatura}'"
      return
    end

    promedio = get_promedio_asignatura(nombre_asignatura)

    log "#{prefijo} Mostrando notas de la asignatura: #{nombre_asignatura}"
    log " ||- Notas: #{asignatura_seleccionada.join(" - ")}"
    log " ||- Promedio: #{promedio}"
    log " -- "
  end

  # Inserta una nota en el array de la asignatura
  def agregar_nota(nota, nombre_asignatura)
    asignatura_seleccionada = get_asignatura(nombre_asignatura)
    if asignatura_seleccionada.nil?
      return
    end

    # Me imagino que hay una función que hace esto mucho mejor
    # pero viendo la documentación del objeto 'array' me mareó demasiado
    # Ni pude entender qué se supone que hace el argumento 'index' de array#insert
    asignatura_seleccionada[asignatura_seleccionada.size] = nota

    log "#{prefijo} Se le ha agregado la nota #{nota} a la asignatura #{nombre_asignatura}."
    mostrar_notas(nombre_asignatura)
  end
end

# Identificador: Ciclo (Pre basica, primer ciclo (1-4), segundo ciclo (5-8), ensseñanza media) + Numero/Letra
# Estudiantes (Hartas instancias)
class Curso
  attr_accessor :ciclo, :identificador, :letra

  def initialize(identificador, letra)
    @identificador = identificador
    @letra = letra

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
  end
end

curso1 = Curso.new("IV", "C")
estudiante1 = Estudiante.new("Diegox")
estudiante1.mostrar_notas("matematicas")

curso1.inscribir_a_curso(estudiante1)

