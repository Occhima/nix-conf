// ==UserScript==
// @name        Google direct links
// @description Make Google search results link straight to the page, without click tracking.
// @include     /^https:\/\/www\.google\.[a-z.]+\/search/
// ==/UserScript==

(function () {
  "use strict";

  const clean = (root) => {
    for (const a of root.querySelectorAll("a[href]")) {
      // Google rewrites result links to /url?q=... on mousedown and pings on click.
      a.removeAttribute("ping");
      a.removeAttribute("data-jsarwt");
      a.removeAttribute("onmousedown");
      const href = a.getAttribute("href");
      if (href.startsWith("/url?")) {
        const target =
          new URLSearchParams(href.slice(5)).get("q") ||
          new URLSearchParams(href.slice(5)).get("url");
        if (target && /^https?:/.test(target)) a.setAttribute("href", target);
      }
    }
  };

  clean(document);
  new MutationObserver((mutations) => {
    for (const mutation of mutations) {
      for (const node of mutation.addedNodes) {
        if (node.nodeType === Node.ELEMENT_NODE) clean(node);
      }
    }
  }).observe(document.body, { childList: true, subtree: true });
})();
