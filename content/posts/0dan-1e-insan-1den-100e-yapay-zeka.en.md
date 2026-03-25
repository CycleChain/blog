---
title: "From 0 to 1 Human, From 1 to 100 AI: The New Paradigm of Software"
date: 2025-12-10T07:17:28Z
author: "Fatih Mert Doğancan"
draft: false
description: "In software development, collaboration between humans and AI is the future. Discover the role of humans in creative processes from 0 to 1, and the role of AI in scaling from 1 to 100"
tags: ["artificial-intelligence","ai","software-development","programming","future","technology","innovation","automation","developer","paradigm"]
categories: ["artificial-intelligence"]
slug: "from-0-to-1-human-from-1-to-100-ai"
cover:
  image: "images/0dan-1e-insan-1den-100e-yapay-zeka-yazilimin-yeni-paradigmasi-cover.webp"
  alt: "An illustration showing human creativity and AI scalability in software development."
  caption: "The New Paradigm of The Software Development: Power of Human Creativity and Articial Intelligence Mixing (Created by Gemini 3.0)"
  relative: false
images:
  - "images/0dan-1e-insan-1den-100e-yapay-zeka-yazilimin-yeni-paradigmasi-cover.webp"

---

{{< toc-accordion title="Table of Contents" >}}

## “Crumbs of Knowledge” and Crystallized Experience

Recently, while developing a "Virtual File System" (VFS) for a game project, I came to realize quite a lot of things. When I explained the system's logic to the AI in detail and asked it to write the code from scratch, it gave me working code, but it was mediocre and not production-ready. However, when I gave the AI my old code as a reference — code I had built goes ago from "Crumbs of Knowledge" gathered from StackOverflow, forums, SourceForge projects, and my own experiments — the result was amazing.

The AI used the "intent" and "experience" (edge-cases) embedded in that messy-looking old code as a compass, and produced a highly optimized structure.

> AI can lay the bricks perfectly, but the blueprint and the mortar of the building belong to humans.

Below, we present in-the-wild answers and case studies to critical questions that will shape software development, learning, and the future in this new era.

## 1. For Beginners: "Using the Autopilot Without Being a Pilot"

Those who are new to software development are in a huge **illusion of ease**. It is possible to set up systems with a single click, but this does not eliminate the learning curve, it only changes its shape.

* Blind flight: A junior developer who does not know basic algorithms cannot spot a sneaky logic error in the code produced by AI.
* The new definition: In the past, knowing syntax was more valuable. Now, "system architecture" and "code literacy" are valuable.

> AI writes the code, humans judge the code.

The most beautiful part of the real work is the evolution of access to information. In the past, a village school or a volume of an encyclopedia was an invaluable treasure; the fact that our elders still remember those days with respect is because information was earned *with effort* back then. Then came the internet and search engine revolution, moving information from libraries to our pockets. Today, the process has not only accelerated; information now seeks and finds us, personalizes itself, and comes right next to us, precisely into the context.

### Advice to New Engineers: "Be the Problem Solver, Not the Code Writer"

The way to avoid getting lost in this era of abundance is to accept that you don't have to go through those old *painful and rote* paths. Of course, **ease should not bring shallowness**.

* **Establish a "Dialogue" with AI**: Do not see AI merely as a *subcontractor* doing your job. After getting the code output you asked for, ask it, **"Why did you design it this way, was there another way?"** Aspire for the depth of understanding the logic, not the comfort of getting a ready-made answer.
* **Use the time to deepen your knowledge**: We used to struggle for hours with semicolon errors and library conflicts. It is a great fortune that you are freed from these technical drudgeries. Use this gained time to internalize the logic of the algorithm, the spirit of data structures, the architecture of the system, and the heart of design patterns.

> Tools and languages change, but **pure curiosity** and the **desire to learn** will always remain the most valid skill.

## 2. R&D and Innovation: Quantum and AGI (0 -> 1)

### Can AGI (Artificial General Intelligence) or Quantum Computers create that first spark humans make (the 0 -> 1 problem)?

Here, it is necessary to distinguish the concepts of **processing power** and **intent**.

* **Quantum Computers** are the peak of processing power. They can reduce the process of going from 1 to 100 (optimization, cryptography, molecular modeling) to seconds. But quantum computers also expect an **input**; meaning they don't ask the question, "what should I optimize?".
* **AGI and "Intent"**: Going from 0 to 1 is a **feeling** of "need". A human gets hungry, cold, bored, or above all, curious; that is why they invent. As long as AI does not have biological urges or existential pains, defining a problem "out of the blue" and jumping to solve it (true 0 -> 1) is very difficult.
* **The Future**: AGI can synthesize existing knowledge (what humans have researched/developed until now) and do things that "seem new", but this is still a combination of a vast dataset (i.e., the 1s).

> True creativity is finding direction in a data-free area, and this is still a human monopoly.

### What is "Reasoning", Actually?

A regular LLM (like GPT-4) takes a question/statement and immediately starts to "spit out" the answer (predicting the next token).

