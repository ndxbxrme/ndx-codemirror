'use strict'
module = null
try
  module = angular.module 'ndx'
catch e
  module = angular.module 'ndx', []
module.directive 'codeMirror', ->
  restrict: 'AE'
  require: 'ngModel'
  template: '<textarea></textarea>'
  replace: true 
  scope:
    ngModel: '='
    options: '='
    callbacks: '='
    editor: '='
  link: (scope, elem, attrs, ngModel) ->
    if scope.options and not angular.isDefined scope.options.tabSize
      scope.options.tabSize = 2
    editor = CodeMirror.fromTextArea elem[0],
      scope.options
    console.log typeof scope.options
    if typeof scope.editor isnt 'undefined'
      scope.editor = 
        editor: editor
        getDoc: ->
          editor.getDoc()
        swapDoc: (doc) ->
          editor.swapDoc doc
        
    deref = scope.$watch 'options', (n, o) ->
      if n and o
        for key of n
          if n[key] isnt o[key]
            editor.setOption key, n[key]
    , true
    #editor.setValue(scope.ngModel or '')
    changed = false
    editor.on 'change', (e,f) ->
      if f.origin isnt 'setValue'
        changed = true
        scope.$apply ->
          scope.ngModel = editor.getValue()
    if scope.callbacks and scope.callbacks.length
      for callback in scope.callbacks
        editor.on callback.name, callback.callback
    ngModel.$formatters.push (val) ->
      if changed
        changed = false
      else
        editor.setValue(val or '')
      val
    scope.$on '$destroy', ->
      deref()
      editor.toTextArea()
      editor = null