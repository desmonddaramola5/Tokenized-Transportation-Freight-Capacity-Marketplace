;; Carrier Verification Contract
;; Validates and manages freight carrier registrations

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_CARRIER_EXISTS (err u101))
(define-constant ERR_CARRIER_NOT_FOUND (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Carrier status types
(define-constant STATUS_PENDING u0)
(define-constant STATUS_VERIFIED u1)
(define-constant STATUS_SUSPENDED u2)

;; Data structures
(define-map carriers
  { carrier-id: principal }
  {
    company-name: (string-ascii 100),
    license-number: (string-ascii 50),
    status: uint,
    verification-date: uint,
    verifier: principal
  }
)

(define-map carrier-documents
  { carrier-id: principal, doc-type: (string-ascii 20) }
  { document-hash: (buff 32), upload-date: uint }
)

(define-data-var next-carrier-id uint u1)

;; Public functions
(define-public (register-carrier (company-name (string-ascii 100)) (license-number (string-ascii 50)))
  (let ((carrier-id tx-sender))
    (asserts! (is-none (map-get? carriers { carrier-id: carrier-id })) ERR_CARRIER_EXISTS)
    (map-set carriers
      { carrier-id: carrier-id }
      {
        company-name: company-name,
        license-number: license-number,
        status: STATUS_PENDING,
        verification-date: u0,
        verifier: CONTRACT_OWNER
      }
    )
    (ok carrier-id)
  )
)

(define-public (verify-carrier (carrier-id principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? carriers { carrier-id: carrier-id })
      carrier-data
      (begin
        (map-set carriers
          { carrier-id: carrier-id }
          (merge carrier-data {
            status: STATUS_VERIFIED,
            verification-date: block-height,
            verifier: tx-sender
          })
        )
        (ok true)
      )
      ERR_CARRIER_NOT_FOUND
    )
  )
)

(define-public (suspend-carrier (carrier-id principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? carriers { carrier-id: carrier-id })
      carrier-data
      (begin
        (map-set carriers
          { carrier-id: carrier-id }
          (merge carrier-data { status: STATUS_SUSPENDED })
        )
        (ok true)
      )
      ERR_CARRIER_NOT_FOUND
    )
  )
)

(define-public (upload-document (doc-type (string-ascii 20)) (document-hash (buff 32)))
  (begin
    (asserts! (is-some (map-get? carriers { carrier-id: tx-sender })) ERR_CARRIER_NOT_FOUND)
    (map-set carrier-documents
      { carrier-id: tx-sender, doc-type: doc-type }
      { document-hash: document-hash, upload-date: block-height }
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-carrier (carrier-id principal))
  (map-get? carriers { carrier-id: carrier-id })
)

(define-read-only (is-carrier-verified (carrier-id principal))
  (match (map-get? carriers { carrier-id: carrier-id })
    carrier-data (is-eq (get status carrier-data) STATUS_VERIFIED)
    false
  )
)

(define-read-only (get-carrier-document (carrier-id principal) (doc-type (string-ascii 20)))
  (map-get? carrier-documents { carrier-id: carrier-id, doc-type: doc-type })
)
