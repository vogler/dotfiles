#!/bin/bash
# ^^ without this, sh is used which fails at the '('. zsh also works

# need to use pipes here because node.io uses SoupSelect per default
# with jQuery "sel1, sel2" should work
cat <(node.io -s query golem.de h1.head4) <(node.io -s query golem.de h2.head2)
