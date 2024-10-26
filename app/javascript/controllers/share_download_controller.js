import { Controller } from "@hotwired/stimulus";
import html2canvas from "html2canvas";

export default class extends Controller {
  static targets = ["download", "share", "attempt"];

  loadImageAsBase64 = (url) => {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.crossOrigin = "anonymous";
      img.src = url;
      img.onload = () => {
        const canvas = document.createElement("canvas");
        canvas.width = img.width;
        canvas.height = img.height;
        const ctx = canvas.getContext("2d");
        ctx.drawImage(img, 0, 0);
        resolve(canvas.toDataURL("image/png"));
      };
      img.onerror = (err) => reject(err);
    });
  };

  async downloadImage() {
    const images = this.attemptTarget.querySelectorAll("img");

    for (const img of images) {
      try {
        const base64Data = await this.loadImageAsBase64(img.src);
        img.src = base64Data;
      } catch (error) {
        console.error("Error loading image as base64:", error);
      }
    }

    html2canvas(this.attemptTarget, { scale: 2, useCORS: true }).then((canvas) => {
      const link = document.createElement("a");
      link.href = canvas.toDataURL("image/png");
      link.download = `${this.attemptTarget.id}-predictions.png`;
      link.click();
    }).catch((error) => {
      console.error("Error capturing canvas:", error);
    });
  }

  shareImage() {
    html2canvas(this.attemptTarget).then((canvas) => {
      canvas.toBlob((blob) => {
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
