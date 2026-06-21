---
layout: post
title: "What two months between jobs looked like"
date: 2026-05-24
tags: [reflections, growth, learning, career-break]
categories: [reflections]
image: /assets/images/2026-05-24-what-two-months-between-jobs-looked-like/20260425_163424.jpg
---

When I signed off from my first job after college on February 27, 2026, after 14 years and 7 months, I was not prepared to be without an offer. The expectation had been a smooth transition to a new role over a single weekend. However, it became evident during my final few days that the ride might not be smooth, and I had to prepare for a break of at least a few weeks. As a positive-minded person, I calmed myself down by recognizing that a break like this might never come again, and I should make the absolute most of it. 

The following week, I sent back my trusted work laptop, a Dell Precision 5560, and switched to my old reliable workhorse: a Dell Optiplex 990 running Ubuntu 24.04. This machine would become my primary companion for learning, tinkering, and job searching. 

{% include img.html src="/assets/images/2026-05-24-what-two-months-between-jobs-looked-like/20260425_163424.jpg" alt="At Bridgestone Event" caption="At Bridgestone Event" %}

I was clear about one rule: I would not deviate from my daily routine. I set up a dedicated **Growth Spreadsheet** to track my progress on a daily basis - not just in terms of job applications, but focusing heavily on my daily learning, milestones, and technical exploration. I had read about the psychological benefits of documenting every single step, no matter how small, and decided to apply it here. Looking back, I feel incredibly proud of how I spent those weeks. Keeping that ledger helped me maintain the right growth mindset when things felt stagnant.

What started as a simple reset between roles slowly became a volatile mix of experimentation, reflection, physical repairs, interviews, travel, and deep dives into the rapidly evolving AI ecosystem. 

<!--more-->

## The Plan: Learning, AI, and Architecture

I updated my resume to focus on Solution Architect positions, refreshed my profiles across job portals, and prepared to navigate the open market. I didn't even own a standalone webcam to face video interviews, but given how powerful smartphone cameras are these days, I started running *Iriun Webcam* software to make do with what I had. 

Let's talk about the part of a career break that people rarely write about on LinkedIn: **the mental toll of the job hunt.** Going from a 14-year stable tenure directly into the open market is a jarring experience. There are also the quiet, pragmatic realities to face, like logging into investment accounts to pause my monthly SIPs to conserve cash flow while the timeline for a new role remains completely open-ended. Not every day felt productive.

During this period, I went through multiple rounds of rewriting and refining my resume, carefully shaping it to reflect the true scale of my responsibilities and convey my impact as clearly as possible. Once satisfied, I converted it to the clean, developer-centric *Jake's Format*, integrated it directly into my website at [staygeo.com/resume/]({% link resume.html %}), and flipped my LinkedIn status to #OpenToWork. Then came the loop.

There were interviews that went well, and assignments that flopped badly. I submitted a comprehensive Terraform-based assignment for a European recruiter, but then took another raw, remote Terraform assignment for a different role. This one was to be done completely blind: **zero Google searches, zero documentation access, and zero AI assistance.** 

My performance flopped as expected. It was an incredibly grounding, brilliant reminder of how much modern engineering relies on immediate documentation retrieval and continuous context rather than rote syntax memorization.

The rejections stung more than expected. There was the distinct sting of being ghosted after final rounds, and days where interviewers used my early academic background in Civil Engineering / Remote Sensing & GIS as a convenient excuse to defer technical discussions - completely discounting my subsequent 14 years of hardcore platform and infrastructure experience. Combined with the brutal summer heat wave and minor dehydration, there were days where I simply felt low, uncertain, or completely exhausted.

But during those weeks, community came through. Friends offered referrals, and I found a strange comfort reading Reddit threads of other tech professionals who deliberately took extended gaps between roles to recalibrate, rest, and protect their clarity of thought.

Eventually, the engineering brain's refusal to turn off pulled my curiosity entirely elsewhere.

## The Local AI Stack & Project Kore

One rabbit hole led to another. I started exploring the mechanics of local AI tooling: Ollama, local models, AI CLIs, and privacy-first setups. Somewhere in the middle of this local environment setup, I decided I wanted to build something tangible. **Project Kore** was born.

The objective was straightforward: build a highly private, local-first personal finance and investment tracker. The immediate bottleneck was data ingestion. Mutual fund and stock data usually come locked inside Consolidated Account Statements (CAS) in PDF format. I spent days figuring out how to parse these financial statements reliably using Python, and quickly realized that PDF parsing is anything but straightforward. 

I initially started out utilizing `pdfplumber`, but formatting shifts and multi-column spacing issues were incredibly finicky. I ended up switching over to `PyMuPDF` to gain better structural control over the layout. Though I came across a few purpose-built parsing tools and APIs like *casparser.in*, my primary concern remained absolute data privacy - how do you leverage powerful AI capabilities to categorize financial expenses without leaking personally identifiable information (PII) to public cloud endpoints?

