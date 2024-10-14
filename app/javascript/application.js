// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

import "trix";
import "@rails/actiontext";

document.addEventListener("turbo:load", () => {
  const links = document.querySelectorAll("a");
  
  if(document.title === "Posts" || document.title === "Link Tracking Test") {
    links.forEach((link) => {
      link.setAttribute("data-controller", "link-click");
      link.setAttribute("data-action", "click->link-click#handleClick");
      link.setAttribute("data-link-click-target", "link")
    });
  }
});
