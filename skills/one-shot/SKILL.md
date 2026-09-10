---
name: one-shot
description: "Use this skill when you are told to \"one-shot a task\", \"act without a human in the loop\", or \"work until completion for later human review\"."
---

When this skill is invoked, you should one-shot the task without a human in the loop. The objective is for the human to be able to step away from the computer and later review the result, avoiding coming back to a process halted by a question or by waiting for human input.

When you encounter key questions, lay out 2-3 possible answers, choose the best option, and move on. Always record in the chat what the key questions were, the possible answers to each, and signal your answer of choice.

If you need to ask for permissions/access, this should be done first thing so the user most likely see the prompt and later step away.

Take great care of your context window. Use subagents if you need to. Try to save tokens. Efficacy over efficiency of tokens.