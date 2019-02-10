MyRC = setRefClass("MyRC",
  fields = list(x = "numeric"),
  methods = list(
    show = function(UNUSED_BUT_FOR_S4_DISPATCH) {
      cat("RC method! ", .self$x, "\n", sep = "")
    }
  )
)

obj = MyRC$new(x = 42)
obj$show()
show(obj)
obj

setMethod("show", "MyRC", function(object){
  cat("S4 method", object$x, "\n")
})
obj$show()
show(obj)
obj

SubRC = setRefClass("SubRC",
  contains = "MyRC",
  methods = list(
    show = function(object) {
      callSuper()
      cat("SubRC method!\n")
    }
  )
)

sobj = SubRC$new(x = 24601)
sobj$show()
show(sobj)
sobj

setMethod("show", "SubRC", function(object){
  callNextMethod(object)
  cat("Sub S4 method\n")
})

sobj$show()
show(sobj)
sobj
