import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      const query = this.inputTarget.value

      if (query.length > 0) {
        const url = new URL(window.location.href)
        url.searchParams.set("query", query)
        
        fetch(url, {
          headers: { "X-Requested-With": "XMLHttpRequest" }
        })
        .then(response => response.text())
        .then(html => {
          this.resultsTarget.innerHTML = html  // Only update the table content
        })
      }
    }, 300)  // Adjust delay as needed
  }

  reset() {
    this.inputTarget.value = ""  // Clear the search input

    const url = new URL(window.location.href)
    url.searchParams.delete("query")  // Remove the query param
    url.searchParams.delete("page")   // Reset pagination to the first page

    fetch(url, {
      headers: { "X-Requested-With": "XMLHttpRequest" }
    })
    .then(response => response.text())
    .then(html => {
      this.resultsTarget.innerHTML = html  // Only update the table content
    })
  }
}

