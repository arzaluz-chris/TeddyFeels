import Foundation
import SwiftUI

enum Emocion: String, CaseIterable, Codable, Identifiable {
    var id: String { self.rawValue }
    case feliz = "Feliz"
    case triste = "Triste"
    case enojado = "Enojado"
    case ansioso = "Ansioso"
    case estresado = "Estresado"
    case confundido = "Confundido"
    case esperanzado = "Esperanzado"
    case agradecido = "Agradecido"
    case orgulloso = "Orgulloso"

    var teddyExpression: String {
        switch self {
        case .feliz: return "🐻😊"
        case .triste: return "🐻😢"
        case .enojado: return "🐻😣"
        case .ansioso: return "🐻😰"
        case .estresado: return "🐻😵‍💫"
        case .confundido: return "🐻🤔"
        case .esperanzado: return "🐻🪄"
        case .agradecido: return "🐻🤗"
        case .orgulloso: return "🐻🏆"
        }
    }

    var emotionImageName: String {
        switch self {
        case .feliz: return "emo_happy"
        case .triste: return "emo_sad"
        case .enojado: return "emo_angry"
        case .ansioso: return "emo_anxious"
        case .estresado: return "emo_stressed"
        case .confundido: return "emo_confused"
        case .esperanzado: return "emo_hopeful"
        case .agradecido: return "emo_grateful"
        case .orgulloso: return "emo_proud"
        }
    }

    var color: Color {
        switch self {
        case .feliz: return TeddyTheme.EmotionColor.feliz
        case .triste: return TeddyTheme.EmotionColor.triste
        case .enojado: return TeddyTheme.EmotionColor.enojado
        case .ansioso: return TeddyTheme.EmotionColor.ansioso
        case .estresado: return TeddyTheme.EmotionColor.estresado
        case .confundido: return TeddyTheme.EmotionColor.confundido
        case .esperanzado: return TeddyTheme.EmotionColor.esperanzado
        case .agradecido: return TeddyTheme.EmotionColor.agradecido
        case .orgulloso: return TeddyTheme.EmotionColor.orgulloso
        }
    }

    var backgroundColor: Color {
        switch self {
        case .feliz: return TeddyTheme.EmotionColor.felizBg
        case .triste: return TeddyTheme.EmotionColor.tristeBg
        case .enojado: return TeddyTheme.EmotionColor.enojadoBg
        case .ansioso: return TeddyTheme.EmotionColor.ansiosoBg
        case .estresado: return TeddyTheme.EmotionColor.estresadoBg
        case .confundido: return TeddyTheme.EmotionColor.confundidoBg
        case .esperanzado: return TeddyTheme.EmotionColor.esperanzadoBg
        case .agradecido: return TeddyTheme.EmotionColor.agradecidoBg
        case .orgulloso: return TeddyTheme.EmotionColor.orgullosoBg
        }
    }

    var valorBienestar: Double {
        switch self {
        case .feliz: return 10.0
        case .triste: return 2.0
        case .enojado: return 1.0
        case .ansioso: return 2.0
        case .estresado: return 3.0
        case .confundido: return 4.0
        case .esperanzado: return 9.0
        case .agradecido: return 3.0
        case .orgulloso: return 8.0
        }
    }

    var bearImageName: String {
        switch self {
        case .feliz: return "oso_Feliz"
        case .triste: return "oso_Triste"
        case .enojado: return "oso_Enojado"
        case .ansioso: return "oso_Feliz"  // no specific bear, use happy
        case .estresado: return "oso_Doctor"
        case .confundido: return "oso_Feliz"  // no specific bear
        case .esperanzado: return "oso_Positivo"
        case .agradecido: return "oso_Bienvenida"
        case .orgulloso: return "oso_Metas"
        }
    }

