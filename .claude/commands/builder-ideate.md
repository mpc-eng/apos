# Builder Program Ideation — Problem-First with Claude-Fit Validation

> **Mode:** Technology-push ideation (inverted APOS flow)
> **Profile:** `agents/config/builder-program-profile.json`
> **Output:** Ideas appended to `ideas.json` with Builder Program extended fields

## Why This Exists

Standard `/generate-ideas` scans for market struggle then proposes solutions (market-pull). The Builder Program rewards products where Claude's unique capabilities create something genuinely new. This command starts from **domain expertise and real pain**, then validates whether Claude enables a product that couldn't exist before.

**Critical lesson (learned the hard way):** Starting from "what can Claude do?" leads to API feature wrappers. Starting from "what problem do I deeply understand?" and discovering Claude is the right engine leads to products. The best Builder Program products are built by people who found a real problem and Claude happened to be the best tool — not people who started with Claude and went looking for problems.

---

## Phase 0: Domain Expertise Audit (MANDATORY — Do This First)

Before touching Claude's capabilities, interrogate the CDO's domain knowledge. The Builder Program selects founders, not features. Founders who deeply understand a domain build products that work. Founders who deeply understand an API build wrappers.

### Questions for the CDO

1. **What professional domain have you worked in for 3+ years?** Not "interested in" — worked in. Daily exposure to the workflows, politics, and pain.
2. **What specific, recurring problem costs your organisation real money?** Not a minor annoyance — a structural inefficiency that burns budget, wastes skilled time, or blocks high-value work.
3. **Why hasn't this been solved?** What's the structural blocker? Is it a data problem (information scattered across tools)? A coordination problem (too many stakeholders)? A reasoning problem (decisions too complex for simple rules)?
4. **Who would pay for a solution, and how much?** Not "everyone would benefit" — who writes the cheque? The PM? The CPO? The CFO? The CTO?
5. **What existing tools do they use today, and where do those tools fail?** The gap between what tools provide and what the workflow actually needs is where products are born.

### Phase 0 Output

```
### Domain: [Professional domain]
**Years of direct experience:** [Number]
**The expensive problem:** [Specific, quantifiable pain]
**Why it persists:** [Structural blocker — not "no one's thought of it"]
**Who pays:** [Job title + budget authority]
**Current tools and their gaps:** [Tool → gap → consequence]
**Estimated annual cost of the problem:** [Per team/org, with reasoning]
```

**DO NOT proceed to Phase 1 without a specific, experience-backed problem.** "I think compliance is hard" is not a problem statement. "My org wastes £X/year because [specific mechanism]" is.

---

## Phase 1: Honest Capability Assessment

Now — and only now — assess which Claude capabilities are relevant to the CDO's domain problem. Be ruthlessly honest about what's structural vs. what's an API feature anyone can access.

### The Capability Reality Check

Every Claude capability is accessible via API to anyone with an API key. **A single capability is not a moat.** The displacement test is not "does Claude have this feature?" — it's "would rebuilding the PRODUCT on another model make it fundamentally worse in a way that matters to the customer?"

### Structural Capabilities (Claude-only, verified March 2026)

| Capability | Status | What Makes It Structural | What Does NOT Make It Structural |
|---|---|---|---|
| **Visible Extended Thinking** | STRUCTURAL | Only Claude exposes reasoning chains via API. No other frontier model does this. The thinking tokens are a new data type. | Simply displaying thinking tokens to a user is an API feature, not a product. The product must PROCESS, ANALYZE, or BUILD ON thinking data in a way that creates value beyond the raw display. |
| **Agent SDK** | STRUCTURAL (narrow) | Claude-specific SDK primitives: context compaction, session resume, subagent orchestration. These specific features don't exist in other agent frameworks. | The CONCEPT of autonomous agents is not structural — CrewAI, LangChain, OpenAI Assistants all do agents. The moat is in SDK-specific features that enable product capabilities competitors can't easily replicate. |
| **Constitutional AI** | STRUCTURAL (weak) | Built-in, non-programmable safety judgement. In regulated domains, appropriate escalation behaviour is a feature. | Hard to build a product ON this alone. Best as an enhancer that adds trust in sensitive domains. |

### Downgraded Capabilities (previously listed as structural, now commoditised)

| Capability | Previous Status | Current Reality |
|---|---|---|
| **MCP Protocol Ecosystem** | Was "structural" | **DOWNGRADED to strong-but-replicable.** OpenAI adopted MCP in March 2025. Donated to Linux Foundation (AAIF) December 2025. 97M+ monthly SDK downloads across ALL major models. MCP is now an open standard. Products built on MCP work on GPT-4o too. Use MCP for integration depth (switching cost from breadth of connections), but it is NOT a displacement moat. |

