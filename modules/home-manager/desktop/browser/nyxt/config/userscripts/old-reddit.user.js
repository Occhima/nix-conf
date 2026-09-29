// ==UserScript==
// @name        Old Reddit, quieter
// @description Hide promoted posts, ads and app banners on old.reddit.com, where mirror-mode sends Reddit.
// @match       *://old.reddit.com/*
// ==/UserScript==

GM_addStyle(`
  .promotedlink, .promoted, #siteTable_organic, .ad-container, #ad_main,
  .premium-banner-outer, .listingsignupbar, .infobar.listingsignupbar,
  .sidecontentbox.goldvertisement, .native-banner-ad, .redesign-beta-optin {
    display: none !important;
  }
  .content { max-width: 1100px; }
  .comment .md { max-width: 75ch; }
`);
