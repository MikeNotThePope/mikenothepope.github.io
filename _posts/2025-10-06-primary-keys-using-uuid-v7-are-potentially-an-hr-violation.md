---
layout: Blog.PostLayout
title: "Primary keys using UUID v7 are (potentially) an HR violation"
date: 2025-10-06 00:00:00 +00:00
permalink: /:title/
---

I'm building an applicant tracking system where I use [UUID v7](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_7_(timestamp_and_random)) for primary keys on the users table. Then I discovered an unintended consequence: UUID v7 embeds a timestamp, which creates a privacy leak. If a user's account was created in 2025 with an ID of `0199b901-fb2b-7745-9e62-019fe1c0ddca`, anyone can extract that timestamp and infer a minimum age for the user. The older the account, the older we know the applicant must be, enabling unintentional age discrimination through what should be an opaque identifier.

## The Problem

UUID v7 embeds a timestamp in its first 48 bits. Anyone can extract it:

```elixir
defmodule DinosaurDetector do
  # Assume youngest applicant is 14.
  # If application > 16 years old,
  # they must be 30+ now (14 + 16).
  def old?(datetime) do
    years = DateTime.diff(
      DateTime.utc_now(),
      datetime,
      :year
    )
    years > 16
  end
end

# ID created in 2025
iex> id = UUID.uuid7()
"0199b901-fb2b-7745-9e62-019fe1c0ddca"

# Extract embedded timestamp
iex> <<ts::48, _::80>> =
  UUID.string_to_binary!(id)
iex> applied =
  DateTime.from_unix!(ts, :millisecond)
~U[2025-10-06 10:12:18.859Z]

# In 2041, this is 16 years old
iex> DinosaurDetector.old?(applied)
true
```

In an ATS, that timestamp reveals when someone applied. Since I'm building the best ATS in the world, I should assume my users will be around long enough to be discriminated against. Someone who applied in 2025 shouldn't be discriminated against in 2041 just because their ID is older than ChatGPT. But if their ID says they applied in 2025, and it's now 2041, that UUID becomes a timestamp that says "this person is old."

## It's Not Just UUID v7

Any time-sortable ID has this problem:

**[Snowflake IDs](https://en.wikipedia.org/wiki/Snowflake_ID):**
```elixir
iex> id = 495890505138176
iex> ts = Bitwise.bsr(id, 22) +
  1_288_834_974_657
iex> applied =
  DateTime.from_unix!(ts, :millisecond)
~U[2025-10-06 10:12:18.859Z]

iex> DinosaurDetector.old?(applied)
true
```

**[MongoDB ObjectIDs](https://en.wikipedia.org/wiki/MongoDB#Object_ID):**
```elixir
iex> id = "6702538a0000000000000000"
iex> <<ts::32, _::96>> =
  Base.decode16!(id, case: :lower)
iex> applied =
  DateTime.from_unix!(ts, :second)
~U[2025-10-06 10:12:18Z]

iex> DinosaurDetector.old?(applied)
true
```

[ULID](https://en.wikipedia.org/wiki/Universally_unique_identifier#ULID), KSUID, and Instagram IDs all encode timestamps for database performance too. They work well for indexes but violate [age discrimination laws](https://en.wikipedia.org/wiki/Age_Discrimination_in_Employment_Act_of_1967).

## The Fix

**Use UUID v4 for applicant records:**
```elixir
iex> id = UUID.uuid4()
"f81d4fae-7dec-11d0-a765-00a0c91e6bf6"

# Try to extract timestamp
# (meaningless from random data)
iex> <<ts::48, _::80>> =
  UUID.string_to_binary!(id)
iex> applied =
  DateTime.from_unix!(ts, :millisecond)
~U[5623-10-21 00:54:32.000Z]

iex> DinosaurDetector.old?(applied)
false  # Immune!
```

**Use UUID v7 for non-sensitive data:**
```elixir
job_posting_id = UUID.uuid7()
interview_id = UUID.uuid7()
```

**Or encrypt time-sortable IDs before exposing them:**
```elixir
defmodule SecureID do
  # Simplified - needs proper key
  # management in production
  def encrypt(uuid) do
    key = :crypto.strong_rand_bytes(32)

    :crypto.crypto_one_time(
      :aes_256_cbc,
      key,
      uuid,
      true
    )
    |> Base.encode64()
  end
end

internal = UUID.uuid7()
public = SecureID.encrypt(internal)
```

## The Lesson

By optimizing for database performance, I would be creating a compliance risk. UUID v7 identifiers leak everywhere: URLs, logs, API responses, analytics. Unlike `created_at` fields, they're treated as opaque when they actually contain information.

The ATS should not encode protected characteristics in its identifiers.

I'll use UUID v4 for applicant IDs. The database team will grumble about performance. I'll sleep well. That's the tradeoff.

