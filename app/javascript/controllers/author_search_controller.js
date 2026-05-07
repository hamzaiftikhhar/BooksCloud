  import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "suggestions", "authorId" ]

  connect() {
    console.log("AuthorSearch controller connected ✓")
    this.debounceTimer = null
    this.debounceDelay = 250
  }

  search(event) {
    clearTimeout(this.debounceTimer)

    const query = this.inputTarget.value.trim()
    console.log(`Search triggered: "${query}"`)
    
    if (query.length < 2) {
      console.log("Query too short, hiding suggestions")
      this.suggestionsTarget.style.display = 'none'
      return
    }

    console.log(`Debouncing for ${this.debounceDelay}ms...`)
    this.debounceTimer = setTimeout(() => {
      console.log(`Fetching authors for: "${query}"`)
      this.fetchAuthors(query)
    }, this.debounceDelay)
  }

  fetchAuthors(query) {
    const url = `/books/search_authors?q=${encodeURIComponent(query)}`
    console.log(`Fetching from: ${url}`)
    
    fetch(url, {
      headers: { Accept: "application/json" }
    })
      .then(r => {
        console.log(`Response status: ${r.status}`)
        return r.json()
      })
      .then(data => {
        console.log(`Authors data:`, data)
        this.renderSuggestions(data)
      })
      .catch(err => {
        console.error("Fetch error:", err)
        this.suggestionsTarget.style.display = 'none'
      })
  }

  renderSuggestions(authors) {
    const box = this.suggestionsTarget
    box.innerHTML = ""

    if (!authors || !authors.length) {
      console.log("No authors found")
      box.style.display = "none"
      return
    }

    console.log(`Rendering ${authors.length} suggestions`)
    authors.forEach(a => {
      const div = document.createElement("div")
      div.textContent = a.name
      div.style.cursor = "pointer"
      div.className = 'p-2 suggestion-item border-bottom'
      div.style.padding = '8px 12px'
      div.style.borderBottom = '1px solid #ddd'

      div.onmouseover = () => { div.style.backgroundColor = '#f5f5f5' }
      div.onmouseout = () => { div.style.backgroundColor = 'transparent' }

      div.onclick = () => {
        console.log(`Selected author: ${a.name} (ID: ${a.id})`)
        this.inputTarget.value = a.name
        this.authorIdTarget.value = a.id
        box.style.display = "none"
      }

      box.appendChild(div)
    })

    box.style.display = "block"
  }
}