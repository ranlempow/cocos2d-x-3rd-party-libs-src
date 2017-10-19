#!/usr/bin/env python
import os
import re

# [[example]]:
# CURL_VERSION ?= 7.52.1
# CURL_URL ?= http://curl.haxx.se/download/curl-$(CURL_VERSION).tar.gz
# $(eval CURL_URL := $(CURL_URL))

old_regex_tmpl = r"""
(?P<pkg>[A-Z0-9]+)_VERSION\s*:?=\s*(?P<version>\S+)\s*
\1_URL\s*:?=\s*(?P<url>\S+)
"""
new_regex_tmpl = r"""
(?P<pkg>[A-Z0-9]+)_VERSION\s*\?=\s*(?P<version>\S+)\s*
\1_URL\s*\?=\s*(?P<url>\S+)\s*
\$\(eval \1_URL := \$\(\1_URL\)\)
"""

old_tmpl = r"""
{pkg}_VERSION := {version}
{pkg}_URL := {url}
"""

new_tmpl = r"""
{pkg}_VERSION ?= {version}
{pkg}_URL ?= {url}
$(eval {pkg}_URL := $({pkg}_URL))
"""

old_regex = re.compile(old_regex_tmpl[1:-1], re.M)
new_regex = re.compile(new_regex_tmpl[1:-1], re.M)

def replace(rulefile, match, to_regex, to_tmpl):
    text = open(rulefile).read()
    to_tmpl_text = to_tmpl[1:-1].format(
        pkg=match.group(1), version=match.group(2), url=match.group(3)
    )
    to_text = text.replace(text[match.span()[0]:match.span()[1]], to_tmpl_text)
    if to_regex.search(to_text):
        print(to_tmpl_text)
        print('write', *match.groups())
        open(rulefile, 'w').write(to_text)
    
def find_replace_all(from_regex, to_regex, to_tmpl):
    srcpath = os.path.abspath(os.path.join(__file__, '../../../../contrib/src'))
    for pkg in os.listdir(srcpath):
        rulefile = os.path.join(srcpath, pkg, 'rules.mak')
        if os.path.exists(rulefile):
            m = from_regex.search(open(rulefile).read())
            # print((m.groups(), m.span()) if m else pkg)
            if m:
                replace(rulefile, m, to_regex, to_tmpl)

find_replace_all(old_regex, new_regex, new_tmpl)
# find_replace_all(new_regex, old_regex, old_tmpl)

