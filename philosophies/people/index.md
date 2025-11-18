---
layout: default
title: People
nav_order: 1
parent: Philosophies
has_children: true
permalink: /philosophies/people/
---

# People Philosophies

Coding philosophies from influential software developers and thought leaders.

These files capture the wisdom, principles, and approaches of programmers who have shaped how we think about software development.

---

## Available Philosophies

{% assign people_files = site.pages | where_exp: "page", "page.path contains 'philosophies/people/' and page.path != 'philosophies/people/index.md'" | sort: "title" %}
{% for page in people_files %}
- [{{ page.title }}]({{ page.url | relative_url }})
{% endfor %}
