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
          <a class="excerpt-readmore" href="{{ post.url | relative_url }}">Read more →</a>
        {% else %}
          {{ post.content | strip_html }}
          <a class="excerpt-readmore" href="{{ post.url | relative_url }}">Read more →</a>
        {% endif %}
      </div>
    </li>
  {% endfor %}
</ul>
