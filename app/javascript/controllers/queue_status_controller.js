import { Controller } from "@hotwired/stimulus";
//import consumer from "../channels/consumer"

import { createConsumer } from "@rails/actioncable"

 export default class extends Controller {
     static targets = ["status"]


    connect() {
        this.startCounter()
        const reservationId = this.data.get("reservationId");
        if (reservationId) {
            this.channel = createConsumer().subscriptions.create({
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
                },
            )
        }
    }

    startCounter(){
         // TODO, two Stimulus.js functions interfered
         // with each other and dropped action cable, bubble-gum fast fix
         function delayPromise(ms) {
             return new Promise(resolve => setTimeout(resolve, ms));
         }

         async function delay() {
             await delayPromise(5000);
         }
         function moveToFront(){
             window.location = window.location.origin
         }
         function startCountdown(duration, display) {
             let timer = duration, minutes, seconds;
             setInterval(function () {
                 minutes = parseInt(timer / 60, 10);
                 seconds = parseInt(timer % 60, 10);

                 minutes = minutes < 10 ? "0" + minutes : minutes;
                 seconds = seconds < 10 ? "0" + seconds : seconds;

                 display.textContent = minutes + ":" + seconds;

                 if (--timer < 0) {
                     timer = 0; // Prevent negative values
                     display.textContent = "EXPIRED";
                     delay().then(moveToFront)
                 }
             }, 1000);
         }

         let fiveMinutes =  60 * 5; // Convert 5 minutes to seconds
         let display = document.querySelector('#expires'); // Use querySelector for better compatibility
         startCountdown(fiveMinutes, display);
     }

    disconnect() {
        this.channel.unsubscribe();
    }
}
