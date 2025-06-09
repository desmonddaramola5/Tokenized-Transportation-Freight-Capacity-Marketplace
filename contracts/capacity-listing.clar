;; Capacity Listing Contract
;; Manages available freight capacity listings

(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_CAPACITY_NOT_FOUND (err u201))
(define-constant ERR_INVALID_CAPACITY (err u202))
(define-constant ERR_CARRIER_NOT_VERIFIED (err u203))

;; Capacity status
(define-constant STATUS_AVAILABLE u0)
(define-constant STATUS_RESERVED u1)
(define-constant STATUS_BOOKED u2)

;; Data structures
(define-map capacity-listings
  { listing-id: uint }
  {
    carrier-id: principal,
    origin: (string-ascii 50),
    destination: (string-ascii 50),
    capacity-weight: uint,
    capacity-volume: uint,
    available-date: uint,
    expiry-date: uint,
    rate-per-mile: uint,
    status: uint,
    created-at: uint
  }
)

(define-data-var next-listing-id uint u1)

;; Public functions
(define-public (create-capacity-listing
    (origin (string-ascii 50))
    (destination (string-ascii 50))
    (capacity-weight uint)
    (capacity-volume uint)
    (available-date uint)
    (expiry-date uint)
    (rate-per-mile uint))
  (let ((listing-id (var-get next-listing-id)))
    ;; Check if carrier is verified (would call carrier-verification contract)
    (asserts! (> capacity-weight u0) ERR_INVALID_CAPACITY)
    (asserts! (> capacity-volume u0) ERR_INVALID_CAPACITY)
    (asserts! (> expiry-date available-date) ERR_INVALID_CAPACITY)

    (map-set capacity-listings
      { listing-id: listing-id }
      {
        carrier-id: tx-sender,
        origin: origin,
        destination: destination,
        capacity-weight: capacity-weight,
        capacity-volume: capacity-volume,
        available-date: available-date,
        expiry-date: expiry-date,
        rate-per-mile: rate-per-mile,
        status: STATUS_AVAILABLE,
        created-at: block-height
      }
    )
    (var-set next-listing-id (+ listing-id u1))
    (ok listing-id)
  )
)

(define-public (update-capacity-status (listing-id uint) (new-status uint))
  (match (map-get? capacity-listings { listing-id: listing-id })
    listing-data
    (begin
      (asserts! (is-eq (get carrier-id listing-data) tx-sender) ERR_UNAUTHORIZED)
      (map-set capacity-listings
        { listing-id: listing-id }
        (merge listing-data { status: new-status })
      )
      (ok true)
    )
    ERR_CAPACITY_NOT_FOUND
  )
)

(define-public (remove-capacity-listing (listing-id uint))
  (match (map-get? capacity-listings { listing-id: listing-id })
    listing-data
    (begin
      (asserts! (is-eq (get carrier-id listing-data) tx-sender) ERR_UNAUTHORIZED)
      (map-delete capacity-listings { listing-id: listing-id })
      (ok true)
    )
    ERR_CAPACITY_NOT_FOUND
  )
)

;; Read-only functions
(define-read-only (get-capacity-listing (listing-id uint))
  (map-get? capacity-listings { listing-id: listing-id })
)

(define-read-only (get-available-capacity (origin (string-ascii 50)) (destination (string-ascii 50)))
  ;; In a real implementation, this would filter and return multiple listings
  ;; For simplicity, returning a boolean indicating if capacity exists
  (ok true)
)

(define-read-only (get-next-listing-id)
  (var-get next-listing-id)
)
