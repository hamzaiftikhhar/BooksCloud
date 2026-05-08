import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions", "authorId"]

  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)

    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.suggestionsTarget.innerHTML = ""
      this.suggestionsTarget.style.display = "none"
      return
    }

    this.timeout = setTimeout(() => {
      this.fetchAuthors(query)
    }, 300)
  }

  async fetchAuthors(query) {
    try {
      const response = await fetch(
        `/books/search_authors?q=${encodeURIComponent(query)}`,
        { headers: { Accept: "application/json" } }
      )

      const authors = await response.json()
      this.renderSuggestions(authors)

    } catch (error) {
      console.error(error)
    }
  }

  renderSuggestions(authors) {
    const box = this.suggestionsTarget
    box.innerHTML = ""

    if (authors.length === 0) {
      box.style.display = "none"
      return
    }

    authors.forEach(author => {
      const item = document.createElement("div")

      item.textContent = author.name
      item.className = "p-2 border-bottom suggestion-item"

      item.addEventListener("click", () => {
        this.inputTarget.value = author.name
        this.authorIdTarget.value = author.id
        box.style.display = "none"
      })

      box.appendChild(item)
    })

    box.style.display = "block"
  }
}