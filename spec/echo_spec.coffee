_              = require('underscore')
{ Echo, echo } = require('../src/echo.coffee')

chai      = require('chai')
sinon     = require('sinon')
sinonChai = require('sinon-chai')

chai.should()
chai.use(sinonChai)

describe 'Echo', ->

  it 'should be defined', ->
    Echo.should.exist

  it 'should be function', ->
    Echo.should.be.a 'function'

  it 'should returns function', ->
    Echo().should.be.a 'function'


  e = null

  beforeEach ->
    e = Echo()


  describe 'main function', ->

    it 'should log strings', ->
      e('test')
      log = e.logs.first()
      log.should.be.a 'object'
      log.body.should.be.an('array')
      log.body[0].should.eq 'test'

    it 'should save passed options', ->
      e('test', level: 4, namespace: 'qwerty')
      log = e.logs.first()
      log.namespace.should.eq 'qwerty'
      log.level.should.eq 4

    it 'should not save options to body', ->
      e('test', level: 4, namespace: 'qwerty')
      log = e.logs.first()
      _(log.body[1]).isUndefined().should.eq true

    it 'should add timestamp to log', ->
      e('test')
      log = e.logs.first()
      log.timestamp.should.exist
      log.timestamp.should.be.a 'number'
      log.timestamp.toString().length.should.eq 13


  describe '#logs', ->

    it 'should be defined', ->
      e.logs.should.exist

    it 'should be object', ->
      e.logs.should.be.a 'object'


    describe '#first()', ->

      it 'should be defined', ->
        e.logs.first.should.exist

      it 'should be function', ->
        e.logs.first.should.be.a 'function'

      it 'should return first log', ->
        e('test1')
        e('test2')
        logs = e.logs.first()
        logs.body[0].should.eq 'test1'


    describe '#all()', ->

      it 'should be defined', ->
        e.logs.all.should.exist

      it 'should be function', ->
        e.logs.all.should.be.a 'function'

      it 'should returns all logs', ->
        e('test1')
        e('test2')
        allLogs = e.logs.all()
        allLogs.should.be.an 'array'
        allLogs[0].body[0].should.eq 'test1'
        allLogs[1].body[0].should.eq 'test2'


  describe '#defaultOptions', ->

    it 'should be defined', ->
      e.defaultOptions.should.exist

    it 'should be object', ->
      e.defaultOptions.should.be.a 'object'

    it 'should containt default options', ->
      e.defaultOptions.level.should.eq           0
      e.defaultOptions.namespace.should.eq       ''
      e.defaultOptions.namespacePrefix.should.eq ''

    it 'should apply default options to each log', ->
      e('test1')
      log = e.logs.first()
      log.level.should.eq e.defaultOptions.level
      namespace = ''
      unless _(e.defaultOptions.namespacePrefix).isEmpty()
        namespace += e.defaultOptions.namespacePrefix + '.'
      namespace += e.defaultOptions.namespace
      log.namespace.should.eq namespace


  describe '#curry()', ->

    it 'should be defined', ->
      e.curry.should.exist

    it 'should return function', ->
      e.curry().should.be.a 'function'

    it 'should return carried function', ->
      fn = e.curry(level: 5, namespace: 'qwe')
      fn('LOL')
      log1 = e.logs.first()
      log1.body[0].should.eq 'LOL'
      log1.level.should.eq 5
      log1.namespace.should.eq 'qwe'
      fn('w00t', namespace: 'asd')
      log2 = e.logs.all()[1]
      log2.body[0].should.eq 'w00t'
      log2.level.should.eq 5
      log2.namespace.should.eq 'asd'


  describe '#define()', ->

    it 'should be defined', ->
      e.define.should.exist

    it 'should be function', ->
      e.define.should.be.a 'function'

    it 'should add new function to echo'


  describe '#defineDefaults()', ->

    it 'should be defined', ->
      e.defineDefaults.should.exist


  describe 'echo()', ->

    it 'should be defined', ->
      echo.should.exist

    it 'should predefine default levels', ->
      echo.debug.should.exist
      echo.info.should.exist
      echo.warn.should.exist
      echo.error.should.exist