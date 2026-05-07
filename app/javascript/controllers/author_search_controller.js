import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions"]

  connect() {
    console.log("AuthorSearch controller connected 🚀")

    this.debounceTimer = null
    this.debounceDelay = 300

    document.addEventListener("click", this.handleClickOutside.bind(this))
  }

  disconnect() {
    clearTimeout(this.debounceTimer)
    document.removeEventListener("click", this.handleClickOutside.bind(this))
  }

  search = (event) => {
    const query = event.target.value.trim()

    clearTimeout(this.debounceTimer)

    if (query.length < 1) {
      this.suggestionsTarget.style.display = "none"
      return
    }

    this.debounceTimer = setTimeout(() => {
      this.fetchAuthors(query)
    }, this.debounceDelay)
  }

  fetchAuthors(query) {
    fetch(`/books/search_authors?q=${encodeURIComponent(query)}`, {
      headers: { Accept: "application/json" }
    })
      .then(res => res.json())
      .then(data => this.renderSuggestions(data, query))
      .catch(err => console.error(err))
  }

  renderSuggestions(authors, query) {
    const box = this.suggestionsTarget
    box.innerHTML = ""

    if (!authors.length) {
      box.style.display = "none"
      return
    }

    authors.forEach(author => {
      const div = document.createElement("div")
      div.textContent = author.name

      div.style.cursor = "pointer"
      div.style.padding = "8px"

      div.addEventListener("click", () => {
        this.selectAuthor(author)
      })

      box.appendChild(div)
    })

    box.style.display = "block"
  }

  selectAuthor(author) {
    this.inputTarget.value = author.name

    document.getElementById("selected_author_id").value = author.id

    this.suggestionsTarget.style.display = "none"
  }

  handleClickOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.suggestionsTarget.style.display = "none"
    }
  }
}