---
layout: default
title: Methodologies
nav_order: 3
parent: Philosophies
has_children: true
permalink: /philosophies/methodologies/
---

# Methodology Philosophies

Software development approaches and practices.

These methodologies provide frameworks for how to approach software development, from testing strategies to code organization principles.

---

## Available Philosophies

{% assign method_files = site.pages | where_exp: "page", "page.path contains 'philosophies/methodologies/' and page.path != 'philosophies/methodologies/index.md'" | sort: "title" %}
{% for page in method_files %}
- [{{ page.title }}]({{ page.url | relative_url }})
{% endfor %}
