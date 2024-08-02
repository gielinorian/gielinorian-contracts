(module event-store GOVERNANCE

    (use free.util-lists)

    ; Schema

    (defschema event
        module-hash:string
        name:string
        params:list
        height:integer
    )

    (deftable events:{event})

    ; Capabilities

    (defcap GOVERNANCE:bool () true)

    (defcap TEST_EVENT:bool ()
        @event
        true
    )

    ; Functions

    (defun generate-event-key-hash:string (event:object{event})
        (hash {
            'module-hash: (at "module-hash" event),
            'name: (at "name" event),
            'params: (at "params" event),
            'height: (at "height" event)
        })
    )

    (defun append:[object{event}] (event-list:list)
        (map  
            (lambda (event)
                (let*
                    (
                        (block-event
                            {
                                'module-hash: (at "module-hash" event),
                                'name: (at "name" event),
                                'params: (at "params" event),
                                'height: (at "block-height" (chain-data))
                            }
                        )
                        (event-key:string (generate-event-key-hash block-event))
                    )
                    (write events event-key block-event)
                )
            )
            event-list
        )
        (get-events)
    )

    (defun fire:bool ()
        (emit-event (TEST_EVENT))
    )

    ; Getters

    (defun get-events:[object{event}] ()
        (select events (constantly true))
    )

    (defun event-exist:bool (event:object{event})
        (let
            (
                (event-key:string (generate-event-key-hash event))
            )
            (contains event-key (keys events))
        )
    )

    (defun get-module-events:[object{event}] (module-hash:string)
        (select events (where (= "module-hash" module-hash)))
    )

    (defun get-module-events-by-name:[object{event}] (module-hash:string name:string)
        (select events (where (and (= "module-hash" module-hash) (= "name" name))))
    )
)

(create-table events)