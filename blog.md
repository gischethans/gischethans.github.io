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
      <div class="post-excerpt blog">
        {% if post.excerpt %}
          {{ post.excerpt | strip_html | truncate: 380 }}
        {% else %}
          {{ post.content | strip_html | truncate: 380 }}
        {% endif %}
        <a href="{{ post.url | relative_url }}">Read more →</a>
      </div>
    </li>
  {% endfor %}
</ul>
