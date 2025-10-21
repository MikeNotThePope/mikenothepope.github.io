---
layout: Blog.PostLayout
title: "7 Things I Learned Building a Rate-Limited MCP Server in Elixir"
date: 2025-10-21 01:00:00 -04:00
permalink: /:title/
---

As part of learning about how AI coding tools work, I keep hearing about [MCP](https://en.wikipedia.org/wiki/Model_Context_Protocol) servers.  I was curious what they do, so I built one.  This post is about 7 things I learned.

## 1. An MCP Server Is Just A Regular Program

Once you get behind the fancy jargon, an MCP server is just a regular program.  It receives requests and serves responses.  Sure, you have to learn how to follow the MCP conventions, but when you learn that, there's nothing magical about it.  Just like HTTP servers process HTTP requests, MCP servers process MCP requests.

## 2.  MCP Is A Standardized Way For Giving Your AI Chat Thingy (e.g. Claude Code) Tools It Didn't Come With

Want ChatGPT to search your database? MCP Server. Want Claude Code to access your GitHub repos, run terminal commands, or read your local files? MCP Server. Want your AI assistant to pull data from Slack, Notion, or your company's internal APIs? MCP Server.

## 3. Your AI Tool Already Has (Or Soon Will Have) An MCP Client Built In

ChatGPT, Claude Code, and other AI assistants come with an MCP client baked in. You don't need to install anything extra on the AI side—it already knows how to talk to MCP servers. You just point it at your MCP server, and it handles the rest.

## 4. The Client and Server Talk Using JSON-RPC Over Standard I/O or HTTP

MCP uses JSON-RPC for communication—just structured JSON messages back and forth. The connection itself is typically either standard input/output (stdin/stdout) for local processes or HTTP for remote servers.

## 5. Your MCP Server Advertises Its Tools On Startup

When the client connects, the MCP server sends over a list of tools it offers—their names, descriptions, and what parameters they expect. The AI now knows what capabilities it has available and can call those tools as needed during your conversation.

## 6. The Request Flow Is Simple: Ask, Call, Return, Answer

Think of it like a sequence diagram with four actors:

**On startup:**
- MCP Host → MCP Server: "What tools do you have?"
- MCP Server → MCP Host: "I have get_records, do_thing, etc."

**When you ask a question:**
- You → MCP Host: "What's in my database?"
- MCP Host → LLM: "User asked about database. Available tools: get_records..."
- LLM → MCP Host: "Call get_records with limit=10"
- MCP Host → MCP Server: JSON-RPC request for get_records
- MCP Server → MCP Host: Returns the data
- MCP Host → LLM: "Here's the data from get_records"
- LLM → MCP Host: "Your database contains 100 items..."
- MCP Host → You: "Your database contains 100 items..."

The LLM decides *what* to do. The MCP host does the actual calling.

## 7. Your MCP Server Can Have Whatever Middleware You Want

Since it's just a regular program, you can add anything between the request and your data source. I didn't want to hammer my database every time the AI got curious, so I added a rate limiter (5 requests per 10 seconds) plus a caching layer. The LLM will happily call your tool 50 times in a row if you let it.

## In Summary

I created [Hit Me DB One More Time](https://github.com/MikeNotThePope/hit_me_db_one_more_time), an MCP server in Elixir that demonstrates the plugin pipeline pattern. It has a SQLite database with 100 sample records, a `get_records` tool for pagination, and a middleware pipeline with rate limiting (5 req/10s), caching (30s TTL), and logging. Requests flow through the pipeline where each plugin can pass through, short-circuit, or modify the context. Check it out if you want to see how it all fits together.

