# 🎟️ Eventure Smart Contract

**Eventure** is a decentralized event ticketing system built on the Stacks blockchain using the Clarity smart contract language. It enables organizers to issue and sell limited-edition NFT-based tickets, while giving attendees full ownership and transfer rights to their tickets — all on-chain.

---

## 🚀 Key Features

* **NFT-Based Ticketing**: Each ticket is minted as a unique non-fungible token (NFT).
* **Secure Payments**: Tickets are purchased using STX with automatic payment transfer to the event organizer.
* **Limited Supply**: Cap the number of tickets available for any event to prevent overselling.
* **Verified Ownership**: Ticket ownership is stored on-chain and can be queried by anyone.
* **Transferable Tickets**: Ticket holders can securely transfer ownership to others.

---

## 📜 Contract Components

### 📌 Constants

* `CONTRACT_OWNER`: Deployer of the contract with privileges to issue tickets.
* `TICKET_PRICE`: Fixed cost of each ticket (in microSTX).
* `MAX_TICKETS`: Maximum tickets available for the event.

### 📦 Data Variables

* `total-tickets`: Total tickets issued.
* `tickets-sold`: Count of tickets already purchased.
* `tickets-owned`: A map tracking how many tickets each principal holds.

### 🧩 NFT Definition

* `ticket-nft`: The non-fungible token representing each ticket.

### 🚫 Errors

Predefined error codes handle unauthorized access, sold-out conditions, insufficient funds, and invalid transfers.

---

## 🛠️ Public Functions

### 🎫 `issue-tickets (amount)`

Event organizer issues new tickets. Fails if it exceeds the maximum cap.

### 💰 `buy-ticket`

Allows users to purchase a ticket:

* Ensures availability.
* Transfers STX to organizer.
* Mints a new ticket NFT.
* Updates buyer's ticket ownership.

### 🔄 `transfer-ticket (to, ticket-id)`

Transfers a specific ticket NFT to another user.

---

## 📖 Read-Only Functions

* `get-total-tickets`: Returns total tickets issued.
* `get-tickets-sold`: Returns number of tickets sold.
* `get-tickets-owned (owner)`: Returns the number of tickets owned by a principal.
* `get-ticket-owner (ticket-id)`: Returns the current owner of a specific ticket.

---

## ✅ Use Cases

* Music festivals and concerts
* Conferences and tech meetups
* Private or members-only events
* Sports or eSports tournaments

---

## 🔐 Security Notes

* Only the contract owner can issue tickets.
* All NFT minting and transfers are validated with ownership checks.
* STX transfers are atomic and integrated with ticket issuance.

---

## 📎 Example Flow

1. **Organizer deploys Eventure**
2. **Organizer issues 500 tickets**
3. **Users purchase tickets via `buy-ticket`**
4. **Attendees can transfer tickets using `transfer-ticket`**
5. **Ownership can be verified via `get-ticket-owner`**

---

## 🧠 Powered By

* **Clarity Language** – Predictable smart contracts on the Stacks blockchain
* **Stacks Blockchain** – Secure smart contracts and Bitcoin integration

---

## 📩 License

This contract is open-source and available under the [MIT License](LICENSE).