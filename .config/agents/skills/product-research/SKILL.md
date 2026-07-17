---
name: product-research
description: "Deep product research to find one clear best pick (plus runners-up) by digging past listicles and SEO content into Reddit threads, YouTube reviews/comments, forums, and small blogs for real, hands-on opinions. Use when asked things like 'what's the best X for me', 'help me pick a Y', or 'research Z options' for purchases like gear, apps, tires, credit cards, appliances, etc."
---

# Product Research

Find a single, well-supported recommendation for a purchase decision by
digging past SEO listicles and affiliate content into the places real
opinions live: Reddit threads (including deep in the comments), YouTube
reviews and their comments, category-specific forums, and small
independent blogs.

## Step 1: Clarify the brief

Always ask 2-4 targeted clarifying questions before researching. The
answers change which sources and criteria matter. Tailor questions to
the category rather than asking generically. Cover whatever is
unknown among:

- **Specific context**: exact make/model/size/climate/use case (e.g. car
  year/trim for tires, foot type/terrain for shoes, spending categories
  for a credit card).
- **Budget ceiling and price sensitivity**: I'm generally happy to pay
  more for quality, longevity, better warranty, or better support.
  Confirm whether that holds for this purchase or if there's a hard cap.
- **Dealbreakers / must-haves**: anything non-negotiable.
- **Current gear and pain points**: what I have now and what's wrong
  with it, if replacing something.

Don't over-ask. Skip questions whose answers wouldn't change the
research approach.

## Step 2: Map sources for this category

Before searching, decide where the real signal lives for this specific
product type. Examples: r/BuyItForLife, r/[category]advice, or a
narrow hobbyist forum for durable goods; YouTube long-term
review/teardown channels for electronics; small independent test blogs
(non-affiliate) for gear; personal finance forums/subreddits for
financial products.

Also look for **review aggregators** that pre-collect real hands-on
sentiment. Sites like redditrecs.com collate Reddit reviews per model
with a positive-sentiment percentage, which is a fast way to spot a
polarizing "popular" pick before you commit. Treat the aggregated
opinions as leads to verify, not as a final verdict.

Prefer natural-language queries. Site-specific operators like
`site:reddit.com` or `site:youtube.com` help, but a query that stacks
an operator with several keywords and a year filter often returns
nothing. If a scoped search comes back empty, drop the operator and the
year and re-run as a plain-language question rather than assuming there
is no discussion.

## Step 3: Research — go deep, not wide

This should be a genuine deep dive, not a quick pass:

- **Search broadly, then follow threads deep.** The best nugget is
  often not the top search result. It's a heavily-upvoted reply buried
  in a Reddit thread, or a comment under a YouTube review where several
  long-term owners converge on the same answer. When a thread looks
  promising, open it and read the comments, not just the post.
- **Prefer long-term, hands-on reports** over unboxings, first
  impressions, or spec comparisons. Look for people who mention actual
  duration of ownership/use.
- **Actively discount SEO listicles, "best of" roundups, and
  affiliate-link-heavy sites.** They routinely recommend whatever pays
  the highest commission rather than what's best. It's fine to skim them
  for the shape of the field (what options exist) but don't treat their
  rankings as evidence.
- **Watch for astroturfing / low-signal enthusiasm**: reviews that are
  all-positive with zero cons, unusually promotional language, or come
  from accounts with no other post history are lower-trust. Real
  hands-on reviews usually mention at least one tradeoff.
- **Recency is category-dependent.** Fast-moving categories (apps,
  electronics, anything software-driven) need recent reviews, roughly
  the last 1-2 years. Durable/slow-changing categories (tires, shoes,
  cookware) can draw on older reviews as long as the specific
  model/line hasn't changed or been discontinued. Check for that.
- **Cross-reference before trusting a claim.** A recommendation is
  strong when independent sources (different subreddits, different
  YouTubers, different blogs) converge on it for the same reasons. A
  single glowing post is a lead, not a conclusion.
- **Weigh quality and longevity over sticker price**, consistent with a
  preference for spending more when it buys a longer lifespan, better
  warranty, or better support, unless the brief set a hard budget cap.

For a genuinely deep dive across several source types (e.g. Reddit vs.
YouTube vs. blogs), issue independent searches and fetches as parallel
tool calls in a single turn. Reserve subagents for when the raw search
output would flood this thread's context, so synthesis stays focused
rather than buried in search results.

## Step 4: Synthesize and pick

Don't present a menu of options. Do the work of actually deciding.
Weigh the corroborated evidence against the brief's criteria (budget,
dealbreakers, quality/longevity preference) and commit to one clear
recommendation. Include runners-up only when there's a genuinely close
second (or third) worth mentioning. Don't pad the list to hit a count.

Weigh the pick against the user's specific constraints, not just the
category's popularity. The most-recommended item in a category can be
wrong for a given person. Watch for a corroborated failure mode that
happens to hit the user's profile (e.g. a highly-rated shoe whose arch
post blisters flat-footed wearers), and read the user's current gear as
evidence: if what they already use works in some respect, that narrows
what they actually need. A consensus pick that conflicts with the
brief's constraints loses to a less-hyped option that fits them.

## Step 5: Present the result

Default to chat markdown, structured as:

1. **The pick** — name/model, why it wins, the specific evidence that
   convinced you (e.g. "widely confirmed across r/X and Y reviewers
   after 12+ months of use"), a link to learn more.
2. **Runner(s)-up** (0-2) — brief, with what would make them the better
   choice instead (e.g. "if budget is the priority" or "if you need
   Z").
3. Any notable caveats, tradeoffs, or things that didn't have enough
   recent/reliable data to be sure about.

After presenting, ask if I'd like it rendered as an artifact webpage
instead of or in addition to the chat summary. Don't build the artifact
unprompted.
