;; Event Ticketing Smart Contract in Clarity

;; Define constants
(define-constant OWNER_ADDRESS tx-sender)
(define-constant PRICE_PER_TICKET u100) ;; Price per ticket in microSTX
(define-constant MAXIMUM_TICKET_COUNT u1000) ;; Maximum number of tickets available

;; Data structures
(define-data-var available-ticket-count uint u0)
(define-data-var sold-ticket-count uint u0)
(define-map user-ticket-balance principal uint) ;; Maps principal to number of tickets owned

;; Define NFT trait for tickets
(define-non-fungible-token event-ticket-token uint)

;; Errors
(define-constant ERROR_UNAUTHORIZED (err u100))
(define-constant ERROR_NO_TICKETS_AVAILABLE (err u101))
(define-constant ERROR_INSUFFICIENT_BALANCE (err u102))
(define-constant ERROR_TICKET_NOT_FOUND (err u103))
(define-constant ERROR_TRANSFER_UNSUCCESSFUL (err u104))
(define-constant ERROR_MINT_UNSUCCESSFUL (err u105))

;; Helper function to check if the caller is the contract owner
(define-private (is-owner)
    (is-eq tx-sender OWNER_ADDRESS)
)

;; Issue new tickets (only contract owner can do this)
(define-public (issue-tickets (ticket-quantity uint))
    (begin
        (asserts! (is-owner) ERROR_UNAUTHORIZED)
        (asserts! (<= (+ (var-get available-ticket-count) ticket-quantity) MAXIMUM_TICKET_COUNT) ERROR_NO_TICKETS_AVAILABLE)
        (var-set available-ticket-count (+ (var-get available-ticket-count) ticket-quantity))
        (ok true)
    )
)

;; Buy tickets
(define-public (buy-ticket)
    (let 
        ((current-sold-count (var-get sold-ticket-count)))
        ;; Check if tickets are available
        (asserts! (< current-sold-count (var-get available-ticket-count)) ERROR_NO_TICKETS_AVAILABLE)
        ;; Check if the sender has enough funds
        (asserts! (>= (stx-get-balance tx-sender) PRICE_PER_TICKET) ERROR_INSUFFICIENT_BALANCE)
        ;; Transfer STX from buyer to contract owner
        (match (stx-transfer? PRICE_PER_TICKET tx-sender OWNER_ADDRESS)
            success
                (match (nft-mint? event-ticket-token current-sold-count tx-sender)
                    mint-success
                        (begin
                            ;; Update tickets sold
                            (var-set sold-ticket-count (+ current-sold-count u1))
                            ;; Update tickets owned by the buyer
                            (map-set user-ticket-balance 
                                tx-sender 
                                (+ (default-to u0 (map-get? user-ticket-balance tx-sender)) u1)
                            )
                            (ok true)
                        )
                    mint-error ERROR_MINT_UNSUCCESSFUL
                )
            error ERROR_TRANSFER_UNSUCCESSFUL
        )
    )
)

;; Transfer ticket ownership
(define-public (transfer-ticket (recipient-address principal) (token-id uint))
    (let 
        ((sender-address tx-sender))
        ;; Check if the sender owns the ticket
        (asserts! (is-eq (nft-get-owner? event-ticket-token token-id) (some sender-address)) ERROR_TICKET_NOT_FOUND)
        ;; Transfer the ticket
        (match (nft-transfer? event-ticket-token token-id sender-address recipient-address)
            success
                (begin
                    ;; Update tickets owned by sender and receiver
                    (map-set user-ticket-balance 
                        sender-address 
                        (- (default-to u0 (map-get? user-ticket-balance sender-address)) u1)
                    )
                    (map-set user-ticket-balance 
                        recipient-address 
                        (+ (default-to u0 (map-get? user-ticket-balance recipient-address)) u1)
                    )
                    (ok true)
                )
            error ERROR_TRANSFER_UNSUCCESSFUL
        )
    )
)

;; Get total tickets available
(define-read-only (get-total-tickets)
    (ok (var-get available-ticket-count))
)

;; Get tickets sold
(define-read-only (get-tickets-sold)
    (ok (var-get sold-ticket-count))
)

;; Get tickets owned by a specific principal
(define-read-only (get-tickets-owned (account-address principal))
    (ok (default-to u0 (map-get? user-ticket-balance account-address)))
)

;; Get ticket owner
(define-read-only (get-ticket-owner (token-id uint))
    (ok (nft-get-owner? event-ticket-token token-id))
)