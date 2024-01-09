(namespace (read-string 'ns))
(module gielinorian-world GOVERNANCE
  (use kip.ng-poly-fungible-v1 [account-details])

  ; Schemas

  ; Tables

  ; Capabilities

  (defconst ADMIN-KS:string "gielinorian.admin")

  (defcap GOVERNANCE:bool () (enforce-guard ADMIN-KS))

  (defcap WORLD_OPERATOR:bool (world-id:string)
    (bind (marmalade-ng.ledger.account-guard world-id)
      {
        'guard := guard
      }
      (enforce-guard guard)
    )
  )

  ; Functions

  (defun create-world:bool (token-uri:string account:string guard:guard policies:[module{token-policy-ng-v1}])
    ;(with-capability (GOVERNANCE) ; only add worlds based on governance vote?
      (let
        (
          (world-token-id:string (marmalade-ng.ledger.create-token-id guard token-uri))
        )
        (marmalade-ng.ledger.create-token world-token-id 0 token-uri [] guard)
        (marmalade-ng.ledger.mint world-token-id account guard 1.0)
      )
    ;)
  )

  ; Queries

  (defun get-world:object{account-details} (world-id:string account:string)
    (marmalade-ng.ledger.details world-id account)
  )
)