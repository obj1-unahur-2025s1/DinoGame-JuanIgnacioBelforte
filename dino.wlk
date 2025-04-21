import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(13)
		game.height(8)
		game.addVisual(suelo)
		cactus.posicionar()
		game.addVisual(cactus)
		game.addVisual(dino)
		game.boardGround("arena.png")

		//game.addVisual(reloj)
	
		keyboard.space().onPressDo{ self.jugar()}
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
	}
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
	}
}

object gameOver {
	method position() = game.center()
	method image() = "gameover.png"
	

}

object reloj {
	var tiempo = 0
	
	method tiempo() = tiempo

	// TODO method image() 
	// TODO method position() 
	
	method pasarTiempo() {
		tiempo = tiempo + 1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(1000,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object cactus {
	 
	var position = null

	method image() = "cactus.png"
	method position() = position
	
	method posicionar() {
		position = game.at(game.width()-1,suelo.position().y())
	}

	method iniciar(){
		self.posicionar()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			self.posicionar()
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{
	method position() = game.origin().up(1)
	method image() = "suelo.png"
}

object dino {
	var vivo = false
	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position

	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	method subir(){
		position = position.up(1)
	}
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!" + " tiempo: " + reloj.tiempo())
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}