* User: What is 25 * 48?
* Standard LLM: 1200.

However, in "Reasoning" models (DeepSeek R1, OpenAI o1, etc.), the process is as follows: Before giving the final result to the user, the model starts talking to itself in a **hidden space**. This conversation is added to the model's own context window, meaning its context memory.

#### DeepSeek R1, as We Know From Its Source Code

1. **Input**: What is 25 * 48?
2. **Hidden Generation (Thinking Tokens)**: `<think>` I need to multiply 25 and 48. I can think of 48 as 50-2. 25 * 50 = 1250. Then 25 * 2 = 50. 1250 - 50 = 1200. `</think>`
3. **Output**: The answer is 1200.

> What we term as thinking is actually the model preparing a "scratchpad" for itself by filling its own context to more accurately predict the next word.

If we look at the papers and the `generation_config` structures in the repositories of DeepSeek R1 and its derivatives, we see this: They were forced with **Reinforcement Learning** to do the following: **"Do not give the answer immediately, write the intermediate steps first."**

* **Reality**: The model is merely generating more tokens.
* **Marketing**: "AI is thinking deeply."

> Thinking = Spending more processing power (more tokens) = "Expanding the Context"

## 3. Technical Depth: Context and Hallucination

AI grasps the context of the code in a structure similar to the AST (Abstract Syntax Tree) logic.

* **Hallucination** = **Context Disruption**: Hallucination is actually a "Context Overflow" or a lack thereof. AI is generally not trained to say "I don't know" for things it doesn't know. Probabilistically, it determines the most logical word and fills the unknown gaps with statistical guesses.
* **Context Poisoning (Context Overflow/Confusion)**: When too much and contradictory information is provided (old code + new requests + wrong snippets from the internet, etc.), the model's "attention mechanism" scatters and it starts generating nonsense.

> Hallucination is that gray area between the model's overconfidence and the inadequacy of the context.

LLMs (Large Language Models) work text-based, but code is "structured" data.

* **AST (Abstract Syntax Tree)**: Compilers see code in a tree structure. During training, AI models learn not only the text of the code but also its logical flow in this tree structure.
* **Tokenization Problem**: JSON is great for structuring data but contains too many unnecessary characters (`"`, `:`, `{`, `}`). This needlessly fills the LLM's "Context Window" (i.e. its memory).
* **TOON and Optimized Formats**: Instead of JSON, the industry is leaning towards more "compressed" formats that consume fewer tokens (YAML, TOON, or custom binary representations). This way, more "context" (such as all project files) can be provided to the AI at a lower cost.

> The increase in AI's success is due to this "high-quality context" you provide to it.

## 4. The Architecture of the Future: Vertical AI, Costs, and the MCP Revolution

Training a separate giant AI model (Vertical AI) for every job is not economical. The future lies not in giant models, but in **standardized protocols** (at least until training costs are optimized).

* **The Cost Problem**: Training a trillion-parameter model that only knows "Game Physics" is too expensive.
* **Anthropic MCP (Model Context Protocol)**: This is where initiatives like MCP step in. It allows a general intelligence (General LLM) to connect to your local database, custom tools, or IDE with a standard "socket".

> MCP makes it easy for us to say to the AI model, "you are the expert of this project right now", without doing any fine-tuning.

## 5. The Profession of the Future: Conductorship

The trend shows that in the future, the software developer will not be the one writing the code, but an orchestra conductor managing the agents (AI Agents) that write the code.

* **Instruments**: An agent that optimizes the database, an agent that draws the interface, an agent that writes tests, an agent that looks for vulnerabilities. We could call them `Agent Swarms`.
* **Conductor**: The human, deciding which agent should step in and when, setting the R&D vision, and approving the quality of the resulting work with an "human eye".

> The code AI writes is only as good as the vision we give it.
> Context is king, and the human is the one who wears the crown.

## Real World Examples

Of course, there are other fellow developers who have walked similar paths, but these are entirely my personal experiences. They are the most concrete examples of what AI can do when combined with "human research".

### Ignix: Writing a Redis Clone with Rust and a 25% Performance Increase

As a developer, I decided to write a KV Store akin to Redis to improve my Rust skills. To push myself further, I wanted to focus on a client-agnostic structure.

* **With Just a Prompt**: AI wrote a working Redis server, but there were performance issues. Still, in some situations, there were very small increases compared to Redis. (*You can test it from the commit history*).
* **With Human Research**: The result changed when I read academic papers from ArXiv, analyzed Redis's source code, gathered performance-oriented code snippets, and guided the AI.

**Result**: A structure emerged that runs **25% more performant** than the original Redis in specific scenarios.

> Keeping in mind our respect for Redis's years-long optimizations, this case demonstrates that when correct human guidance (Research) is combined with AI (Implementation), it can even push the industry standard.

* [Ignix](https://github.com/CycleChain/ignix); this project is fully open source. You can examine it, open a PR if you wish to improve it, or leave suggestion feedback in the repo.

<!--
### CyclePack: Writing VFS with Rust

I will share it when the project becomes open source.

-->