; extends
((inline) @injection.content
  (#lua-match? @injection.content "^%s*import")
  (#set! injection.language "typescript"))
((inline) @injection.content
  (#lua-match? @injection.content "^%s*export")
  (#set! injection.language "typescript"))

(section 
  (atx_heading 
    (atx_h1_marker)) 
  @markdown_h1 (#lua-match? @markdown_h1 "^#")
  (#set! injection.language "markdown"))

; (section 
;   (atx_heading 
;     (atx_h1_marker)) 
;   @markdown_h2 (#lua-match? @markdown_h2 "^##")))
