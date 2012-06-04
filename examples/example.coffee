class A
  bar: ->
    alert("bar")

a = new A()

YouAreDaBomb(a, 'bar').before(->
  alert("foo")
)

a.bar()
