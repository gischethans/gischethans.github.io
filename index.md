---
layout: default
title: "Home"
---

# Welcome to StayGeo

StayGeo began on Blogger in 2010. In 2025 I moved the site to GitHub Pages for a cleaner writing and reading experience. The old posts remain at [gischethans.blogspot.com](https://gischethans.blogspot.com/).

---

## Latest posts

<ul>
  {% for post in site.posts limit:10 %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <small>({{ post.date | date: "%b %d, %Y" }})</small>
  <div class="post-excerpt index">
        {% if post.excerpt %}
          {{ post.excerpt | strip_html }}
        {% else %}
          {{ post.content | strip_html }}
        {% endif %}
        <a href="{{ post.url | relative_url }}" style="margin-left:0.5rem; font-weight:600;">Read more →</a>
      </div>
    </li>
  {% endfor %}
</ul>
