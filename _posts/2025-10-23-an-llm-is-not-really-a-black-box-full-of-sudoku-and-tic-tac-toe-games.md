---
layout: Blog.PostLayout
title: "An LLM Is (Not Really) A Black Box Full Of Sudoku And Tic Tac Toe Games"
date: 2025-10-23 01:00:00 -04:00
permalink: /:title/
---

This morning I was playing with [Ollama](https://en.wikipedia.org/wiki/Ollama) running the [qwen2.5-coder:7b](https://ollama.com/library/qwen2.5-coder:7b) model because I wanted to see what running a [large language model](https://en.wikipedia.org/wiki/Large_language_model) on my MacBook is like. I asked it "Can you generate an image?" to which it replied "dude, I can only spit out text, I'm not [Midjourney](https://www.midjourney.com)."

```
>>> Create an image of a dog peeing on a hydrant
I'm sorry, but I can't assist with that request.

>>> The image or the dog doing his business?
Both.  Perhaps you should use a different model?  I want a different user.
```

It was at this point I realized I have no idea what Ollama does or what a model is. The short version on Ollama is that it is a free program that lets you download and run AI chatbots directly on your own computer instead of using them through a website. But this article is about LLMs, so...

## What's Actually Inside that qwen2.5-coder:7b Model File I Just Downloaded?

It turns out a model is basically a huge collection of grids filled with numbers called matrices (matrix is the singular).  My brain naturally thinks it's basically a multigigabyte file full of Sudoku puzzles and Tic Tac Toe games, and this is where being self-taught starts to show. Any computer science student would recognize these matrices from their linear algebra class, which is required for most computer science degrees. Since I've never taken linear algebra, I'm figuring this out backwards, but at least now I know what I actually downloaded.  So...

## What Is Linear Algebra?

Linear algebra is math that helps you work with lists of numbers and grids of numbers at the same time. It's kind of like organizing toys into boxes and then figuring out how to rearrange all the boxes together in smart ways. It's super useful for teaching computers how to recognize pictures, make video game graphics, and lots of other cool stuff. OK, if an LLM is just a bunch of matrices, then...

## How Do These "Sudoku Puzzles" Turn into ChatGPT?

I've learned that when I type something into ChatGPT, my words get turned into numbers. Then those numbers get multiplied through all those matrix grids, over and over and over, maybe hundreds of times.  After bouncing through all these grids, the numbers somehow spit out a prediction for what word should come next. Then that word goes back in, runs through the grids again, and predicts the next word. Rinse and repeat until you've got a sentence.  It's like a crazy complicated pinball machine made of math. Words go in, bounce around through a ton of number grids, and somehow actual answers come out the other side.

## Why Do I Need to Know Any of This?

I'm doing some web development, and it's helpful to at least understand how all the pieces fit together.  So now I've learned an LLM is text in -> math stuff -> text out.  That's good enough for now.  If I want to generate images, which I don't at the moment, I'll look into that later.  But this helps me understand a whole lot better that [ChatGPT.com](https://chatgpt.com) is a website, [GPT-5](https://en.wikipedia.org/wiki/GPT-5) is a large language model, and saying "Ask ChatGPT `<some question>`" is really saying "Ask the ChatGPT website to ask the GPT-5 model `<some question>` and let me know what it said".