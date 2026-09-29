// ==UserScript==
// @name        No autoplay
// @description Pause video and audio that start without a key press or click, outside video sites.
// @match       *://*/*
// @exclude     *://*.youtube.com/*
// @exclude     *://yewtu.be/*
// @exclude     *://*.twitch.tv/*
// @exclude     *://*.vimeo.com/*
// @exclude     *://*.spotify.com/*
// @exclude     *://*.soundcloud.com/*
// @exclude     *://meet.google.com/*
// ==/UserScript==

(function () {
  "use strict";

  let lastGesture = 0;
  // `click' too: Nyxt hints click with element.click(), which fires no pointer event.
  for (const type of ["pointerdown", "keydown", "touchstart", "click"]) {
    window.addEventListener(
      type,
      () => {
        lastGesture = Date.now();
      },
      true,
    );
  }

  // `play' does not bubble, so listen in the capture phase for every element.
  document.addEventListener(
    "play",
    (event) => {
      const media = event.target;
      if (!(media instanceof HTMLMediaElement)) return;
      // Muted background loops (hero videos, GIF-like clips) are left alone.
      if (media.muted) return;
      if (Date.now() - lastGesture > 1000) media.pause();
    },
    true,
  );

  // Media that was already playing before this script ran (it runs after load).
  for (const media of document.querySelectorAll("video, audio")) {
    if (!media.paused && !media.muted) media.pause();
  }
})();
