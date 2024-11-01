import { Controller } from "@hotwired/stimulus";
import html2canvas from "html2canvas";
import saveAs  from "file-saver";

export default class extends Controller {
  static targets = ["download", "share", "attempt", "choiceImage"];

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

  initialize() {

    this.choiceImageTargets.forEach((img) => {
      const url = img.src;
      this.loadImageAsBase64(url)
        .then((base64Image) => {
          img.src = base64Image;
        })
        .catch((err) => {
          console.error("Error loading image:", err);
        });
    });
  }

  captureRankingImage = async () => {
    const canvas = await html2canvas(this.attemptTarget, {
      useCORS: true,
      allowTaint: false
     });
    return new Promise((resolve) => {
      canvas.toBlob((blob) => {
        const file = new File([blob], "predictions.png", { type: "image/png" });
        resolve(file);
      });
    });
  };

  async downloadImage() {
    // Show loader
    const loader = document.getElementById('share-download-loader');
    loader.classList.remove('hidden');

    try {
      // Capture the image and download it
      const file = await this.captureRankingImage();
      saveAs(file, `${this.attemptTarget.id}-predictions.png`);
    } catch (error) {
      console.error("Error capturing or downloading image:", error);
    } finally {
      // Hide loader once the download is complete or if there was an error
      loader.classList.add('hidden');
    }
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
