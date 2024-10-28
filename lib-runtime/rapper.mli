module type CUSTOM = sig
  type t

  val t : t Caqti_type.t
end

val load_many :
  ('row -> 'parent) * ('parent -> 'key) ->
  (('row -> 'child) * ('parent -> 'child list -> 'parent)) list ->
  'row list ->
  'parent list

module Internal : sig
  module Dynparam : sig
    type t = Pack : 'a Caqti_type.t * 'a -> t

    val empty : t
    val add : 'a Caqti_type.t -> 'a -> t -> t
  end
end

module type IO = sig
  type +'a t

  val return : 'a -> 'a t
  val map : ('a -> 'b) -> 'a t -> 'b t

  (* Need this for Caqti_connection_sig.S *)
  module Stream : Caqti_stream_sig.S with type 'a fiber := 'a t
end

module type RAPPER_HELPER = sig
  type +'a fiber

  val map : ('a -> 'b) -> 'a fiber -> 'b fiber
  val fail : 'e -> ('a, 'e) result fiber

  module Stream : Caqti_stream_sig.S with type 'a fiber := 'a fiber

  module type CONNECTION =
    Caqti_connection_sig.S
      with type 'a fiber := 'a fiber
       and type ('a, 'err) stream := ('a, 'err) Stream.t
end

module Make_helper (Io : IO) :
  RAPPER_HELPER with type 'a fiber := 'a Io.t and module Stream = Io.Stream
