(namespace (read-string "ns"))
(enforce-keyset (read-keyset (+ (read-string "ns") ".gielinorian-admin")))
(module gielinorian-world GOVERNANCE
  (use kip.ng-poly-fungible-v1 [account-details])
  (use n_442d3e11cfe0d39859878e5b1520cd8b8c36e5db.ledger [create-token-id create-token mint details account-guard])

  ; Schemas
  (defschema world-detail
    world-id:string
    account:string
  )

  ; Tables
  (deftable worlds:{world-detail})

  ; Capabilities

  (defconst ADMIN-KS:string "gielinorian.admin")

  (defcap GOVERNANCE:bool () (enforce-guard ADMIN-KS))

  (defcap WORLD_OPERATOR:bool (world-id:string)
    (bind (account-guard world-id)
      {
        'guard := guard
      }
      (enforce-guard guard)
    )
  )

  ; Events

  (defcap WORLD_CREATED (world-id:string)
    @event
    true
  )

  ; Functions

  (defun create-world:bool (token-uri:string account:string guard:guard policies:[module{token-policy-ng-v1}])
    ;(with-capability (GOVERNANCE) ; only add worlds based on governance vote?
      (let
        (
          (world-token-id:string (create-token-id guard token-uri))
        )
        (create-token world-token-id 0 token-uri [] guard)
        (mint world-token-id account guard 1.0)
        (emit-event (WORLD_CREATED world-token-id))
      )
    ;)
  )

  ; Queries

  (defun get-world:object{account-details} (world-id:string account:string)
    (details world-id account)
  )
)