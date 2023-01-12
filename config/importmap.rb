# Pin npm packages by running ./bin/importmap

pin "application"
    pin "@hotwired/turbo-rails", to: "turbo.min.js"
    pin "@hotwired/stimulus", to: "stimulus.min.js"
    pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.3/dist/jquery.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/lib/index.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.2.3/dist/js/bootstrap.esm.js"

#pin "bootstrap_css", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
#pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
#pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2"


