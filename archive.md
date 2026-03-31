---
layout: default
title: "Archive"
permalink: /archive/
---

# Archive

---

## Categories

{% assign all_categories = site.categories | sort %}
{% for category in all_categories %}
  {% assign cname = category[0] %}
<h3 id="{{ cname | slugify }}" style="margin-bottom: 0.3rem;">{{ cname | capitalize }}</h3>
<ul style="margin-top: 0.2rem;">
  {% for post in category[1] %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <small>({{ post.date | date: "%b %d, %Y" }})</small>
    </li>
  {% endfor %}
</ul>
{% endfor %}

---

## Tags

<div class="tag-cloud" style="margin-bottom: 1.5rem;">
{% assign all_tags = site.tags | sort %}
{% for tag in all_tags %}
  {% assign tagname = tag[0] %}
  <a href="#tag-{{ tagname | slugify }}" class="tag-pill" style="margin-bottom: 0.3rem;">
    {{ tagname }} <small>({{ tag[1].size }})</small>
  </a>
{% endfor %}
</div>

{% for tag in all_tags %}
  {% assign tagname = tag[0] %}
<h4 id="tag-{{ tagname | slugify }}" style="margin-bottom: 0.3rem;">{{ tagname }}</h4>
<ul style="margin-top: 0.2rem;">
  {% for post in tag[1] %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <small>({{ post.date | date: "%b %d, %Y" }})</small>
    </li>
  {% endfor %}
</ul>
{% endfor %}

---

## All Posts

{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
{% for year in posts_by_year %}
<h3 style="margin-bottom: 0.3rem;">{{ year.name }}</h3>
<ul style="margin-top: 0.2rem;">
  {% for post in year.items %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <small>({{ post.date | date: "%b %d, %Y" }})</small>
    </li>
  {% endfor %}
</ul>
{% endfor %}
