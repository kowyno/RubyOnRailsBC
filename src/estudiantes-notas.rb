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

  def prefijo
    return "'#{@nombre}':"
  end

  def mostrar_notas(asignatura)
    asignatura_seleccionada = @notas[asignatura.to_sym]

    if asignatura_seleccionada.nil?
      log "#{prefijo} Asignatura no encontrada: #{asignatura}"
      return
    end

    if asignatura_seleccionada.empty?
      log "#{prefijo} No hay notas asignadas para la asignatura '#{asignatura}'"
      return
    end
    
    log "#{asignatura_seleccionada}"
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

c1 = Curso.new("IV", "C")
e1 = Estudiante.new("Diegox", c1)
e1.mostrar_notas("matematicas")

c1.inscribir_a_curso("asdf")