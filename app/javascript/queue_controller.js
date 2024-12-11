import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["status", "position"]

    connect() {
        this.checkQueuePosition()
    }

    checkQueuePosition() {
        const token = this.element.dataset.token

        fetch(`/queue_status/${token}`)
            .then(response => response.json())
            .then(data => {
                if (data.status === 'ready') {
                    window.location.href = data.redirect_url
                } else {
                    this.positionTarget.textContent = data.position
                    setTimeout(() => this.checkQueuePosition(), 5000)
                }
            })
    }
}