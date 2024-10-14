import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="link-click"
export default class extends Controller {
  static targets = ["link"]

  async handleClick() {
    const ipAddress = await this.#getIpAddress();
    const url = this.linkTarget.href;
    const anchorText = this.linkTarget.text;
    const userAgent = navigator.userAgent;
    const referrer = document.referrer;

    const params = {
      url,
      anchor_text: anchorText,
      user_agent: userAgent,
      ip_address: ipAddress,
      referrer
    }

    try {
      const response = await fetch("/link_clicks", {
        method: "POST", // *GET, POST, PUT, DELETE, etc.
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(params),
      });

      console.log(response)

      if (response.status === 429) {
        window.location.href = '/errors/rate_limit_exceeded';
      }
    } catch(e) {
      console.log(e)
    }
  }

  async #getIpAddress() {
    try {
      const response = await fetch("https://ipinfo.io/json");
      if (!response.ok) {
        throw new Error(`Response status: ${response.status}`);
      }
  
      const json = await response.json();

      return json.ip
    } catch (error) {
      alert(error.message);
    }
  }
}
