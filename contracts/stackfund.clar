;; Crowdfunding Smart Contract in Clarity
;; ---------------------------------------------------------
;; Features:
;; - Users can contribute STX
;; - Owner can claim funds if goal met & deadline passed
;; - Contributors can refund if goal not met & deadline passed
;; ---------------------------------------------------------

(define-data-var funding-goal uint u1000)       ;; Goal in microstacks (e.g., 1000 uSTX = 0.001 STX)
(define-data-var deadline uint u50)             ;; Deadline block height
(define-data-var total-raised uint u0)          ;; Total contributions
(define-data-var owner principal tx-sender)     ;; Project owner (set to deployer)

;; Track contributions per user
(define-map contributions
  { contributor: principal }
  { amount: uint })

;; ---------------------------------------------------------
;; Public function: contribute STX
;; ---------------------------------------------------------
(define-public (contribute (amount uint))
  (begin
    (if (is-eq amount u0)
        (err u100) ;; Error: zero contribution
        (let (
              (transfer-result (stx-transfer? amount tx-sender (as-contract tx-sender)))
             )
          (if (is-ok transfer-result)
              (begin
                ;; Add contribution to storage
                (map-set contributions 
                  {contributor: tx-sender} 
                  {amount: (+ (default-to u0 (get amount (map-get? contributions {contributor: tx-sender}))) amount)})
                ;; Update total raised
                (var-set total-raised (+ (var-get total-raised) amount))
                (ok true)
              )
              (err u101) ;; Error: transfer failed
          )
        )
    )
  )
)

;; ---------------------------------------------------------
;; Public function: claim funds
;; Only owner can call this if goal met and deadline passed
;; ---------------------------------------------------------
(define-public (claim-funds)
  (begin
    (if (and (is-eq tx-sender (var-get owner))
             (>= (var-get total-raised) (var-get funding-goal))
             (>= stacks-block-height (var-get deadline)))
        (stx-transfer? (var-get total-raised) tx-sender (var-get owner))
        (err u101) ;; Not allowed
    )
  )
)

;; ---------------------------------------------------------
;; Public function: refund contributors
;; Contributors get refunds if goal not met after deadline
;; ---------------------------------------------------------
(define-public (refund)
  (match (map-get? contributions {contributor: tx-sender})
    contrib-tuple
    (if (and (< (var-get total-raised) (var-get funding-goal))
             (>= stacks-block-height (var-get deadline)))
        (let ((amount (get amount contrib-tuple)))
          (match (stx-transfer? amount (var-get owner) tx-sender)
            transfer-ok
            (begin
              (map-delete contributions {contributor: tx-sender})
              (ok true)
            )
            transfer-err
            (err u103)
          )
        )
        (err u102) ;; Refund not available
    )
    (err u102) ;; Refund not available
  )
)