### Strong-but-Replicable (enhance, never build moat on)

- **MCP ecosystem** (open standard — integration depth creates switching cost, not displacement)
- **Reasoning quality** (Claude is better today, competitors catch up)
- **Tool use reliability** (gap narrowing)
- **Vision / document understanding** (competitive with GPT-4o)
- **Long context (200K)** (Gemini claims longer)
- **Personality consistency** (real but unverifiable)

### Commodity (never build moat on)

Text generation, summarisation, translation, structured output, code generation, multilingual support.

### The Combination Principle

Individual capabilities are API features. **Combinations of capabilities deeply integrated into a domain-specific system** create products. The moat comes from:
1. **System complexity** — the product orchestrates many Claude interactions (not one API call) into emergent value
2. **Proprietary data** — Claude interactions generate data that compounds (reasoning corpus, pattern detection, calibration)
3. **Integration depth** — MCP connections + domain-specific tooling create switching costs
4. **Domain encoding** — the product embeds domain expertise that took years to acquire into Claude's evaluation framework

### Phase 1 Output

Map the CDO's domain problem to Claude capabilities:
```
### Problem → Capability Mapping
**Domain problem:** [From Phase 0]
**Primary structural capability:** [Must be from structural list — with specific usage, not just "uses thinking"]
**Enhancing capabilities:** [Strong-but-replicable that add value]
**System description:** [How multiple capabilities combine — NOT a single API call]
**Data that accumulates:** [What proprietary data does the product generate through Claude usage?]
**Why this combination creates a product, not a wrapper:** [Specific argument]
```

---

## Phase 1.5: Three Kill Tests

Before any research, apply these three tests. All three must pass. Kill aggressively — it's better to kill early than to waste research on a dead idea.

### Test 1: The Wrapper Test

Describe the idea in one sentence. If it follows the pattern **"[Claude feature] + [domain UI]"**, it's a wrapper. Kill it.

Examples of wrappers (kill these):
- "Claude's extended thinking + compliance UI" → wrapper
- "Claude's tool use + CRM interface" → wrapper
- "Claude's reasoning + financial analysis dashboard" → wrapper

Examples of products (these survive):
- "A reasoning corpus that accumulates across hundreds of feature evaluations, enabling pattern detection that reveals hidden organisational costs" → product (the VALUE is the corpus + insights, not the individual reasoning)
- "An autonomous agent that traces feature lifecycle across 5 tools, tags every decision with reasoning, and builds predictive models for project risk" → product (the VALUE is the cross-tool tracing + predictions, not any single Claude interaction)

**The test:** Does the product have substantial value-add BEYOND the Claude interaction itself? If you removed the Claude feature and replaced it with a human expert doing the same evaluation, would the product's data/system/insights still be valuable? If yes, Claude is the engine of a real product. If no, you've built a Claude UI skin.

### Test 2: The Board Test

Present the idea to a hostile VC board (mentally). They will ask:

1. **"What stops [incumbent] from adding this as a feature?"** — If Jira, Linear, Productboard, or Salesforce could ship your core value as a feature using the same Claude API you use... you don't have a product. You have a feature request for someone else's product. **Your answer must reference proprietary data, system complexity, or domain encoding that incumbents can't replicate in a sprint.**

2. **"Is this a process or a product?"** — If the core innovation is a methodology/framework that could work on a whiteboard, Claude is an accelerant, not the engine. Accelerants don't pass HG-5. **Your answer must explain what Claude GENERATES (data, insights, predictions) that the process alone cannot.**

3. **"Who is your first customer and how do you reach them in under 3 months?"** — Enterprise sales cycles are 6-12 months. If your product requires org-wide adoption, you won't have traction by the showcase. **Your answer must identify a buyer who can adopt independently (individual, small team, or consultant) without procurement approval.**

If you can't answer all three confidently, the idea isn't ready.

### Test 3: The CFO Test

Can you quantify the financial impact? The idea must have a clear cost-saving or revenue-generating pitch with actual numbers.

Format:
```
"A [team size]-person [function] costs £[X]/year. [Y]% of effort is wasted on [specific waste mechanism].
Our product reduces this by [Z]% by [specific mechanism].
That's £[savings]/year saved. We cost £[price]/year.
ROI: [X]x."
```

If you can't fill in these numbers with defensible reasoning, the idea isn't ready for the Builder Program.

---

## Phase 2: Problem-First Research

**Unlike the previous version, Phase 2 starts from the DOMAIN PROBLEM, not from Claude capabilities.** Research validates the problem and market, not the technology.

