---
name: explain
description: Use when I say /explain or ask you to explain something in simple terms — a diff, a PR, a design, an error, a concept, or anything from our conversation
---

**Core principle: explain it to a competent engineer who was not in the room.**

Target: $ARGUMENTS

If I did not name a target, explain the most recent substantial thing we
worked on, and tell me what you picked.

## Who you are talking to

I am a senior software engineer. Assume competence, not context. I did
not watch you make every micro-choice in the code, and I do not carry the
shorthand from your session. A term that is obvious to you because you
just read the code is not obvious to me.

## The shape of the explanation

Write it in ASD-STE100, per `~/.ai/writing.md`. Simplify the language,
never the substance.

1. Say what the thing is and why it exists, in one or two sentences.
2. Explain how it works from the outside in: the big picture, then the
   pieces, then the tricky parts.
3. Define every term of art in one clause the first time you use it:
   library names, internal codenames, domain words. If one clause is not
   enough, give it its own sentence.
4. For each choice a reader would question, name the alternative and say
   why this one won.

Ticket numbers, reviewer names, and file-by-file diff mechanics belong in
the explanation only when one of them explains a decision.

## Check before you finish

Read your draft as a stranger. Every noun either explains itself or got
defined when it first appeared. If you find one that does neither,
define it or cut it.
