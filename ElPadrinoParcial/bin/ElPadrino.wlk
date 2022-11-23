
class Armas {
	method peligrosidad() = 5
	method usar(objetivo){
		objetivo.recibirHerida()
	}
	method estaBuenEstado(){
		return true
	}
}

class Revolver inherits Armas {
	var property balas
	override method peligrosidad() = balas * 2
	override method usar(objetivo){
		if(self.estaBuenEstado()){
			objetivo.morir()
		}
	}
	override method estaBuenEstado(){
		return balas>0
	}
	method recargarse(){
		balas = 6
	}
}

class RevolverOxidado inherits Revolver {
	override method peligrosidad()= super() / 2
	override method usar(objetivo){
		if (1 == 0.randomUpTo(3).roundUp()){
			objetivo.recibirHerida()
		}else{
			objetivo.morir()
		}
	}
}

class Daga inherits Armas {
	const property peligrosidad
	override method peligrosidad()=peligrosidad
}

class CuerdaDePiano inherits Armas {
	var property tensa
	override method estaBuenEstado(){
		return tensa
	}
	override method usar(objetivo){
		if(self.estaBuenEstado()){
			objetivo.morir()
		}else{
			objetivo.recibirHerida()
		}
	}
}

class Familia {
	const miembros = []
	method luto(){
		if (miembros.any({m => m.rango() == don and m.estaVivo()})){
			throw new Exception(message="Hay un Don vivo")
		}else{miembros.forEach{m => m.reorganizar()}}
		self.miembroMasPeligroso().cambiarRango(don)
		miembros.forEach({m =>m.agregarArma(new Revolver(balas = 6))})
	}
	method miembroMasPeligroso(){
		return miembros.max({m => m.intimidacion()})
	}
	method agregarFamiliar(miembro){
		miembros.add(miembro)
	}
}

class Mafioso {
	const property armas = []
	var vivo = true
	var heridas = 0 
	var property rango 
	method intimidacion() = rango.intimidacion(self)
	method estaVivo() = vivo
	method trabajar(objetivo){
		rango.trabajar(self,objetivo)
	}
	method ataqueSorpresa(familia){
		self.trabajar(familia.miembroMasPeligroso())
	}
	method reorganizar(){
		if(self.estaVivo()){
		rango.reorganizar(self)}
	}
	method esDesarmado(){
		armas.clear()
	}
	method recibirHerida(){
		if (heridas < 3){
			heridas += 1
		}else{
			self.morir()
		}

	}
	method morir(){
		vivo = false
	}
	method cambiarRango(rangoACambiar){
		rango = rangoACambiar
	}
	method agregarArma(arma){
		armas.add(arma)
	}
}

object don {
	method intimidacion(miembro){
		return miembro.armas().sum({a => a.peligrosidad()}) + 20
	}
	method trabajar(atacante,objetivo){ 
		objetivo.esDesarmado()
	}
	method reorganizar(miembro){}
}

object subjefe {
	method trabajar(atacante,objetivo){
			if(atacante.any({a => a.estaBuenEstado()})){
				atacante.armas().find({a => a.estaBuenEstado()}).usar()
			}else{
				atacante.armas().first().usar(objetivo)
			}
	}
	method intimidacion(miembro){
		return miembro.armas().sum({a => a.peligrosidad()}) * 2
	}
		method reorganizar(miembro){
		if (miembro.armas().count({a => a.estaBuenEstado()}) < 3){
			miembro.cambiarRango(soldado)
		}
	}
	
}
object soldado {
	method trabajar(atacante,objetivo){			
		atacante.armas().first().usar(objetivo)
	}
	method reorganizar(miembro){
		if (miembro.armas().count({a => a.estaBuenEstado()}) >= 2){
			miembro.cambiarRango(subjefe)
		}
	}
}



