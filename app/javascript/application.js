import "@hotwired/turbo-rails"
import { application } from "controllers/application"
import AuthorSearchController from "controllers/author_search_controller"

application.register("author-search", AuthorSearchController)

