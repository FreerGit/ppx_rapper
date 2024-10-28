include
  Rapper.RAPPER_HELPER
    with type 'a fiber := 'a Lwt.t
     and module Stream = Caqti_lwt.Stream
