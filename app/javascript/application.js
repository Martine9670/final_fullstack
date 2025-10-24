// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus"

// Lance l'application Stimulus
window.Stimulus = Application.start()

// Import automatique de tous les contrôleurs du dossier
const controllers = import.meta.globEager("./**/*_controller.js")

for (const path in controllers) {
  const controllerName = path
    .replace("./", "")
    .replace("_controller.js", "")
  Stimulus.register(controllerName, controllers[path].default)
}


