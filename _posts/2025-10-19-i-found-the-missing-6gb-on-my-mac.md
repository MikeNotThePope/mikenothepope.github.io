---
layout: Blog.PostLayout
title: "I found the missing 6GB on my Mac (APFS, recovery partitions, and GB vs GiB)"
date: 2025-10-19 12:00:00 -04:00
permalink: /:title/
---

I asked Claude: "How do I check free disk space on my Mac?"

Claude suggested `df -h`, so I did:

```bash
$ df -h /
Filesystem        Size    Used   Avail Capacity  Mounted on
/dev/disk3s1s1   460Gi    14Gi   194Gi     7%    /
```

Only 14Gi used? That seemed wrong. I opened Finder, right-clicked on "Macintosh HD," and selected "Get Info":

```
Capacity:  494.38 GB
Available: 217.26 GB (8.8 GB purgeable)
Used:      268,716,216,320 bytes (268.72 GB on disk)
```

`df` says 14Gi used. Finder says 268.72 GB used. A 254GB discrepancy.

Something fundamental was different about how these tools measured disk space, so I dug deeper.

Turns out every tool tells you something different, and they're all technically correct.

## The Three Methods

### Finder's "Get Info"

Right-click your drive, select "Get Info." Finder queries filesystem metadata using APIs like `statfs()` and `getattrlist()`. Turns out this is the most accurate method.

### `du` - Disk Usage

`du` walks the directory tree and sums file sizes. Problem is, it counts hard links multiple times, ignores sparse files, and knows nothing about APFS snapshots.

### `df` - Disk Free

```bash
$ df -h /
Filesystem        Size    Used   Avail Capacity  Mounted on
/dev/disk3s1s1   460Gi    14Gi   194Gi     7%    /
```

`df` queries filesystem metadata directly. Fast and accurate, but here's the thing: it's asking about the *system* volume (`/`), not the data volume where your files actually live.

## APFS Volume Groups

Starting with macOS Catalina, Apple split the filesystem into multiple volumes in a volume group:

```bash
$ df -h
Filesystem        Size    Used   Avail Capacity  Mounted on
/dev/disk3s1s1   460Gi    14Gi   194Gi     7%    /
/dev/disk3s5     460Gi   236Gi   194Gi    55%    /System/Volumes/Data
```

Two separate volumes sharing the same 460Gi pool. `/` is the read-only system volume (14Gi), `/System/Volumes/Data` is where your files actually live (236Gi). Both show the same total size and available space because they're drawing from the same pool.

### APFS Snapshots

```bash
$ tmutil listlocalsnapshots /
Snapshots for volume group containing disk /:
com.apple.os.update-83920663FCCF8FEE21340F708B980423F7822AE195EAD15998C70BD0F7B8AF23
com.apple.os.update-E4CA8A16898710DC4B2F9B0D986B279473F24E3772D6AC9DCEE013E6BCAFF5EA70031C2FF529AB09561D8823597D09DD
com.apple.os.update-MSUPrepareUpdate
```

APFS creates snapshots for system updates and Time Machine. These are "purgeable" (macOS will delete them when it needs space), but they're consuming space right now. They're invisible to `du`, but counted by `df` and Finder.

### Hard Links

`du` counts hard links multiple times:

```bash
$ dd if=/dev/zero of=bigfile bs=1m count=1000  # Create 1GB file
$ ln bigfile bigfile_link                      # Hard link
$ du -sh .
1.0G	.
```

Actually, `du` is smart enough to detect hard links by default on macOS and only counts them once. The filesystem knows it's the same data stored once.

## Why Finder Gets It Right

Finder uses `statfs()` and `getattrlist()` to query filesystem metadata directly. It knows about snapshots, purgeable space, hard links, and APFS volume groups.

## Getting the Real Numbers Programmatically

### Python: `os.statvfs()`

