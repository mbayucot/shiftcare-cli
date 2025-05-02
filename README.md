# ShiftCare CLI

A Dockerized Ruby command-line tool that allows you to search through client data and identify duplicate email entries.

---

## Features

- Search for clients by partial name match
- Detect duplicate client emails
- Built on `dry-transaction` for clean, composable service operations — ensures better error handling and separation of business logic
- RSpec test suite for reliability
- RuboCop for code quality enforcement
- Fully Dockerized with Docker Compose support

---

## Prerequisites

- Docker
- Docker Compose

---

## Setup

```bash
make build           # Build the Docker image
make install         # Install Ruby gems inside the container
```

---

## Usage

To search clients by name:

```bash
make run-search
```

To check for duplicate emails:

```bash
make run-duplicates
```

To open an interactive shell inside the container:

```bash
make sh
```

---

## Assumptions and Decisions Made

- Client data is expected to come from a static `clients.json` file at the project root.
- Searches are currently limited to matching client names only.
- Duplicate detection is based strictly on matching email fields.

---

## Known Limitations

- Only supports searching by name — no support for email or ID field search yet.
- Does not validate email formats.
- Designed for small-to-medium datasets (fits comfortably in memory).

---

## Areas for Future Improvement

- Accept arbitrary JSON fields for dynamic searching. This will allow users to search not only by name but also by email, ID, or any other field in the JSON dataset, making the tool more flexible and useful in real-world data exploration.
- Add pagination support to prevent overwhelming output when dealing with large datasets.
- Add Bluprinter for lightweight serialization and better formatting of CLI output (e.g. nicely aligned name/email fields), which improves readability without introducing heavy dependencies.
- Validate and normalize data (e.g. lowercase, strip, email format checks).
- Improve CLI to support additional flags/args (e.g. --field name --query foo).
