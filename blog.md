---
layout: default
title: "Blog"
permalink: /blog/
---

# Blog Posts

<ul>
  {% for post in site.posts limit:20 %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <small>({{ post.date | date: "%b %d, %Y" }})</small>
      <div class="{% if post.excerpt %}post-excerpt full{% else %}post-excerpt blog{% endif %}">
        {% if post.excerpt %}
          {{ post.excerpt | strip_html }}
        {% else %}
          {{ post.content | strip_html }}
        {% endif %}
        <a href="{{ post.url | relative_url }}">Read more →</a>
      </div>
    </li>
  {% endfor %}
</ul>