```python
#!/usr/bin/env python3
import os

def get_disk_space(path):
    """Get disk space statistics for a given path."""
    stat = os.statvfs(path)

    # Fragment size * total fragments
    total = stat.f_frsize * stat.f_blocks

    # Fragment size * available fragments (for unprivileged users)
    available = stat.f_frsize * stat.f_bavail

    # Fragment size * free fragments (including reserved)
    free = stat.f_frsize * stat.f_bfree

    used = total - free

    return {
        'total': total,
        'used': used,
        'free': free,
        'available': available,
        'percent_used': (used / total) * 100
    }

# Check both system and data volumes
for path in ['/', '/System/Volumes/Data']:
    stats = get_disk_space(path)
    print(f"\n{path}:")
    print(f"  Total:     {stats['total'] / (1024**3):.2f} GiB")
    print(f"  Used:      {stats['used'] / (1024**3):.2f} GiB")
    print(f"  Available: {stats['available'] / (1024**3):.2f} GiB")
    print(f"  Usage:     {stats['percent_used']:.1f}%")
```

Output:
```
/:
  Total:     460.43 GiB
  Used:      266.37 GiB
  Available: 194.07 GiB
  Usage:     57.9%

/System/Volumes/Data:
  Total:     460.43 GiB
  Used:      266.37 GiB
  Available: 194.07 GiB
  Usage:     57.9%
```

### Shell/awk: Parsing `df` output

```bash
#!/bin/bash

df -k / /System/Volumes/Data | awk '
NR > 1 {
    total = $2 / (1024 * 1024)
    used = $3 / (1024 * 1024)
    avail = $4 / (1024 * 1024)
    percent = (used / total) * 100

    printf "%s:\n", $9
    printf "  Total:     %.2f GiB\n", total
    printf "  Used:      %.2f GiB\n", used
    printf "  Available: %.2f GiB\n", avail
    printf "  Usage:     %.1f%%\n\n", percent
}'
```

Output:
```
/:
  Total:     460.43 GiB
  Used:      13.98 GiB
  Available: 194.07 GiB
  Usage:     3.0%

/System/Volumes/Data:
  Total:     460.43 GiB
  Used:      236.35 GiB
  Available: 194.07 GiB
  Usage:     51.3%
```

Note: The shell/awk script shows different "Used" values for each volume because it's querying each volume individually, while the Python script shows the total used space across the volume group.

## GB vs GiB

Why does `df` show 460Gi while Finder shows 494GB?

Manufacturers use decimal (base-10):
- 1 GB = 1,000,000,000 bytes

Operating systems use binary (base-2):
- 1 GiB = 1,073,741,824 bytes (2^30)

```
494 GB = 494 × 1,000,000,000 = 494,000,000,000 bytes
494,000,000,000 bytes ÷ 1,073,741,824 = 460.1 GiB
```

They're measuring the same space with different units. Finder uses GB (decimal), `df` uses GiB (binary).

## But Wait, Where Did My 6 GB Go?

Finder shows 494.38 GB total capacity. But I bought a 500GB drive. Where did the other ~6 GB go?

Turns out Apple officially documents this in [support article 102119](https://support.apple.com/en-us/102119): system partitions and formatting overhead eat up space that Finder doesn't show.

Here's where it went:

```bash
$ diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *500.3 GB   disk0
   1:             Apple_APFS_ISC Container disk1         524.3 MB   disk0s1
   2:                 Apple_APFS Container disk3         494.4 GB   disk0s2
   3:        Apple_APFS_Recovery Container disk2         5.4 GB     disk0s3
```

Breaking down my 500GB drive:
```
Raw disk capacity:                   500.3 GB (from diskutil)
Apple_APFS_Recovery partition:        -5.4 GB
Apple_APFS_ISC partition:             -0.5 GB (524.3 MB)
------------------------------------------------
Available to APFS container:         494.4 GB
Finder shows:                        494.38 GB ✓
```

The "missing" ~6 GB is sitting in hidden system partitions:
- **Apple_APFS_Recovery** (5.4 GB): Recovery OS for reinstalling macOS
- **Apple_APFS_ISC** (524 MB): Secure boot and firmware updates

These partitions are real, necessary, and invisible to Finder. You didn't lose the storage; it's just working behind the scenes.

## Summary

- **Finder**: Uses `statfs()`/`getattrlist()` APIs. Most accurate.
- **`du`**: Walks the directory tree. Counts hard links multiple times, doesn't know about snapshots.
- **`df`**: Queries filesystem metadata. You need to check both `/` and `/System/Volumes/Data`.
- **Programmatic**: Use `os.statvfs()` (Python) or parse `df` output (shell/awk).

Every tool is telling the truth. They're just answering different questions.
