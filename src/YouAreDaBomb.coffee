_.defaults this,
  YouAreDaBomb: (object, functionNames...) =>
    combinator =
      before: (advice) =>
        for functionName in functionNames
          object[functionName] = (=>
            fn = object[functionName]
            (args...) ->
              advice(args...)
              result = fn.apply(object, args)
              result
          )()
        combinator

      around: (advice) ->
        for functionName in functionNames
          object[functionName] = (=>
            fn = object[functionName]
            (args...) ->
              proceed = (proceededArgs...) -> fn.apply(object, proceededArgs)
              advice(proceed, args...)
          )()
        combinator

      after: (advice) =>
        for functionName in functionNames
          object[functionName] = (=>
            fn = object[functionName]
            (args...) ->
              result = fn.apply(object, args)
              advice(args...)
              result
          )()
        combinator

      beforeAnyCallback: (advice) =>
        for functionName in functionNames
          object[functionName] = (->
            fn = object[functionName]
            (args...) ->
              adviced_args = []
              _.each args, (arg) ->
                new_arg = if _.isFunction(arg)
                    (callback_args...) ->
                      advice(callback_args...)
                      arg(callback_args...)
                  else
                    arg
                adviced_args.push new_arg
              fn.apply(object, adviced_args)
          )()
        combinator


      afterAnyCallback: (advice) =>
        for functionName in functionNames
          object[functionName] = (->
            fn = object[functionName]
            (args...) ->
              adviced_args = []
              _.each args, (arg) ->
                new_arg = if _.isFunction(arg)
                  (callback_args...) ->
                    result = arg(callback_args...)
                    advice(callback_args...)
                    result
                else
                  arg
                adviced_args.push new_arg
              fn.apply(object, adviced_args)
          )()
        combinator
