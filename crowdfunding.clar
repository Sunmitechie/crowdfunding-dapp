(define-data-var total-projects uint 0)
(define-map project-data 
  { project-id: uint } 
  { owner: principal, goal: uint, raised: uint, deadline: uint, is-funded: bool })
(define-map pledges 
  { project-id: uint, backer: principal } 
  { amount: uint })

;; Error Codes:
;; u100 - Project not found
;; u101 - Deadline has passed
;; u102 - Goal already met
;; u103 - Insufficient funds
;; u104 - Unauthorized
;; u105 - No pledge found

(define-public (create-project (goal uint) (deadline uint))
  (let ((id (+ (var-get total-projects) u1)))
    (asserts! (> goal u0) (err u103))
    (asserts! (> deadline block-height) (err u101))
    (map-insert project-data 
      { project-id: id } 
      { owner: tx-sender, goal: goal, raised: u0, deadline: deadline, is-funded: false })
    (var-set total-projects id)
    (ok { message: "Project created", project-id: id })))

(define-public (pledge-funds (project-id uint) (amount uint))
  (let ((project (map-get? project-data { project-id: project-id })))
    (match project
      value
      (begin
        (asserts! (<= block-height (get deadline value)) (err u101))
        (asserts! (not (get is-funded value)) (err u102))
        (asserts! (>= amount u1) (err u103))

        (map-set project-data { project-id: project-id }
          { owner: (get owner value), goal: (get goal value), 
            raised: (+ (get raised value) amount), 
            deadline: (get deadline value), 
            is-funded: (>= (+ (get raised value) amount) (get goal value)) })

        (map-insert pledges { project-id: project-id, backer: tx-sender } 
          { amount: amount })
        (ok { message: "Funds pledged", project-id: project-id, amount: amount })))
      (err u100))))

(define-public (withdraw-funds (project-id uint))
  (let ((project (map-get? project-data { project-id: project-id })))
    (match project
      value
      (begin
        (asserts! (is-eq (get owner value) tx-sender) (err u104))
        (asserts! (get is-funded value) (err u102))
        (map-delete project-data { project-id: project-id })
        (ok { message: "Funds withdrawn", project-id: project-id }))
      (err u100))))

(define-public (refund-pledge (project-id uint))
  (let ((project (map-get? project-data { project-id: project-id })))
    (match project
      value
      (begin
        (asserts! (>= block-height (get deadline value)) (err u101))
        (asserts! (not (get is-funded value)) (err u102))

        (let ((pledge (map-get? pledges { project-id: project-id, backer: tx-sender })))
          (match pledge
            pledge-value
            (begin
              (map-delete pledges { project-id: project-id, backer: tx-sender })
              (ok { message: "Pledge refunded", amount: (get amount pledge-value) }))
            (err u105)))))
      (err u100))))
