'use strict'
module = null
try
  module = angular.module 'ndx'
catch e
  module = angular.module 'ndx-codemirror', []
module.directive 'codeMirror', ->
  restrict: 'AE'
  require: 'ngModel'
  template: '<textarea></textarea>'
  replace: true
  scope:
    ngModel: '='
    options: '='
    callbacks: '='
  link: (scope, elem, attrs, ngModel) ->
    if scope.options and not angular.isDefined scope.options.tabSize
      scope.options.tabSize = 2
    editor = CodeMirror.fromTextArea elem[0],
      scope.options
    editor.setValue scope.ngModel
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
        editor.setValue val
      val
    scope.$on '$destroy', ->
      editor.toTextArea()
      editor = null