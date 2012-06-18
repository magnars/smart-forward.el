(require 'expand-region)

(defun smart--name-contains-inside-p (f)
  (string-match-p "\\(inside\\|inner\\)" (format "%S" f)))

(defun smart--er-try-list-without-inside ()
  (remove-if 'smart--name-contains-inside-p er/try-expand-list))

(defun smart-forward ()
  (interactive)
  (when (= (point) (point-max))
    (error "End of buffer"))
  (let ((_mark (set-marker (make-marker) (mark)))
        (mark-ring mark-ring)
        (mark-active mark-active)
        (p (point)))
    (deactivate-mark)
    (flet ((message (&rest args) nil))
      (er/expand-region 1)
      (while (<= (mark) p)
        (er/expand-region 1)))
    (exchange-point-and-mark)
    (set-marker (mark-marker) _mark)))

(defun smart-backward ()
  (interactive)
  (when (= (point) (point-min))
    (error "Beginning of buffer"))
  (let ((_mark (set-marker (make-marker) (mark)))
        (mark-ring mark-ring)
        (mark-active mark-active)
        (p (point)))
    (deactivate-mark)
    (flet ((message (&rest args) nil))
      (er/expand-region 1)
      (while (>= (point) p)
        (er/expand-region 1)))
    (deactivate-mark)
    (set-marker (mark-marker) _mark)))

(defun smart-down ()
  (interactive)
  (when (= (point) (point-max))
    (error "End of buffer"))
  (if (= (line-number-at-pos) (save-excursion
                                (goto-char (point-max))
                                (line-number-at-pos)))
      (goto-char (point-max))
    (let ((_mark (set-marker (make-marker) (mark)))
          (mark-ring mark-ring)
          (mark-active mark-active)
          (l (line-number-at-pos))
          (er/try-expand-list (smart--er-try-list-without-inside)))
      (deactivate-mark)
      (flet ((message (&rest args) nil))
        (er/expand-region 1)
        (while (<= (save-excursion
                     (exchange-point-and-mark)
                     (line-number-at-pos)) l)
          (er/expand-region 1)))
      (exchange-point-and-mark)
      (deactivate-mark)
      (set-marker (mark-marker) _mark))))

(defun smart-up ()
  (interactive)
  (when (= (point) (point-min))
    (error "Beginning of buffer"))
  (let ((_mark (set-marker (make-marker) (mark)))
        (mark-ring mark-ring)
        (mark-active mark-active)
        (l (line-number-at-pos))
        (er/try-expand-list (smart--er-try-list-without-inside)))
    (deactivate-mark)
    (flet ((message (&rest args) nil))
      (er/expand-region 1)
      (while (>= (line-number-at-pos) l)
        (er/expand-region 1)))
    (deactivate-mark)
    (set-marker (mark-marker) _mark)))

(provide 'smart-forward)
