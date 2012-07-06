_              = require('underscore')
{ Echo, echo } = require('../src/echo.coffee')

chai           = require('chai')
sinon          = require('sinon')
sinonChai      = require('sinon-chai')

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
      log.cid.should.eq 'qwerty'
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

    it 'should accept string levels'

    it 'should join namespacePrefix and id and save as cid', ->
      e(namespacePrefix: 'app', id: 42)
      e.logs.first().cid.should.eq 'app.42'

    it 'should join namespace and id and save as cid', ->
      e(namespace: 'test', id: 42)
      e.logs.first().cid.should.eq 'test.42'

    it 'should join namespacePrefix and namespace and save as cid', ->
      e(namespacePrefix: 'app', namespace: 'test')
      e.logs.first().cid.should.eq 'app.test'

    it 'should join namespacePrefix, namespace and id and save as cid', ->
      e(namespacePrefix: 'app', namespace: 'test', id: 42)
      e.logs.first().cid.should.eq 'app.test.42'


  describe 'clone on log', ->

    it 'should clone objects on log (but not deeply)', ->
      obj =
        qwe: 1
        asd: 2
        obj: qwe: 1, asd: 2
      e(obj)
      e.logs.first().body[0].should.not.equal obj
      e.logs.first().body[0].obj.should.equal obj.obj

    it 'should clone arrays on log (but not deeply)', ->
      array = [[1, 2], 3, 4]
      e(array)
      e.logs.first().body[0].should.not.equal array
      e.logs.first().body[0][0].should.equal array[0]


  describe 'logs search', ->

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

    describe '#grep()', ->

      it 'should be defined'

      it 'should be function'

      it 'should returns array'

      it 'should grep string in logs'


  describe 'define new log functions', ->

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
        log1.cid.should.eq 'qwe'
        fn('w00t', namespace: 'asd')
        log2 = e.logs.all()[1]
        log2.body[0].should.eq 'w00t'
        log2.level.should.eq 5
        log2.cid.should.eq 'asd'

      it 'should allow to pass body', ->
        fn = e.curry('LOL', level: 5)
        fn()
        log1 = e.logs.first()
        log1.body[0].should.eq 'LOL'
        log1.level.should.eq 5

        fn('w00t', namespace: 'asd')
        log2 = e.logs.all()[1]
        log2.body[0].should.eq 'LOL'
        log2.body[1].should.eq 'w00t'
        log2.cid.should.eq 'asd'

        fn2 = e.curry(1, 2, 3, 4, level: 9)
        fn2('trololo', level: 6)
        log3 = e.logs.all()[2]

        log3.body[0].should.eq 1
        log3.body[1].should.eq 2
        log3.body[2].should.eq 3
        log3.body[3].should.eq 4
        log3.body[4].should.eq 'trololo'
        log3.level.should.eq 6


    describe '#define()', ->

      it 'should be defined', ->
        e.define.should.exist

      it 'should be function', ->
        e.define.should.be.a 'function'

      it 'should add new function to echo', ->
        e.define('info', 1)
        e.info.should.exist
        e.info.should.be.a 'function'
        e.define(warn: 2, error: 3)
        e.warn.exist
        e.warn.should.be.a 'function'
        e.error.should.exist
        e.error.should.be.a 'function'

      it 'should return curried function with defined level', ->
        e.define('info', 1)
        e.info('w00t', namespace: 'qwerty')
        log = e.logs.first()
        log.body[0].should.eq 'w00t'
        log.level.should.eq 1
        log.cid.should.eq 'qwerty'


  describe 'dump logs', ->

    describe '#dump()', ->

      it 'should be defined', ->
        e.dump.should.exist

      it 'should be function', ->
        e.dump.should.be.a 'function'

      it 'should dump logs into JSON', ->
        e('trololo')
        e('qwerty')
        e.dump().should.be.a 'string'
        restored = JSON.parse(e.dump())
        restored.should.be.a 'array'
        restored[0].body[0].should.eq 'trololo'
        restored[1].body[0].should.eq 'qwerty'


    describe '#restore()', ->

      it 'should be defined'

      it 'should be function'

      it 'should restore logs from dump'

    describe 'restore on initialization', ->

      it 'should restore log on initialization'


  describe 'defaults', ->

    describe '#defaultOptions', ->

      it 'should be defined', ->
        e.defaultOptions.should.exist

      it 'should be object', ->
        e.defaultOptions.should.be.a 'object'

      it 'should containt default options', ->
        e.defaultOptions.clone.should.eq           true
        e.defaultOptions.level.should.eq           0
        e.defaultOptions.namespacePrefix.should.eq ''
        e.defaultOptions.namespace.should.eq       ''
        e.defaultOptions.id.should.eq              ''

      it 'should apply default options to each log', ->
        e('test1')
        log = e.logs.first()
        log.level.should.eq e.defaultOptions.level
        log.cid.should.eq ''


    describe '#defineDefaults()', ->

      it 'should be defined', ->
        e.defineDefaults.should.exist

      it 'should be function', ->
        e.defineDefaults.should.be.a 'function'

      it 'should add defaults to logger', ->
        _(e.debug).isUndefined().should.eq true
        _(e.info).isUndefined().should.eq true
        _(e.warn).isUndefined().should.eq true
        _(e.error).isUndefined().should.eq true
        e.defineDefaults()
        e.debug.should.exist
        e.info.should.exist
        e.warn.should.exist
        e.error.should.exist


    describe 'echo()', ->

      it 'should be defined', ->
        echo.should.exist

      it 'should predefine default levels', ->
        echo.debug.should.exist
        echo.info.should.exist
        echo.warn.should.exist
        echo.error.should.exist
