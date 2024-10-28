include
  Rapper.RAPPER_HELPER
    with type 'a fiber := 'a Async.Deferred.t
     and module Stream = Caqti_async.Stream
