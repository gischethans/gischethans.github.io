---
layout: default
title: "Categories"
permalink: /categories/
---

# Categories

<ul>
{% assign all_categories = site.categories | sort %}
{% for category in all_categories %}
  {% assign cname = category[0] %}
  <li id="{{ cname | slugify }}">
    <h3>{{ cname }}</h3>
    <ul>
      {% for post in category[1] %}
        <li>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          <small>({{ post.date | date: "%b %d, %Y" }})</small>
        </li>
      {% endfor %}
    </ul>
  </li>
{% endfor %}
</ul>
