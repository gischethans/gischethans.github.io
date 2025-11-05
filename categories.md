---
layout: default
title: "Categories"
permalink: /categories/
---

# Categories

<ul>
{% assign all_categories = site.categories | sort %}
{% for category in all_categories %}
  <li id="{{ category[0] }}">
    <h3>{{ category[0] }}</h3>
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
