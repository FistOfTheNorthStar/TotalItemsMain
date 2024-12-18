import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["expires"]

    connect() {
        const expirationTime = parseInt(this.data.get("minutes"));
        if (expirationTime) {
            this.startCountdown(expirationTime);
        }
    }

    startCountdown(totalSeconds) {
        this.countdown = setInterval(() => {
            const minutes = Math.floor(totalSeconds / 60);
            const seconds = totalSeconds % 60;

            this.expiresTarget.textContent =
                `${minutes}:${seconds.toString().padStart(2, '0')}`;

            if (totalSeconds <= 0) {
                // TODO clear quantity back to item
                Turbo.visit("/", {
                    action: "replace",
                    state: {alert: "Reservation time expired!"}
                });
                clearInterval(this.countdown);
                return;
            }

            totalSeconds--;
        }, 1000);
    }

    disconnect() {
        if (this.countdown) {
            clearInterval(this.countdown);
        }
    }
}