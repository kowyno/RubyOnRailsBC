# Funciónes que son puramente estética
def log_warn(str)
  puts "[WARN] --- #{str}"
end

def log(str)
  puts "[LOG] --- #{str}"
end

# Constructor
class Conductor
  # Permite que el nombre, la edad y el auto_conducido sean accesible fuera del constructor
  attr_accessor :nombre, :edad, :auto_conducido
  
  def initialize(nuevo_nombre, nueva_edad)
    @nombre = nuevo_nombre
    @edad = nueva_edad
    @auto_conducido = nil 
    
    log("Se ha creado un conductor con nombre: '#{@nombre}' y edad: '#{@edad}'")
  end
  
  def presentarse
    if @auto_conducido
      puts "[#{nombre}]: Hola, mi nombre es #{nombre} y tengo #{edad} años. Estoy conduciendo un #{@auto_conducido.marca} #{@auto_conducido.modelo}"
    else
      puts "[#{nombre}]: Hola, mi nombre es #{nombre} y tengo #{edad} años. No estoy conduciendo ningun auto ahora mismo."
    end
  end
  
  # Hace que el conductor maneje un auto
  # Retornará "true" si ninguna de las condiciones que retornan "false" se cumplieron.
  # Retornará "false" si algúna de las condiciones se cumplieron.
  #   Esto también incluirá un mensaje de error para 
  #   que el bloque de código que llamó a la función sepa cuál fue la condición de error.
  def manejar_auto(auto)
    @auto_conducido = auto
    log("(#{nombre}) El conductor ahora está conduciendo el auto '#{auto.marca} #{auto.modelo}'")
    return true
  end
  
end

# Constructor
class Auto
  # Permite que la marca, modelo y conductor sean accesible fuera del constructor
  attr_accessor :marca, :modelo, :conductor
  
  def initialize(marca_asignada, modelo_asignado, conductor_asignado = nil)
    @marca = marca_asignada
    @modelo = modelo_asignado
    @conductor = nil
    @en_marcha = false
      
    log("Se ha creado un auto con marca: '#{@marca}' y modelo: '#{@modelo}'")
      
    if conductor_asignado
      self.asignar_conductor(conductor_asignado)
    end
  end
  
  # Retorna el prefijo del auto para que sea usado en las funciones de registro de consola
  # Su utilidad es puramente estética
  def prefijo
    return "(#{@marca} #{@modelo})"
  end
  
  # Toma un conductor, y una posible variable "sobrescribir_conductor" si se quiere sobrescribir el conductor
  def asignar_conductor(nuevo_conductor, sobrescribir_conductor = false)
    
    # Se inicializan variables para que despues sean cambiadas si se cumple cierta condición
    conductor_pudo_manejar = true
    mensaje_de_error = nil
    
    # Detecta si la edad no es suficiente para manejar el auto.
    if nuevo_conductor.edad < 18
      conductor_pudo_manejar = false
      mensaje_de_error = "Este conductor no puede conducir ningún auto porque es menor de edad!"
      
    # Detecta si se está intentando asignar el mismo conductor que ya está manejando el mismo auto
    elsif nuevo_conductor.auto_conducido == self
      conductor_pudo_manejar = false
      mensaje_de_error = "Este conductor ya está en este auto!"
      
    # Detecta si hay un conductor previo al que será asignado
    # Si "sobrescribir_conductor" es verdadero, se sobrescribirá al conductor
    # Sino, asignará "conductor_pudo_manejar" como false y la operación no se habrá completado exitosamente.
    elsif @conductor
      
      if @conductor && (sobrescribir_conductor == false)
        conductor_pudo_manejar = false
        mensaje_de_error = "Este auto ya tiene un conductor asignado! (#{@conductor.nombre})"
      elsif @conductor && (sobrescribir_conductor == true)
        log("#{prefijo} Se ha sobrescrito el conductor. (#{@conductor.nombre} => #{nuevo_conductor.nombre})")
        @conductor.auto_conducido = nil
      end
      
    end

    # Solo se asignará el conductor si no hubo ningún caso que cambiara "conductor_pudo_manejar" de verdadero a falso.
    # Si se cambió la variable a falso, entonces se mostrará un mensaje de advertencia, explicando qué ocurrió
    if conductor_pudo_manejar
      @conductor = nuevo_conductor
      log("#{prefijo} Se le ha asignado el conductor '#{nuevo_conductor.nombre}' correctamente.")
      nuevo_conductor.manejar_auto(self)
    else
      log_warn("#{prefijo} Error intentando asignar a #{nuevo_conductor.nombre} como el conductor de este auto: '#{mensaje_de_error}'")
    end
  end
  
  # Enlista los detalles del auto
  def detalles
    puts("")
    puts("Listando detalles del auto, ID: #{self}")
    puts("   Marca: #{@marca}")
    puts("   Modelo: #{@modelo}")
    puts("   Conductor: #{@conductor && @conductor.nombre || "-Sin conductor-"}")
    puts("   En marcha? #{@en_marcha}")
    puts("")
  end
  
  # Pone en marcha el auto. Require de un conductor
  # No hará nada si el auto ya está en marcha
  def conducir
    if @en_marcha == true
      log_warn("#{prefijo} Este auto ya está en marcha!")
      return
    end
    
    if not @conductor
      log_warn("#{prefijo} Este auto no puede ser conducido sin un conductor!")
      return
    end
    
    @en_marcha = true
    log("#{prefijo} Se ha puesto el auto en marcha.")
  end
  
  # Detiene el auto
  # Tiene que estar en marcha para poder detenerse
  def detener
    if @en_marcha == false
      log_warn("#{prefijo} Este auto ya está detenido!")
      return
    end
    
    @en_marcha = false
    log("#{prefijo} Se ha detenido el auto.")
  end
  