    func displayName(for character: BearVoiceService.Character) -> String {
        guard character == .dani else { return rawValue }
        switch self {
        case .feliz: return "Feliz"
        case .triste: return "Triste"
        case .enojado: return "Enojada"
        case .ansioso: return "Ansiosa"
        case .estresado: return "Estresada"
        case .confundido: return "Confundida"
        case .esperanzado: return "Esperanzada"
        case .agradecido: return "Agradecida"
        case .orgulloso: return "Orgullosa"
        }
    }

    func imageName(for character: BearVoiceService.Character) -> String {
        switch character {
        case .dan:
            switch self {
            case .feliz: return "osito_feliz"
            case .triste: return "osito_triste"
            case .enojado: return "osito_enojado"
            case .ansioso: return "osito_ansioso"
            case .estresado: return "osito_estresado"
            case .confundido: return "osito_confundido"
            case .esperanzado: return "osito_esperanzado"
            case .agradecido: return "osito_agradecido"
            case .orgulloso: return "osito_orgulloso"
            }
        case .dani:
            switch self {
            case .feliz: return "osita_feliz"
            case .triste: return "osita_triste"
            case .enojado: return "osita_enojada"
            case .ansioso: return "osita_ansiosa"
            case .estresado: return "osita_estresada"
            case .confundido: return "osita_confundida"
            case .esperanzado: return "osita_esperanzada"
            case .agradecido: return "osita_agradecida"
            case .orgulloso: return "osita_orgullosa"
            }
        }
    }

