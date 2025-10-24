
import { Application } from "@hotwired/stimulus"

// 🔥 Initialisation propre de Stimulus
const application = Application.start()
window.Stimulus = application

// ---
// 📦 Importation manuelle des contrôleurs Stimulus
// (tu les ajoutes ici au fur et à mesure)
import HelloController from "./hello_controller.js"

// 🔗 Enregistrement des contrôleurs
application.register("hello", HelloController)

// ✅ Stimulus est initialisé avec esbuild (Rails 8)
console.log("✅ Stimulus initialisé avec esbuild (Rails 8)")
