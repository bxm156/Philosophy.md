---
layout: default
title: Languages
nav_order: 2
parent: Philosophies
has_children: true
permalink: /philosophies/languages/
---

# Language Philosophies

Design philosophies and principles of programming languages.

Each language embodies a set of values and trade-offs that shape how developers think about and write code.

---

## Available Philosophies

{% assign lang_files = site.pages | where_exp: "page", "page.path contains 'philosophies/languages/' and page.path != 'philosophies/languages/index.md'" | sort: "title" %}
{% for page in lang_files %}
- [{{ page.title }}]({{ page.url | relative_url }})
{% endfor %}