end

conductorErick = Conductor.new("Erick", 18) # [LOG] --- Se ha creado un conductor con nombre: 'Erick' y edad: '18'
conductorKenny = Conductor.new("Kenny", 19) # [LOG] --- Se ha creado un conductor con nombre: 'Kenny' y edad: '19'
conductorSusana = Conductor.new("Susana", 17) # [LOG] --- Se ha creado un conductor con nombre: 'Susana' y edad: '17'

autoUno = Auto.new("MG", "Magnette", conductorSusana) 
# [LOG] --- Se ha creado un auto con marca: 'MG' y modelo: 'Magnette'
# [WARN] --- (MG Magnette) Error intentando asignar a Susana como el conductor de este auto: 'Este conductor no puede conducir ningún auto porque es menor de edad!'

autoUno.detalles
# Listando detalles del auto, ID: #<Auto:0x00007f6965ba1aa0>
#    Marca: MG
#    Modelo: Magnette
#    Conductor: -Sin conductor-
#    En marcha? false

autoUno.asignar_conductor(conductorSusana)
# [WARN] --- (MG Magnette) Error intentando asignar a Susana como el conductor de este auto: 'Este conductor no puede conducir ningún auto porque es menor de edad!'

autoUno.conducir
# [WARN] --- (MG Magnette) Este auto no puede ser conducido sin un conductor!

autoUno.detener
# [WARN] --- (MG Magnette) Este auto ya está detenido!

conductorErick.presentarse
# [Erick]: Hola, mi nombre es Erick y tengo 18 años. No estoy conduciendo ningun auto ahora mismo.

autoUno.asignar_conductor(conductorErick)
# [LOG] --- (MG Magnette) Se le ha asignado el conductor 'Erick' correctamente.
# [LOG] --- (Erick) El conductor ahora está conduciendo el auto 'MG Magnette'

autoUno.asignar_conductor(conductorErick)
# [WARN] --- (MG Magnette) Error intentando asignar a Erick como el conductor de este auto: 'Este conductor ya está en este auto!'

conductorErick.presentarse
# [Erick]: Hola, mi nombre es Erick y tengo 18 años. Estoy conduciendo un MG Magnette

autoUno.asignar_conductor(conductorKenny)
# [WARN] --- (MG Magnette) Error intentando asignar a Kenny como el conductor de este auto: 'Este auto ya tiene un conductor asignado! (Erick)'

autoUno.asignar_conductor(conductorKenny, true)
# [LOG] --- (MG Magnette) Se ha sobrescrito el conductor. (Erick => Kenny)
# [LOG] --- (MG Magnette) Se le ha asignado el conductor 'Kenny' correctamente.
# [LOG] --- (Kenny) El conductor ahora está conduciendo el auto 'MG Magnette'

autoUno.conducir
# [LOG] --- (MG Magnette) Se ha puesto el auto en marcha.

autoUno.conducir
# [WARN] --- (MG Magnette) Este auto ya está en marcha!

autoUno.detalles
# Listando detalles del auto, ID: #<Auto:0x00007f6965ba1aa0>
#    Marca: MG
#    Modelo: Magnette
#    Conductor: Kenny
#    En marcha? true

autoUno.detener
# [LOG] --- (MG Magnette) Se ha detenido el auto.

autoUno.detener
# [WARN] --- (MG Magnette) Este auto ya está detenido!