I installed OpenCode, downloaded a quantized Qwen model, and attempted to develop the parser script completely offline. The reality check was stark: local model performance on my existing consumer hardware was quite poor. 

To get the intelligence I needed without compromising data containment, I began exploring the Gemini CLI alongside local sandboxing techniques. This forced me down a deep rabbit hole of studying modern AI-native workflows: exploring Claude’s documentation extensively, understanding Model Context Protocol (MCP), subagents, hooks, skills, and infrastructure sandboxing. If I was going to navigate the modern engineering landscape effectively, I needed to learn the right design patterns to become "AI+" - an engineer who seamlessly architects solutions around these intelligence platforms.

Fiddling with local inference naturally makes you look closely at the economics of compute hardware, and I quickly realized why the industry is currently so obsessed with GPUs. At one point, I was researching MacBooks, ThinkPads, and local AI rigs costing upwards of ₹1.3L just to get decent VRAM context. As a budget-friendly compromise for a dedicated desktop GPU, Gemini recommended looking at an RTX 3050 (hovering around ₹22k). Ultimately, I postponed the heavy hardware acquisition for other priorities.

## Domestic DevOps: The Physical Layer

The break also gave me an excellent opportunity to tinker with physical hardware around the house which I would have otherwise postponed indefinitely.

After spending years looking at digital metrics and virtual dashboards, there is an immense sense of satisfaction in diagnosing a tangible, physical fault. One morning, I noticed slight melting on the power plug of our submersible water pump. While replacing the plug, I traced the wiring issue further back into the control box and discovered that the internal terminal strip was highly degraded, creating dangerous high resistance. I replaced the entire terminal block, rewired the connections safely, and documented the fix [here]({% link _posts/2026-03-31-pump-control-repair.md %}).

Next came tackling home maintenance by replacing old roofing sheets and rain gutters - hired Professionals for the job. Later, while cutting through metal scrap with an angle grinder, I accidentally shattered a cutting disc mid-spin. It was a sobering, immediate reminder of the physical hazards of DIY work. Thankfully, with God's grace no injury occurred.

{% include img.html src="/assets/images/2026-05-24-what-two-months-between-jobs-looked-like/20260420_114836.jpg" alt="Metal rain gutters" caption="Metal rain gutters" %}

{% include img.html src="/assets/images/2026-05-24-what-two-months-between-jobs-looked-like/20260421_153235.jpg" alt="Shattered cutting disc" caption="Cutting disc shattered mid-spin" %}

## The Intellectual Side-Quests

With no sprint goals or work items dictating my daily focus, I collected a series of disparate, fascinating intellectual coordinates across Cloud Architecture, System Design, Personal Finance, and GST setup and compliance.

I also got to do things I would normally postpone while working full-time:
*   Addressed 10th Standard students at Jaycees on the topic of self-confidence and self-belief. [Post]({% link _posts/2026-03-13-self-confidence.md %})
*   Fine-tuned my personal blog's stylesheets to give it a clean, professional appearance.
*   Cleared out years of old, saved bookmarks accumulated on Twitter/X.
*   Dismantled a set of broken Creative desktop speakers just to extract the raw magnets for future benchmarking projects.

## A Scenic Intermission: Pune

Right in the middle of the job-hunting stress, a major highlight arrived: I was accepted for the Team-BHP Bridgestone Plant Visit in Pune.

I booked my flights, packed my backpack and spent an incredible day observing industrial manufacturing and automation at scale. Beyond the factory floor, it gave me a brilliant opportunity to travel, clear my head, and meet fantastic people I had previously only known online. My write-up on [Team-BHP](https://www.team-bhp.com/forum/indian-car-scene/307354-bridgestone-india-factory-tour-team-bhpians-saturday-25th-april-chakan-5.html#post6126376)

Of course, the universe always has a way of balancing things out. Immediately after landing back home, feeling completely refreshed from a flawless trip, I managed to lock my keys directly inside the boot of my Tata Punch. How I managed to get it unlocked is a story for another day! 

## The Turnaround & Next Deployment

The tech market is wildly unpredictable. It feels like absolutely nothing is happening for weeks, and then everything happens concurrently in a single 48-hour cycle.

On the afternoon of April 27, exactly two months to the day after my sign-off, LinkedIn notified me about a message from Kranthi. 20 minutes later, we were on a introductory phone call. Five hours after that, I found myself in a deep interview with the company's CEO, Dr. Renuka.

We had a great conversation around the complex technical and process challenges faced by modern engineering organizations. The alignment was clear. Two days later, I received an official offer letter from SIENT Technologies. The break officially had an end date.

## Final Reflections: Uninterrupted Curiosity

Oddly enough, those low days, quiet intervals, and chaotic side-quests were incredibly useful. The break gave me something I had not realized I was missing for years: **uninterrupted curiosity.** 

*   No sprint boards.
*   No production escalations.
*   No constant context switching.

Just true, uninterrupted time to think, explore, build, read, repair, write, and recalibrate. 

I entered the break with lot of uncertainty but I now look back and realize that I was quietly, intentionally preparing for the next phase of it.