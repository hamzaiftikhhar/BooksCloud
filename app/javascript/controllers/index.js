import { application } from "./application"

import AuthorSearchController from "./author_search_controller"

application.register("author-search", AuthorSearchController)


// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