    var accionesCriticas: [String] {
        switch self {
        case .feliz:
            return ["¡Haz un baile de victoria!", "Dibuja qué te hizo sonreír", "Comparte tu alegría con alguien", "Escribe una carta de gracias", "Salta 10 veces de emoción", "Llama a un amigo y cuéntale tu buena noticia", "Haz una lista de cosas positivas del día", "Celebra con una canción favorita", "Da un abrazo a alguien cercano", "Planta una semilla como símbolo de crecimiento"]
        case .triste:
            return ["Abraza a tu peluche favorito (Co-regulación)", "Bebe agua fría a sorbos pequeños (Estimula el nervio vago)", "Dibuja tu tristeza como una nube que pasa", "Busca a un adulto y dile: 'Necesito un abrazo'", "Lava tu carita con agua tibia", "Llama a la línea de ayuda infantil en México: 55 5658 1111 (SAPTEL para niños)", "Habla con un familiar de confianza sobre lo que sientes", "Escucha música suave y cierra los ojos", "Escribe una carta a ti mismo del futuro", "Recuerda un recuerdo feliz y dibújalo", "Practica gratitud: nombra 3 cosas buenas", "Camina al aire libre si es posible", "Usa la técnica de mindfulness: enfócate en tu respiración", "Contacta a un psicólogo escolar si estás en la escuela", "Recuerda: la tristeza pasa, como las nubes"]
        case .enojado:
            return ["Técnica de la tortuga: cruza tus brazos y respira", "Aprieta una almohada con fuerza (Descarga motora)", "Dibuja garabatos muy fuertes en un papel", "Cuenta del 10 al 0 muy lento", "Camina como un gigante pesado para soltar tensión", "Respira profundamente 5 veces", "Escribe lo que te enoja y rómpelo", "Haz ejercicio: salta o corre en el lugar", "Habla con un adulto: 'Estoy enojado porque...'", "Usa la línea de emergencia si es grave: 911 en México", "Escucha sonidos calmantes como olas del mar", "Practica el perdón: di 'lo dejo ir'", "Dibuja tu enojo como un monstruo y hazlo pequeño", "Toma un baño tibio para relajar músculos", "Recuerda: el enojo es normal, pero controlarlo te hace fuerte"]
        case .ansioso:
            return ["Busca 5 cosas que puedas ver (Técnica de anclaje)", "Respira como si inflaras un globo gigante", "Siente tus pies tocando el suelo muy firme", "Toca algo suave como una manta", "Repite: 'Teddy está conmigo, estoy a salvo'", "Llama a la línea de apoyo psicológico: 55 5259 8121 (Línea de la Vida en México)", "Habla con un amigo o familiar: 'Me siento ansioso'", "Haz la técnica 4-7-8 de respiración", "Escribe tus preocupaciones y guárdalas en una caja", "Visualiza un lugar seguro en tu mente", "Come algo saludable como una fruta", "Escucha una meditación guiada para niños", "Haz yoga simple: pose del árbol", "Recuerda: la ansiedad es como una alarma falsa, puedes apagarla", "Busca ayuda profesional si persiste"]
        case .estresado:
            return ["Estírate como un gato al despertar", "Haz una sola tarea pequeña a la vez", "Escucha sonidos de lluvia o pajaritos", "Cierra los ojos por 1 minuto", "Pide ayuda si algo es muy difícil", "Organiza tu espacio de estudio", "Toma un descanso de 5 minutos cada hora", "Bebe té de manzanilla para calmar", "Camina 10 minutos al aire libre", "Llama a SAPTEL: 55 5658 1111 para consejos", "Practica mindfulness: enfócate en el presente", "Haz una lista de prioridades", "Duerme lo suficiente: 9-11 horas para niños", "Come alimentos ricos en omega-3 como nueces", "Recuerda: el estrés es temporal, pide apoyo"]
        case .confundido:
            return ["Dibuja tus ideas para verlas mejor", "Haz una pausa y juega un ratito", "Pregúntale a alguien: '¿Me explicas de nuevo?'", "No tienes que saber todo hoy", "Toma una siesta corta", "Escribe preguntas y busca respuestas seguras", "Habla con un maestro o padre", "Divide el problema en partes pequeñas", "Lee un libro simple sobre el tema", "Usa recursos educativos como Khan Academy para niños", "Respira y di: 'Puedo aprender paso a paso'", "Dibuja un mapa de tus pensamientos", "Toma un descanso y regresa después", "Pide consejo a un amigo", "Recuerda: estar confundido es el primer paso para aprender"]
        case .esperanzado:
            return ["Establece una meta pequeña y alcánzala", "Comparte tu motivación con un amigo", "Haz una lista de tareas y táchalas", "Escucha música energética", "Haz ejercicio para mantener el flujo", "Visualiza el éxito", "Recompénsate por avances", "Lee historias inspiradoras", "Ayuda a alguien más", "Mantén un diario de logros", "Camina con energía", "Practica afirmaciones positivas", "Organiza tu espacio", "Duerme bien para mantener la motivación", "Come saludable para energía sostenida"]
        case .agradecido:
            return ["Escribe una carta de gracias a alguien", "Comparte tu gratitud con un amigo", "Haz una lista de 5 cosas por las que estás agradecido", "Da un abrazo de agradecimiento", "Ayuda a alguien como forma de agradecer", "Medita en momentos positivos", "Crea un frasco de gratitud", "Dibuja algo que aprecias", "Celebra con una actividad favorita", "Reflexiona en cómo otros te han ayudado", "Practica mindfulness de gratitud", "Envía un mensaje positivo", "Pasa tiempo en la naturaleza", "Lee citas sobre gratitud", "Recuerda momentos de bondad recibida"]
        case .orgulloso:
            return ["Celebra con un pequeño premio", "Comparte tu logro con familia", "Escribe qué hiciste bien", "Dibuja un trofeo para ti", "Haz una pose de victoria", "Ayuda a alguien con tu experiencia", "Reflexiona en lo aprendido", "Pon una canción de celebración", "Da gracias a quienes te ayudaron", "Planea el siguiente paso", "Mira fotos de logros pasados", "Practica humildad con orgullo", "Escribe una carta de auto-felicitación", "Comparte en redes si es apropiado", "Recuerda: el orgullo te motiva más"]
        }
    }