### Research Questions (run via WebSearch/WebFetch)

> **Integration note:** This phase performs lightweight inline research focused on problem validation and market sizing. It does NOT replace the [RESEARCH] agent's seven-module deep feasibility study. If the idea survives to `ideas.json`, the CDO can optionally run `/research` for full competitive deep-dive, user research synthesis, and value chain stress test before triage.

For the CDO's domain problem:

1. **How widespread is this problem?** Search for industry surveys, benchmarks, complaints (Reddit, HN, LinkedIn). Quantify: how many companies/teams experience this? What do they spend on workarounds?

2. **What solutions exist and where do they fail?** Map the competitive landscape. NOT "are there 5+ AI tools?" but "what tools address this workflow and where is the structural gap?" If existing tools solve 80% of the problem, the remaining 20% better be worth £X/year.

3. **What's the buying behaviour?** Who buys tools in this category? What do they pay? How long is the sales cycle? Is there a bottom-up adoption path (individual → team → org)?

4. **What's the EMEA catalyst?** Regulation, workforce shortage, structural market force that creates urgency NOW. Not "would be nice" — "must act by [date]."

5. **What failed and why?** Previous attempts at solving this. Did they fail because the AI capability didn't exist (strong signal) or because of market/distribution (weak signal — means the problem may not be real)?

### Phase 2 Output

```
### Market Validation: [Problem Title]
**Problem prevalence:** [X companies/teams, £Y annual cost]
**Existing solutions and gaps:** [Tool → what it does → where it fails → why]
**Buying behaviour:** [Buyer persona, budget, sales cycle, adoption path]
**EMEA catalyst:** [Specific regulatory/structural force with date]
**Failed attempts:** [What, why, signal strength]
**Competitive moat assessment:** [What stops incumbents from adding this as a feature?]
```

---

## Phase 3: Moat Architecture

This is the phase most ideation processes skip. **Design the moat BEFORE designing the product.**

### The Data Moat

Every idea must answer: **What proprietary data accumulates through product usage, and how does it compound?**

The pattern:
1. **Capture** — Claude interactions generate structured data (reasoning chains, evaluations, decisions, outcomes)
2. **Index** — Data is tagged, linked, and searchable across the full lifecycle
3. **Detect** — Patterns emerge from the corpus that are invisible in individual interactions
4. **Predict** — Accumulated patterns enable predictions that improve with usage
5. **Lock-in** — The customer's proprietary corpus + calibrated predictions create switching costs that increase over time

Example (from the product decision intelligence concept):
- **Capture:** Every feature evaluation generates a prosecution/defence reasoning chain tagged to the feature lifecycle (idea → triage → build → rework → outcome)
- **Index:** Cross-tool tagging connects Figma designs, Confluence specs, DevOps tickets, and Slack discussions to a unified feature graph
- **Detect:** After 200+ evaluations, patterns emerge: "features with 3+ cross-squad dependencies cost 2.8x more and ship 3.2 weeks late"
- **Predict:** New features are flagged at evaluation: "This matches your highest-risk profile. Historical rework rate: 73%"
- **Lock-in:** 12 months of reasoning corpus + calibrated predictions + cross-tool integration = massive switching cost

### The Incumbent Defence

Answer explicitly: **What stops Linear/Jira/Productboard/Salesforce from shipping this as a feature?**

Strong answers:
- "Their data model is [tasks/issues/features]. Our data model is [decisions/reasoning]. Changing their data model would require a fundamental product re-architecture."
- "We capture a data type they don't have access to (reasoning chains from Claude's thinking tokens). They'd need to add Claude integration, build a reasoning corpus engine, and change their product philosophy."
- "Our value comes from cross-tool data mining (Figma + Confluence + DevOps + Slack). They're single-tool platforms."

