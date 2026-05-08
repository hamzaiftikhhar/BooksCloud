// js/controllers/indexe.js
import { application } from "./application"

import AuthorSearchController from "./author_search_controller"

application.register("author-search", AuthorSearchController)


import { eagerLoadControllersFrom } from "hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
