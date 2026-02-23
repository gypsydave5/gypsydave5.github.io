---
title: "The Incremental and Iterative Argument"
date: 2026-02-23 00:00:00
published: false
description: "A detailed argument for iterative development within incremental delivery, introducing the steel thread as a solution to constrained iteration."
tags:
  - agile
  - iterative
  - incremental
  - steel thread
---
# The Incremental and Iterative Argument

**The Core Distinction:** Iterative development supports the product by delivering working versions you can learn from. Incremental development supports the process by breaking work into manageable pieces. The ideal is external product iteration - shipping usable products to users every few days, learning, and adapting (Kniberg's skateboard → scooter → bike → car).

**But There Are Two Dangers:** First, being purely incremental - building pieces perfectly but never validating the whole thing actually solves the user's problem. You can execute flawlessly on the wrong product. Second, refusing to increment properly - insisting everything must be a "complete, releasable feature" but taking two months to deliver it. This creates large batches, invisible work, no internal feedback loops, and integration hell. You're still being incremental, just with massive, unwieldy increments.

**The Reality of Constrained Iteration:** Often you can't ship intermediate products to users - regulations, market constraints, or technical limitations prevent it. But this doesn't mean you give up on iteration entirely. There's a graceful degradation hierarchy: external product iteration (best), internal product iteration (team validates), iterating the integration of system components (integration validated), and finally pure incremental (no iteration at all until final assembly).

**The Steel Thread Insight:** The steel thread works on multiple dimensions simultaneously. **Integration is iterated** - it's present from the very beginning and continuously refined. **Components are incrementally added** (though each component itself iterates from stub to real implementation). Crucially, **the behavior is present from the first iteration** - even the enabling test describes the actual behavior you want in the final feature. There's no step change from "no feature" to "feature exists." The behavior is there from iteration one, just with constrained scope or audience. You can show it to the team, to friendly users, to yourself - and get immediate feedback on the whole feature right from the beginning.

**Steel Thread Enables Product Iteration:** This means steel thread actually achieves internal product iteration, not just integration iteration. You're iterating the product with a smaller audience (team, friendly users) while incrementing toward production-ready status. What's incrementing isn't the behavior appearing, but production-readiness, robustness (stub → real implementation), scale, and audience reach. The steel thread lets you iterate until you've built something good enough to be called a product increment for full release.

**Iterative Within Incremental:** Cockburn recognizes that incremental delivery improves the process by breaking work into manageable pieces for teams. We agree - but with a crucial caveat: **even incremental features can be delivered iteratively at the system level, and even at the product level with the right audience**. You're iterating the connections while incrementing the capabilities, iterating the product behavior while incrementing toward production scale.

**The Practical Application:** When you can't iterate with all users immediately, steel thread your features. Keep integration present and iterating from day one, increment components as you refine their connections, and get product feedback from constrained audiences early. Sequential component building - finishing pieces in isolation then assembling - loses both the iterative integration benefit AND the early product feedback opportunity. Don't let "complete user stories" hide months of work where nothing integrates and no one sees the actual behavior until the end.
