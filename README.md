# 💸 MyPayments

A SwiftUI digital‑banking demo: a **payment transfer service** that moves funds
between accounts on a platform — with validation, robust error handling, an audit
trail, and durable persistence. Built with **The Composable Architecture (TCA)**
and **SwiftData**.

---

## ✨ Features

- **Account‑to‑account transfers** — pick a **source** + **destination** account and an amount.
- **Sufficient‑funds validation** before any money moves.
- **Comprehensive, typed errors** — invalid amount, same account, account not found, currency mismatch, insufficient funds.
- **Atomic & idempotent** — transfers can't race or double‑charge (safe against retries/double‑taps).
- **Audit trail** — every transfer is recorded (from → to · amount · date) and **persists across launches**.
- **Email sign‑in**, card UI with a flip animation, and a one‑tap **balance reset** for testing.

---

## 🏗 Architecture

Clean, layered, dependency‑inward design (**Presentation → Domain → Data**), with an
**MVVM‑Coordinator shell** and a **TCA “island”** for the authenticated feature.

```
Data/        value‑type models (Account, Money, TransactionRecord) + SwiftData @Model rows
Domain/
  Service/   TransferService  — business rules (shape validation)
  Repository TransferRepository — data‑access seam, delegates to…
  ModelActor ModelActor (+Transfer) — the SwiftData boundary (atomic commit)
  State/     ApplicationState — app‑level finite state machine
Presentation/
  Clients/   PaymentClient, SessionClient — TCA dependencies (struct of closures)
  Home/      HomeFeature + HomeView      — audit trail
  Transfer/  TransferFeature + TransferView — source/dest/amount
  ApplicationFlows/ — coordinator, auth routing
```

### How a transfer flows
```
TransferFeature → PaymentClient → TransferService → TransferRepository → ModelActor.commit
                                  (validate shape)   (seam)              (atomic: funds + debit/credit + record + save)
```

### Key design decisions
- **Value types in the domain, `@Model` only at the edge.** Entities are `Sendable`
  value types (safe across actors & in TCA state); SwiftData `@Model` rows never leave
  the actor — the boundary maps between them.
- **Atomicity via actor isolation.** The funds‑check + debit/credit + save happen in one
  `ModelActor` method with no suspension points, so concurrent transfers can't interleave.
- **Idempotency** via a per‑request id — a replay returns the original record.
- **Struct‑of‑closures dependencies** (TCA convention) — easy single‑endpoint overrides
  in tests/previews; the swappable abstraction lives in the domain protocols.

---

## 🧰 Tech stack

- **SwiftUI** · **The Composable Architecture (TCA)** · **SwiftData** · **Swift Concurrency (actors)**
- Xcode 26 · iOS 26 · Swift 6

---

## ▶️ Build & run

1. `git clone git@github.com:applesakota/MyPayments.git`
2. Open `MyPayments.xcodeproj` in Xcode.
3. Let Swift Package Manager resolve **swift‑composable‑architecture**.
4. Build & run on an iOS simulator.

> Sign in with any email → you start with a seeded account + a few platform accounts.
> Tap **+** to transfer, **⋯ → Reset balance** to start over.
