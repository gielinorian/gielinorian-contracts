(namespace (read-msg 'ns ))
(module gielinorian-world GOVERNANCE
  ;;
  ;; Schemas
  ;;

  (defschema world-schema
    world-account:string
    world-guard:guard
    policy:module{kip.token-policy-v2}
    ; currency:module{kip.fungible-v2} ; @todo should be the current world currency
  )

  (defschema item-schema
    world-id:string
    supply:decimal
    max-supply:decimal
    ; attributes
  )

  (deftable items:{item-schema})
  (deftable worlds:{world-schema})

  ;;
  ;; Capabilities
  ;;

  (defcap GOVERNANCE:bool ()
    (enforce-keyset "free.gielinorian-admin")
  )

  (defcap WORLD_GUARD:bool (world-id:string)
    (bind (get-world world-id)
      {
        'world-guard := world-guard
      }
      (enforce-guard world-guard)
    )
  )

  ;;
  ;; Events
  ;;

  (defcap WORLD_CREATED:bool (world-account:string policy:module{kip.token-policy-v2}) ; currency:module{kip.fungible-v2}
    @event
    true
  )

  (defcap WORLD_ITEM_CREATED:bool (token-id:string supply:decimal)
    @event
    true
  )

  (defcap WORLD_ITEM_SUPPLY_UPDATED:bool (token-id:string new-supply:decimal)
    @event
    true
  )

  ;;
  ;; Functions
  ;;

  (defun create-world (world-id:string world-account:string world-guard:guard policy:module{kip.token-policy-v2})
    (with-capability (GOVERNANCE)
      (insert worlds world-id
        {
          'world-account: world-account,
          'world-guard: world-guard,
          'policy: policy
        }
      )
      (emit-event (WORLD_CREATED world-account policy))
    )
  )

  (defun create-world-item (world-id:string token-id:string max-supply:decimal)
    (with-capability (WORLD_GUARD world-id)
      (insert items token-id
        {
          'supply: 0.0,
          'world-id: world-id,
          'max-supply: max-supply
        }
      )
      (emit-event (WORLD_ITEM_CREATED token-id 0.0))
    )
  )

  (defun update-item-supply (token-id:string supply:decimal)
    (with-read items token-id
      {
        'world-id := world-id,
        'max-supply := max-supply
      }
      (with-capability (WORLD_GUARD world-id)
        (update items token-id
          {
            'supply: supply
          }
        )
        (emit-event (WORLD_ITEM_SUPPLY_UPDATED token-id supply))
      )
    )
  )

  ;;
  ;; Getters
  ;;

  (defun get-world (world-id:string)
    (with-read worlds world-id
      {
        'world-account := world-account,
        'world-guard := world-guard,
        'policy := policy
      }
      {
        'world-account: world-account,
        'world-guard: world-guard,
        'policy: policy
      }
    )
  )

  (defun get-item (token-id:string)
    (with-read items token-id
      {
        'world-id := world-id,
        'supply := supply,
        'max-supply := max-supply
      }
      {
        'world-id: world-id,
        'supply: supply,
        'max-supply: max-supply
      }
    )
  )
)

(if (read-msg 'upgrade )
  ["upgrade complete"]
  [
    (create-table items)
    (create-table worlds)
  ]
)