;; TODO Write Pluck
;; Add highlighting
;; Add creation of source's compliment doc file
;; Add keybindings and interface
;; Group into minor mode called: pluck-mode


;; - Highlighting -
;; Store highlight regions in our doc file
;; While editing a region, the highlight needs to expand and shrink, and update in our doc-file
;; We can add a hook and check whether the number of lines between point and mark has changed for all mark and points

;; This needs to be dynamic to adjust with themes
(defface plucked_region
  '((t :background "medium spring green"))
  "Face for the plucked region"
  )

(defun apply-highlight (beg end)
  "Applies the highlight to a region"
  (interactive "r")
  (message (format "beginning: %s" beg))
  (message (format "end: %s" end))
  (setq start (line-beginning-position (goto-line (+ 1 (line-number-at-pos beg t)))))
  (setq finish (line-end-position (goto-line (line-number-at-pos end t))))
  (message (format "end: %s" start))

  (progn
    (overlay-put (make-overlay start finish) 'face 'plucked_region)
    (setq mark-active nil))
)

(defun remove-highlight (beg end)
  (interactive "r")
  (message (format "beginning: %s" beg))
  (message (format "end: %s" end))
  (count-lines-page)
  (progn
    (remove-overlays beg end)
    (setq mark-active nil))
  )

(apply-highlight 750 800)
(remove-highlight (point-min) (point-max))


;; - File Creation -
;;
;; Create files and store in the "plucked directory"
;; Currently supports org files only
;;
(defun open-doc-file (buffer)
     "Opens the doc-file for the current file, if it doesn't exist
      the user is prompted to create the file"
     (interactive "B")
     (if (file-exists-p (format "plucked/%s.org" (f-base buffer)))
         (find-file-other-window (format "plucked/%s.org" (f-base buffer)))

       (if (y-or-n-p (format "No doc file found for %s; create one now?" buffer))
           (progn
             (make-directory "plucked" t)
             (find-file-other-window (format "plucked/%s.org" (f-base buffer)))
             )
         )
       )
)

(open-doc-file (buffer-file-name (current-buffer)))


;; - Pluck some code -
;; Take a region, highlight it, open doc file seek to location for notes
;;
;;
;;
(defun pluck-region(start end)
  (interactive "r")
  (apply-highlight start end)
  (open-doc-file (buffer-file-name (current-buffer)))
  (pluck-insert-new start end (pluck-get-region start end))
  (move-end-of-line t)
  )

