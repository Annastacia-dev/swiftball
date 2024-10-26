import { Controller } from "@hotwired/stimulus";
import html2canvas from "html2canvas";

export default class extends Controller {
  static targets = ["download", "share", "attempt"]

  downloadImage() {
    html2canvas(this.attemptTarget, { scale: 2 }).then(canvas => {
      const link = document.createElement("a");
      link.href = canvas.toDataURL("image/png");
      link.download = `${this.attemptTarget.id}-predictions.png`;
      link.click();
    });
  }

  shareImage() {
    html2canvas(this.attemptTarget).then(canvas => {
      canvas.toBlob(blob => {
        const file = new File([blob], `${this.attemptTarget.id}-predictions.png`, { type: "image/png" });
        if (navigator.canShare && navigator.canShare({ files: [file] })) {
          navigator.share({
            files: [file],
            title: "My Predictions",
            text: "Check out my predictions!",
          });
        } else {
          alert("Sharing is not supported on this browser.");
        }
      });
    });
  }
}
