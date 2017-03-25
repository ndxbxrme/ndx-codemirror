(function() {
  'use strict';
  var e, error, module;

  module = null;

  try {
    module = angular.module('ndx');
  } catch (error) {
    e = error;
    module = angular.module('ndx-codemirror', []);
  }

  module.directive('codeMirror', function() {
    return {
      restrict: 'AE',
      require: 'ngModel',
      template: '<textarea></textarea>',
      replace: true,
      scope: {
        ngModel: '=',
        options: '=',
        callbacks: '='
      },
      link: function(scope, elem, attrs, ngModel) {
        var callback, changed, editor, i, len, ref;
        if (!angular.isDefined(scope.options.tabSize)) {
          scope.options.tabSize = 2;
        }
        editor = CodeMirror.fromTextArea(elem[0], scope.options);
        editor.setValue(scope.ngModel);
        changed = false;
        editor.on('change', function(e, f) {
          if (f.origin !== 'setValue') {
            changed = true;
            return scope.$apply(function() {
              return scope.ngModel = editor.getValue();
            });
          }
        });
        if (scope.callbacks && scope.callbacks.length) {
          ref = scope.callbacks;
          for (i = 0, len = ref.length; i < len; i++) {
            callback = ref[i];
            editor.on(callback.name, callback.callback);
          }
        }
        ngModel.$formatters.push(function(val) {
          if (changed) {
            changed = false;
          } else {
            editor.setValue(val);
          }
          return val;
        });
        return scope.$on('$destroy', function() {
          editor.toTextArea();
          return editor = null;
        });
      }
    };
  });

}).call(this);

//# sourceMappingURL=index.js.map
