(namespace (read-msg 'ns ))
(module gielinorian-item-policy GOVERNANCE

  (implements kip.token-policy-v1)
  (use kip.token-policy-v1 [token-info])
  (use kip.token-manifest [manifest])
  (use free.gielinorian-world [create-world-item get-item update-item-supply])

  ;;
  ;; Capabilities
  ;;

  (defcap GOVERNANCE:bool ()
    (enforce-keyset "free.gielinorian-admin")
  )

  ;;
  ;; Events
  ;;
  
  (defcap ITEM_MINTED:bool (token-id:string current-supply:decimal minter:string)
    @event
    true
  )
  
  (defcap ITEM_CREATED:bool (token-id:string manifest:object{manifest})
    @event
    true
  )

  ;;
  ;; Functions
  ;;

  (defun enforce-ledger:bool ()
    (enforce-guard (marmalade.ledger.ledger-guard))
  )

  ;;
  ;; Policy
  ;;

  (defun enforce-mint:bool (token:object{token-info} account:string guard:guard amount:decimal)
    (enforce-ledger)
    (with-capability (GOVERNANCE)
      (enforce (>= amount 0.0) "Invalid amount")
      (let*
        (
          (token-id:string (at 'id token))
          (item (get-item token-id))
          (supply:decimal (at 'supply item))
          (max-supply:decimal (at 'max-supply item))
          (new-supply:decimal (+ supply amount))
        )
        (enforce (or (<= new-supply max-supply) (= max-supply -1.0)) "max supply exceeded")
        (update-item-supply token-id new-supply)
        (emit-event (ITEM_MINTED token-id new-supply account))
      )
    )
  )

  (defun enforce-burn:bool (token:object{token-info} account:string amount:decimal)
    @doc "Burning policy for TOKEN to ACCOUNT for AMOUNT."
    @model [
        (property (!= account ""))
        (property (> amount 0.0))
    ]
    false
  )

  (defun enforce-init:bool (token:object{token-info})
    (enforce-ledger)
    ; validate if the token exist in the world-collection
    (get-item (at 'id token))
  )

  (defun enforce-offer:bool (token:object{token-info} seller:string amount:decimal sale-id:string)
    (enforce-guard (marmalade.ledger.ledger-guard))
    false
  )

  (defun enforce-buy:bool (token:object{token-info} seller:string buyer:string buyer-guard:guard amount:decimal sale-id:string)
    (enforce-guard (marmalade.ledger.ledger-guard))
    false
  )

  (defun enforce-transfer:bool (token:object{token-info} sender:string guard:guard receiver:string amount:decimal)
    (enforce-guard (marmalade.ledger.ledger-guard))
    true
  )

  (defun enforce-crosschain:bool (token:object{token-info} sender:string guard:guard receiver:string target-chain:string amount:decimal)
    (enforce-guard (marmalade.ledger.ledger-guard))
    false
  )
)

(if (read-msg 'upgrade )
  ["upgrade complete"]
  []
)
