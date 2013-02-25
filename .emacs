(with-temp-buffer (insert (shell-command-to-string "ocp-edit-mode emacs -load-global-config")) (eval-buffer))