    var recomendaciones: [Accion] {
        switch self {
        case .feliz:
            return [
                Accion(texto: "Comparte alegría", icono: "heart.fill", comoHacerlo: "Escribe un mensaje lindo a un amigo."),
                Accion(texto: "Diario de Éxitos", icono: "star.fill", comoHacerlo: "Anota qué cosa tan genial pasó hoy."),
                Accion(texto: "Baile de Victoria", icono: "music.note", comoHacerlo: "Pon tu canción favorita y celebra."),
                Accion(texto: "Cumplido al azar", icono: "mouth", comoHacerlo: "Dile algo positivo a alguien."),
                Accion(texto: "Foto de felicidad", icono: "camera", comoHacerlo: "Toma una foto de algo que te guste."),
                Accion(texto: "Saborear", icono: "fork.knife", comoHacerlo: "Come algo rico sintiendo todo el sabor."),
                Accion(texto: "Planear", icono: "calendar", comoHacerlo: "Piensa en algo divertido para mañana."),
                Accion(texto: "Regalo pequeño", icono: "gift", comoHacerlo: "Hazte un dibujo de premio."),
                Accion(texto: "Autoafirmación", icono: "person.fill.checkmark", comoHacerlo: "Mírate al espejo y di: '¡Soy genial!'."),
                Accion(texto: "Cantar", icono: "mic.fill", comoHacerlo: "Canta muy fuerte tu canción favorita.")
            ]
        case .triste:
            return [
                Accion(texto: "Carta de desahogo", icono: "pencil", comoHacerlo: "Escribe por qué estás triste y Teddy lo guardará."),
                Accion(texto: "Ducha caliente", icono: "shower", comoHacerlo: "Siente como el agua te abraza."),
                Accion(texto: "Caminata suave", icono: "figure.walk", comoHacerlo: "Camina un poquito en casa."),
                Accion(texto: "Abrazo Teddy", icono: "person.fill", comoHacerlo: "Abraza una almohada muy fuerte."),
                Accion(texto: "Té reconfortante", icono: "cup.and.saucer", comoHacerlo: "Bebe algo calientito con calma."),
                Accion(texto: "Llorar es sanar", icono: "drop", comoHacerlo: "No pasa nada si lloras, limpia el alma."),
                Accion(texto: "Música suave", icono: "music.note.list", comoHacerlo: "Escucha música que te de paz."),
                Accion(texto: "Luz natural", icono: "sun.max", comoHacerlo: "Mira por la ventana un ratito."),
                Accion(texto: "Hacer la cama", icono: "bed.double", comoHacerlo: "Acomodar tu cuarto ayuda a tu mente."),
                Accion(texto: "Ver fotos", icono: "photo.on.rectangle", comoHacerlo: "Mira fotos de cuando estabas muy contento.")
            ]
        case .enojado:
            return [
                Accion(texto: "Grito silenciado", icono: "mouth.fill", comoHacerlo: "Grita fuerte contra una almohada."),
                Accion(texto: "Ejercicio intenso", icono: "bolt.fill", comoHacerlo: "Haz 10 saltos muy altos."),
                Accion(texto: "Romper papel", icono: "doc.fill", comoHacerlo: "Toma un papel que no sirva y hazlo trozos."),
                Accion(texto: "Agua fría", icono: "drop.fill", comoHacerlo: "Moja tu cara para refrescar tu mente."),
                Accion(texto: "Tiempo fuera", icono: "hand.raised", comoHacerlo: "Cuenta hasta 10 antes de hablar."),
                Accion(texto: "Escribir rabia", icono: "strikethrough", comoHacerlo: "Escribe qué te enojó y táchalo fuerte."),
                Accion(texto: "Respiración de Fuego", icono: "flame", comoHacerlo: "Saca el aire fuerte por la nariz."),
                Accion(texto: "Cambiar de aire", icono: "door.right.hand.open", comoHacerlo: "Vete a otro cuarto un momento."),
                Accion(texto: "Música con energía", icono: "guitars", comoHacerlo: "Escucha música movida para soltar el enojo."),
                Accion(texto: "Relajación muscular", icono: "figure.arms.open", comoHacerlo: "Aprieta tus manos 5 segundos y suelta.")
            ]
        case .ansioso:
            return [
                Accion(texto: "Respiración 4-7-8", icono: "wind", comoHacerlo: "Toma aire en 4, mantén 7 y suelta en 8."),
                Accion(texto: "Técnica 5-4-3-2-1", icono: "eye", comoHacerlo: "Nombra 5 cosas que veas ahora."),
                Accion(texto: "Pies en tierra", icono: "pawprint", comoHacerlo: "Siente el piso bajo tus pies."),
                Accion(texto: "Manta pesada", icono: "square.fill", comoHacerlo: "Tápate con una cobija para sentirte seguro."),
                Accion(texto: "Música ambiental", icono: "sparkles", comoHacerlo: "Escucha sonidos del bosque o mar."),
                Accion(texto: "Oler algo rico", icono: "leaf", comoHacerlo: "Busca un olor que te guste mucho."),
                Accion(texto: "Abrazo de mariposa", icono: "hands.clap", comoHacerlo: "Cruza tus manos y date golpecitos en los hombros."),
                Accion(texto: "Cero cafeína", icono: "cup.and.saucer.fill", comoHacerlo: "Bebe agüita, no refrescos hoy."),
                Accion(texto: "Dibujar garabatos", icono: "scribble", comoHacerlo: "Dibuja sin pensar, solo mueve el lápiz."),
                Accion(texto: "Mantras", icono: "person.and.arrow.left.and.arrow.right", comoHacerlo: "Dite: 'Todo va a estar bien'.")
            ]
        case .estresado:
            return [
                Accion(texto: "Lista de 3", icono: "list.bullet", comoHacerlo: "Solo piensa en las 3 cosas más importantes."),
                Accion(texto: "Estiramiento", icono: "figure.flexibility", comoHacerlo: "Mueve tu cuello y brazos como liga."),
                Accion(texto: "Pomodoro", icono: "timer", comoHacerlo: "Estudia 25 min y juega 5."),
                Accion(texto: "Ver naturaleza", icono: "leaf", comoHacerlo: "Mira una planta o el cielo azul."),
                Accion(texto: "Limpieza Flash", icono: "sparkles", comoHacerlo: "Ordena tus juguetes por 5 minutos."),
                Accion(texto: "Delegar", icono: "person.2", comoHacerlo: "Pide ayuda a mamá o papá."),
                Accion(texto: "Masaje de sienes", icono: "brain", comoHacerlo: "Toca tus sienes suavemente en círculos."),
                Accion(texto: "Desconectar avisos", icono: "bell.slash", comoHacerlo: "Deja la tablet un ratito a un lado."),
                Accion(texto: "Baño de pies", icono: "water.waves", comoHacerlo: "Pon tus pies en agua tibia."),
                Accion(texto: "Escuchar ASMR", icono: "ear", comoHacerlo: "Escucha sonidos relajantes de lluvia.")
            ]
        case .confundido:
            return [
                Accion(texto: "Mapa mental", icono: "arrow.triangle.branch", comoHacerlo: "Dibuja tus ideas con flechas."),
                Accion(texto: "Dormir 20 min", icono: "moon.zzz", comoHacerlo: "Una siestita ayuda a pensar mejor."),
                Accion(texto: "Hablar solo", icono: "mouth", comoHacerlo: "Explica lo que te pasa en voz alta."),
                Accion(texto: "Cero Google", icono: "nosign", comoHacerlo: "No busques respuestas un rato."),
                Accion(texto: "Paso pequeño", icono: "shoeprints.fill", comoHacerlo: "Haz solo una cosita fácil ahora."),
                Accion(texto: "Priorizar", icono: "1.circle", comoHacerlo: "Elige lo más fácil primero."),
                Accion(texto: "Cambiar entorno", icono: "map", comoHacerlo: "Vete a jugar o estudiar al patio."),
                Accion(texto: "Pedir consejo", icono: "person.fill.questionmark", comoHacerlo: "Pregúntale a alguien qué opina."),
                Accion(texto: "Meditar vacío", icono: "stop.circle", comoHacerlo: "Trata de no pensar en nada 5 minutos."),
                Accion(texto: "Leer instrucciones", icono: "doc.text", comoHacerlo: "Lee de nuevo qué hay que hacer.")
            ]
        case .esperanzado:
            return [
                Accion(texto: "Establece metas", icono: "target", comoHacerlo: "Escribe una meta pequeña para hoy."),
                Accion(texto: "Ejercicio rápido", icono: "figure.run", comoHacerlo: "Haz 10 saltos para mantener la energía."),
                Accion(texto: "Música motivadora", icono: "music.note", comoHacerlo: "Escucha una canción que te impulse."),
                Accion(texto: "Comparte planes", icono: "person.2", comoHacerlo: "Dile a alguien qué vas a lograr."),
                Accion(texto: "Visualiza", icono: "eye", comoHacerlo: "Imagina logrando tu objetivo."),
                Accion(texto: "Lista de tareas", icono: "list.bullet", comoHacerlo: "Haz una lista y empieza por lo fácil."),
                Accion(texto: "Recompensa", icono: "gift", comoHacerlo: "Piensa en un premio para después."),
                Accion(texto: "Afirmaciones", icono: "quote.bubble", comoHacerlo: "Dite: 'Puedo hacerlo'."),
                Accion(texto: "Ayuda a otros", icono: "hand.raised", comoHacerlo: "Motiva a un amigo."),
                Accion(texto: "Reflexiona", icono: "brain", comoHacerlo: "Piensa en logros pasados.")
            ]
        case .agradecido:
            return [
                Accion(texto: "Carta de gracias", icono: "pencil", comoHacerlo: "Escribe una carta de gracias a alguien."),
                Accion(texto: "Comparte gratitud", icono: "person.2", comoHacerlo: "Dile a alguien por qué le agradeces."),
                Accion(texto: "Lista de gratitud", icono: "list.bullet", comoHacerlo: "Anota 5 cosas que aprecias."),
                Accion(texto: "Abrazo de gracias", icono: "heart", comoHacerlo: "Da un abrazo a alguien especial."),
                Accion(texto: "Ayuda a otros", icono: "hand.raised", comoHacerlo: "Haz algo amable como agradecimiento."),
                Accion(texto: "Meditación", icono: "person", comoHacerlo: "Medita en momentos positivos."),
                Accion(texto: "Frasco de gratitud", icono: "archivebox.fill", comoHacerlo: "Escribe notas y guárdalas."),
                Accion(texto: "Dibujo", icono: "paintbrush", comoHacerlo: "Dibuja algo que te hace sentir agradecido."),
                Accion(texto: "Celebrar", icono: "music.note", comoHacerlo: "Celebra con una actividad favorita."),
                Accion(texto: "Reflexionar", icono: "brain", comoHacerlo: "Piensa en cómo otros te han ayudado.")
            ]
        case .orgulloso:
            return [
                Accion(texto: "Celebra", icono: "trophy", comoHacerlo: "Haz un baile de victoria."),
                Accion(texto: "Comparte", icono: "person.2", comoHacerlo: "Dile a tu familia."),
                Accion(texto: "Escribe logro", icono: "pencil", comoHacerlo: "Anota qué hiciste."),
                Accion(texto: "Dibuja trofeo", icono: "paintbrush", comoHacerlo: "Dibuja un premio."),
                Accion(texto: "Pose victoria", icono: "figure.arms.open", comoHacerlo: "Levanta los brazos."),
                Accion(texto: "Ayuda a otros", icono: "hand.raised", comoHacerlo: "Comparte tu conocimiento."),
                Accion(texto: "Reflexiona", icono: "brain", comoHacerlo: "Piensa qué aprendiste."),
                Accion(texto: "Música celebración", icono: "music.note", comoHacerlo: "Pon una canción feliz."),
                Accion(texto: "Gracias", icono: "heart", comoHacerlo: "Da gracias a ayudantes."),
                Accion(texto: "Próximo paso", icono: "arrow.forward", comoHacerlo: "Planea lo siguiente.")
            ]
        }
    }
}
