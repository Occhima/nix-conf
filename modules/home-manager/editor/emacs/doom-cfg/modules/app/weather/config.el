(use-package! biome
  :config
  (setq biome-query-coords
        '(("Helsinki, Finland" 60.16952 24.93545)
          ("Berlin, Germany" 52.52437 13.41053)
          ("Dubai, UAE" 25.0657 55.17128)
          ("São Paulo, Brazil" -23.5475 -46.63611)
          )
        )
  )


(use-package! osm

  :custom
  ;; Take a look at the customization group `osm' for more options.
  (osm-server 'default) ;; Configure the tile server
  (osm-copyright t)     ;; Display the copyright information
  )
