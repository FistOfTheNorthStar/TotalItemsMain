import { Controller } from "@hotwired/stimulus";
import consumer from "../channels/consumer"

export default class extends Controller {
    static targets = ["status"]

    connect() {
        console.log("Queue controller connected!");
        const reservationId = this.data.get("reservationId");
        if (reservationId) {
            this.cableConnect(reservationId);
        }
    }

    cableConnect(reservationId) {
        consumer.subscriptions.create(
            {
                channel: "ReservationStatusChannel",
                reservation_id: reservationId
            },

            {
                connected() {
                    console.log("Connection done!");
                },
                disconnected() {
                    console.log("Disconnected!");
                },
                received: (data) => {
                    this.updateStatus(data);
                },
            }
        )
    }

    updateStatus(data) {
        console.log("Update status runs", data);

        if (data.message) {
            if (this.hasStatusTarget) {
                this.statusTarget.textContent = data.message;
            }
            if (data.redirect_to) {
                setTimeout(() => {
                    Turbo.visit(data.redirect_to, {
                        action: "replace",
                        state: {notice: "Your status has been updated"}
                    });
                }, 3000);
            }
        }
    }
}