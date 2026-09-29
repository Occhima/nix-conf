// ==UserScript==
// @name        Reject cookie banners
// @description Click "reject" on the common consent platforms; Nyxt's Electron build runs without an adblocker to do it.
// @match       *://*/*
// ==/UserScript==

(function () {
  "use strict";

  // Reject buttons of the major consent platforms.  Only rejects: accepting
  // would be one click too, but not a click worth automating.
  const rejectSelectors = [
    "#onetrust-reject-all-handler", // OneTrust
    "#CybotCookiebotDialogBodyButtonDecline", // Cookiebot
    "#didomi-notice-disagree-button", // Didomi
    '.qc-cmp2-summary-buttons button[mode="secondary"]', // Quantcast
    "button.sp_choice_type_REJECT_ALL", // Sourcepoint
    ".fc-cta-do-not-consent", // Google Funding Choices
    'button[data-cookiefirst-action="reject"]', // CookieFirst
    "#truste-consent-required", // TrustArc
    ".cmplz-deny", // Complianz
    '#cookie-law-info-bar [data-cli_action="reject"]', // CookieYes
    ".cky-btn-reject", // CookieYes v3
    'button[aria-label="Reject all"]', // Google, YouTube
    'form[action*="consent"] button[aria-label^="Reject"]',
  ];

  const tryReject = () => {
    for (const selector of rejectSelectors) {
      const button = document.querySelector(selector);
      if (button && button.offsetParent !== null) {
        button.click();
        return true;
      }
    }
    return false;
  };

  if (tryReject()) return;

  // Banners are usually injected after load, so watch briefly for one.
  const observer = new MutationObserver(() => {
    if (tryReject()) observer.disconnect();
  });
  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
  });
  setTimeout(() => observer.disconnect(), 15000);
})();
