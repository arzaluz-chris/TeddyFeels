import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: TeddyTheme.spacingLG) {
                    section(title: "Resumen", content: "TeddyFeels es una aplicación de bienestar emocional diseñada para niños. Tu privacidad y seguridad son nuestra máxima prioridad. Esta app NO recopila, almacena ni comparte información personal con terceros.")

                    section(title: "Datos que se almacenan en tu dispositivo", items: [
                        "Entradas del diario (texto y notas de voz)",
                        "Metas personales",
                        "Emociones seleccionadas y puntaje de bienestar",
                        "PIN de acceso y preguntas de rescate",
                        "Preferencia de personaje (Dan o Dani)"
                    ])

                    section(title: "Datos que NO recopilamos", items: [
                        "Nombre, correo electrónico ni datos de contacto",
                        "Ubicación ni datos de localización",
                        "Fotos ni acceso a la galería",
                        "Identificadores de publicidad (IDFA)",
                        "Datos de navegación ni historial",
                        "Ningún dato se envía a servidores externos"
                    ])

                    section(title: "Almacenamiento local", content: "Todos los datos de TeddyFeels se almacenan exclusivamente en tu dispositivo usando tecnologías seguras de Apple (SwiftData y UserDefaults). Ningún dato sale de tu dispositivo.")

                    section(title: "Servicios de terceros", content: "TeddyFeels no utiliza servicios de análisis, publicidad ni seguimiento de terceros. Las únicas dependencias externas son bibliotecas de interfaz visual (ConfettiSwiftUI, Pow, Vortex) que no recopilan datos.")

                    section(title: "Micrófono y reconocimiento de voz", content: "TeddyFeels solicita acceso al micrófono únicamente para grabar notas de voz en el diario. El reconocimiento de voz se procesa localmente en el dispositivo usando la tecnología de Apple (Speech Framework). Ninguna grabación se envía a servidores externos.")

                    section(title: "Seguridad", content: "El diario y las metas están protegidos con un PIN de 4 dígitos creado por el niño. Después de 5 intentos fallidos, los datos se borran automáticamente para proteger la privacidad.")

                    section(title: "Eliminación de datos", content: "Para eliminar todos los datos de TeddyFeels, desinstala la aplicación de tu dispositivo. Todos los datos almacenados localmente se eliminarán automáticamente.")

                    section(title: "Derechos de los padres", content: "Los padres o tutores pueden revisar y eliminar los datos de su hijo en cualquier momento desinstalando la aplicación. No se requiere solicitud especial ya que todos los datos son locales.")

                    section(title: "Cumplimiento", content: "TeddyFeels cumple con la Ley de Protección de la Privacidad Infantil en Línea (COPPA), el Reglamento General de Protección de Datos (GDPR) y las directrices de la categoría Kids del App Store de Apple.")

                    section(title: "Contacto", content: "Si tienes preguntas sobre esta política de privacidad, contacta a: teddyfeels@proyectoswalden.com")

                    Text("Última actualización: Marzo 2026")
                        .font(TeddyTheme.caption())
                        .foregroundColor(TeddyTheme.textTertiary)
                        .padding(.top, TeddyTheme.spacingMD)
                }
                .padding(.horizontal, TeddyTheme.screenPadding)
                .iPadReadableWidth()
                .padding(.top, TeddyTheme.spacingMD)
                .padding(.bottom, 100)
            }
            .background { TeddyAnimatedBackground().ignoresSafeArea() }
            .navigationTitle("Política de Privacidad")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                        .font(TeddyTheme.bodyBold())
                        .foregroundColor(TeddyTheme.primary)
                }
            }
        }
    }

    private func section(title: String, content: String) -> some View {
        TeddyCard {
            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                Text(title)
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.primary)
                Text(content)
                    .font(TeddyTheme.body())
                    .foregroundColor(TeddyTheme.textSecondary)
                    .lineSpacing(4)
            }
        }
    }

    private func section(title: String, items: [String]) -> some View {
        TeddyCard {
            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                Text(title)
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.primary)
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: TeddyTheme.spacingSM) {
                        Circle()
                            .fill(TeddyTheme.primary)
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)
                        Text(item)
                            .font(TeddyTheme.body())
                            .foregroundColor(TeddyTheme.textSecondary)
                    }
                }
            }
        }
    }
}
