//import  Controller  from "@hotwired/stimulus"
//
// export class QueueStatusController extends Controller {
//     static targets = ["status", "position"]
//
//     connect() {
//         console.log("Controller connected!")
//         this.initialPosition = this.element.dataset.queueStatusPosition
//
//         this.positionTarget.textContent = this.initialPosition
//         console.log("Initial position:", this.initialPosition)
//         this.checkQueuePosition()
//     }
//
//     disconnect() {
//         clearTimeout(this.timeout)
//     }
//
//     checkQueuePosition() {
//          console.log("here wer ARE")
//          const reservationId = this.element.dataset.queueStatusReservationId;
//
//     if (!reservationId) {
//         console.error("Reservation ID is missing.");
//         this.displayError("Missing Reservation ID");
//         return;
//     }
//
//     const url = `/reservations/${reservationId}/queue_positions/ping`;
//
//     fetch(url, {
//         method: "POST",
//         headers: {
//             "Content-Type": "application/json",
//             "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
//         },
//         body: JSON.stringify({ position: this.initialPosition })
//     })
//         .then(response => {
//             if (!response.ok) {
//                 throw new Error(`HTTP error ${response.status}`);
//             }
//             return response.json();
//         })
//         .then(data => {
//             if (data.status === 'ready') {
//                 window.location.href = data.redirect_url;
//             } else if (data.status === 'error') {
//                 this.displayError(data.message || "An error occurred.");
//             } else {
//                 this.positionTarget.textContent = data.position;
//                 this.timeout = setTimeout(() => this.checkQueuePosition(), 5000);
//             }
//         })
//         .catch(error => {
//             console.error("Error fetching queue status:", error);
//             this.displayError("Error checking queue position. Please try again later.");
//             this.timeout = setTimeout(() => this.checkQueuePosition(), 10000);
//         });
// }
//
// displayError(message) {
//     if (this.hasStatusTarget) {
//         this.statusTarget.textContent = message;
//     } else {
//         console.error("Status target is missing. Cannot display error message.", message);
//     }
//     }
// }


import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        this.updateStatus()
        console.log("Queue controller connected!");
    }

    updateStatus() {
        console.log("Update status runs");
    }
}