Weak answers (kill the idea):
- "We'll move faster" (they have 100 engineers)
- "Our AI is better" (they'll use the same Claude API)
- "We have domain expertise" (they'll hire domain experts)

### Phase 3 Output

```
### Moat Architecture
**Data captured per interaction:** [Specific data types]
**Compounding mechanism:** [How data gets more valuable over time]
**Pattern detection threshold:** [How many interactions before insights emerge]
**Switching cost at 12 months:** [What the customer would lose by switching]
**Incumbent defence:** [Why the obvious competitor can't replicate this as a feature]
```

---

## Phase 4: Financial Justification

Write the CFO pitch. This is not optional — it forces intellectual honesty about whether the product saves real money or just sounds good.

### Cost of the Problem

```
**Organisation profile:** [Size, function, annual cost]
**Waste mechanism:** [Specific, named source of waste — not "inefficiency"]
**Waste quantification:** [£X/year, with reasoning chain showing how you calculated it]
**Current mitigation:** [What they do today and what it costs]
**Evidence source:** [Industry benchmark, survey data, or CDO direct experience]
```

### Value of the Solution

```
**Waste reduction:** [X% of identified waste, with mechanism]
**Annual savings:** [£Y/year per team/org]
**Product cost:** [£Z/year]
**ROI:** [Y/Z]x
**Time to value:** [How quickly does the customer see results?]
**Payback period:** [When does cumulative value exceed cumulative cost?]
```

If ROI is below 5x, the idea needs sharper positioning or bigger impact. Enterprise buyers need clear ROI stories.

---

## Phase 5: Idea Synthesis + APOS Scoring

Now — and only now — synthesise into a full APOS idea entry.

1. Frame the JTBD, workaround, and switching trigger
2. Write the demand narrative grounded in Phase 2 research
3. State the improvement hypothesis (3x minimum) backed by Phase 4 numbers
4. Score 1-5 (standard APOS criteria)
5. Apply owner proximity + trend coupling modifiers
6. Apply Builder Program modifiers (from `builder-program-profile.json`):
   - Claude Depth (BP-1): surface / integrated / core_loop
   - Demo Impact (BP-2): low / medium / high
   - VC Narrative (BP-3): niche / scalable / platform
7. Check all 5 hard gates (HG-1 through HG-5)
8. Check anti-patterns (including ALL patterns in the profile — especially "API Feature Wrapper" and "Process-as-Product")
9. Add extended fields including REQUIRED `why_claude_only`, `non_displaceable_moat`, `data_moat_design`, `incumbent_defence`, and `cfo_pitch`

### Idea Quality Gate (Updated)

Every idea must pass ALL of:
- [ ] HG-5 displacement test: the PRODUCT (not a single feature) is fundamentally worse on GPT-4o — not just "thinking tokens disappear" but the entire value proposition degrades
- [ ] Built on Claude capabilities in a SYSTEM, not a single API call
- [ ] Creates a new category, not enters a market with 5+ existing AI tools
- [ ] Passes the Wrapper Test (substantial value-add beyond Claude interaction)
- [ ] Passes the Board Test (incumbent defence, process vs product, first customer)
- [ ] Passes the CFO Test (quantified ROI, 5x minimum)
- [ ] `why_claude_only` is specific and references the SYSTEM/DATA moat, not a single feature
- [ ] `non_displaceable_moat` is data or ecosystem, not feature-level
- [ ] `data_moat_design` explains what accumulates and how it compounds
- [ ] `incumbent_defence` names the specific incumbent and explains why they can't replicate
- [ ] A non-technical person watching a 3-min demo understands the value AND why this product couldn't exist before Claude
- [ ] Solo-buildable prototype in 4 weeks (Ignite phase)
- [ ] Revenue model doesn't depend on scale (can charge from user #1)
- [ ] First customer reachable without enterprise sales cycle (<3 month adoption)
- [ ] Not a ChatGPT wrapper, LLM-agnostic SaaS, AI bolt-on, API feature wrapper, process-as-product, or model-agnostic professional tool

**If an idea fails ANY of the three kill tests (Wrapper, Board, CFO), it is killed immediately regardless of how strong the APOS score is.**

---

## Phase 6: Showcase Narrative Test

For each idea scoring 4+, write the **July 1 showcase moment**. The demo must show a **SYSTEM working**, not a feature displayed.

### The System Demo Principle

Bad demo: "Watch Claude think about this credit decision." (That's an API feature.)
Good demo: "Watch this system trace a feature across 5 tools, show you the hidden costs your team can't see, and predict which new features will fail — using reasoning data no other tool captures." (That's a product.)

Format:
```
### Showcase: [Product Name]

**Setup** (10 sec): [What the audience sees — must show a SYSTEM, not a single interaction]
**Action** (20 sec): [What you do live — must involve multiple Claude interactions working together]
**Reveal** (20 sec): [The insight/outcome that only this SYSTEM can produce — not available from any single AI call]
**"Only Claude" moment** (10 sec): [Why this system couldn't exist before Claude. Must reference the data/reasoning corpus, not just a single capability. The audience should think "I couldn't build this on GPT-4o" without you having to say it.]
```

### The Audience Test

After writing the showcase, ask: **Would a non-technical VC lean forward during this demo?** If the demo requires explanation ("so what Claude is doing here is..."), it fails. The value must be self-evident. The "only Claude" moment should make the audience realise the demo they just watched couldn't have happened 18 months ago — without you having to tell them.

---

## Execution Notes

- **Phase 0 is the most important phase.** If the CDO doesn't have deep domain experience with a quantifiable problem, stop. The Builder Program selects founders with domain insight, not engineers with API knowledge.
- **Phase 1 should be fast (5 min).** Map the domain problem to capabilities. Don't re-derive what's structural — the table above is current as of March 2026.
- **Phase 1.5 is the critical filter.** The three kill tests (Wrapper, Board, CFO) should kill 80%+ of directions. This is good. Better to kill 10 weak ideas than to research 1.
- **Phase 2 starts from the problem, not the capability.** Research the MARKET, not the API.
- **Phase 3 (Moat Architecture) is non-negotiable.** If you can't design the data moat, you don't have a product. You have a demo.
- **Phase 4 (Financial Justification) separates real products from interesting ideas.** If you can't quantify the savings, the buyer can't justify the purchase.
- **Target: 1-3 ideas, expect 0-1 to survive all gates.** Quality over quantity. Zero surviving ideas means go back to Phase 0 with a different domain problem — not lower the bar.
- **Owner proximity will be `direct_experience` for ideas that survive Phase 0.** That's the point — domain expertise IS the selection criterion.

---

## Lessons Learned (Embedded from Cohort 1 Ideation Cycle)

These were learned through a full ideation cycle that generated and killed multiple idea batches. They are non-negotiable constraints.

### Lesson 1: Individual Claude capabilities are API features, not product moats
Anyone with an API key gets thinking tokens, MCP, Agent SDK. Wrapping a single capability in a domain UI is the ChatGPT Wrapper anti-pattern in a suit. The moat must come from what ACCUMULATES through Claude usage (data, patterns, predictions), not from the Claude interaction itself.

### Lesson 2: MCP is no longer Claude-structural
OpenAI adopted MCP March 2025. Donated to Linux Foundation December 2025. 97M+ monthly SDK downloads across ALL models. Products built on MCP work on GPT-4o. Use MCP for integration depth (switching cost), not displacement.

### Lesson 3: "Visible reasoning" alone is not a product
"Claude shows its thinking" is an API parameter, not a business. The PRODUCT is what you build on TOP of the reasoning data — corpus analytics, pattern detection, organizational intelligence, predictive intervention. If your entire value prop is "look, you can see the reasoning," you've built a Claude UI theme.

### Lesson 4: The displacement test is about the SYSTEM, not a feature
"Swap Claude for GPT-4o — does the product break?" doesn't mean "does one feature disappear?" It means "does the entire value proposition collapse?" A product where Claude's reasoning generates a compounding data corpus that enables predictions — THAT breaks on GPT-4o (worse reasoning quality → noisier corpus → unreliable predictions → product trust collapses). A product where Claude displays reasoning to a user — that degrades but doesn't break.

### Lesson 5: Start from domain pain, not capability scanning
The Anthropic CEO doesn't want to see "I analysed Claude's API and found a use case." They want to see "I spent 10 years in [domain], every [professional] wastes [X hours/week] on [specific task], and I built something that solves it — powered by Claude." The domain expertise is the unfair advantage.

### Lesson 6: Every idea must survive the incumbent question
"What stops [Jira/Linear/Productboard/Salesforce] from shipping this as a feature?" If the answer involves "we'll move faster" or "our AI is better," kill the idea. The answer must reference a structural difference: different data model, proprietary data type, cross-tool integration depth, or accumulated reasoning corpus.

### Lesson 7: The Gong pattern is the archetype
Gong created "revenue intelligence" by capturing sales conversations (a data type no CRM had), indexing them, detecting patterns, and becoming the system of record for revenue decisions. The best Builder Program product will capture a data type no existing tool has (reasoning chains), index it, detect patterns, and become the system of record for decisions in its domain. The wedge is the initial use case. The moat is the corpus. The value is the intelligence.

### Lesson 8: Quantify or die
"Teams waste time on unready work" is a blog post. "A 200-engineer org wastes £4-6M/year on features that should have been killed at evaluation — and we can prove it because we trace every feature from idea to outcome with full reasoning" is a product pitch. If you can't put a number on the problem, the buyer can't justify the purchase.

### Lesson 9: Cross-tool data mining is an underserved opportunity
Enterprise decision data is fragmented across Figma, Confluence, Azure DevOps, Jira, Slack. No tool mines across all of them to show the hidden costs of bad decisions. A product that tags the full lifecycle (idea → triage → kill → dependencies → build → rework → bugs → outcome) with reasoning creates a dataset that doesn't exist anywhere today. The insights from this dataset (sunk costs, rework root causes, dependency impact, bias patterns) are worth multiples of the tool cost.
