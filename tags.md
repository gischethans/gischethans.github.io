---
layout: default
title: "Tags"
permalink: /tags/
---

# Tags

<ul>
{% assign all_tags = site.tags | sort %}
{% for tag in all_tags %}
  <li id="{{ tag[0] }}">
    <h3>{{ tag[0] }}</h3>
    <ul>
      {% for post in tag[1] %}
        <li>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          <small>({{ post.date | date: "%b %d, %Y" }})</small>
        </li>
      {% endfor %}
    </ul>
  </li>
{% endfor %}
</ul>
