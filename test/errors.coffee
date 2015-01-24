require './setup'

describe 'Errors', ->
  err = null

  beforeEach ->
    try
      js2coffee('a\nb\nc\nd\nx())\ne\nf')
    catch e
      err = e

  it 'throws them properly', ->
    expect(err.message).include ':5:4: Unexpected token )'

  it 'has start line/column', ->
    expect(err.start.line).eql 5
    expect(err.start.column).eql 4

describe 'Error cases', ->
  it 'happens on "with" statements', ->
    expect ->
      js2coffee('with (x) { b(); }')
    .to.throw /'with' is not supported/

  it 'happens on break-less cases', ->
    expect ->
      js2coffee('switch (x) { case "a": b(); case "b": c(); }')
    .to.throw /No break or return statement found in a case/

  it 'catches reserved words in var', ->
    expect ->
      js2coffee('var off = 2')
    .to.throw /'off' is a reserved CoffeeScript keyword/

  it 'catches reserved words in assignment', ->
    expect ->
      js2coffee('off = 2')
    .to.throw /'off' is a reserved CoffeeScript keyword/

  it 'catches reserved words in function params', ->
    expect ->
      js2coffee('function x(off){}')
    .to.throw /'off' is a reserved CoffeeScript keyword/
