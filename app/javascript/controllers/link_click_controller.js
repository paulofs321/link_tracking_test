import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="link-click"
export default class extends Controller {
  static targets = ["link"]

  async handleClick() {
    const url = this.linkTarget.href;
    const anchorText = this.linkTarget.text;
    const userAgent = navigator.userAgent;
    const referrer = document.referrer;

    // ip_address will be generated in the backend
    const params = {
      url,
      anchor_text: anchorText,
      user_agent: userAgent,
      referrer
    }

    try {
      const response = await fetch("/link_clicks", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(params),
      });

      console.log(response)

      if (response.status === 429) {
        window.location.href = '/errors/rate_limit_exceeded';
      }
    } catch(error) {
      alert(error.message);
    }
  }
}
