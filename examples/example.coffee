class A
  bar: ->
    alert("bar")

a = new A()

Before(a, 'bar', ->
  alert("foo")
)

a.bar()
