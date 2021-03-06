window.App = Ember.Application.create()

App.LazyDataSource = Ember.ArrayProxy.extend
  objectAt: (idx) ->
    row = @get('content')[idx]
    return row if row
    row =
      num:    idx
      start:  '01/01/2009'
      finish: '01/05/2009'
      title:  'Task ' + idx
      duration: '5 days'
      effortDriven: (idx % 5 == 0)
    @get('content')[idx] = row
    row

App.SimpleTableController = Ember.Table.TableController.extend
  hasHeader: yes
  hasFooter: no
  numFixedColumns: 1
  numRows: 100000
  rowHeight: 30

  columnNames: Ember.computed ->
    ['num', 'start', 'finish', 'title', 'duration', 'effortDriven']
  .property()

  columns: Ember.computed ->
    @get('columnNames').map (key, index) ->
      Ember.Table.ColumnDefinition.create
        index: index
        headerCellName: key
        getCellContent: (row) -> row[key]
  .property()

  content: Ember.computed ->
    App.LazyDataSource.create
      content: new Array(@get('numRows'))
  .property 'numRows'

App.ApplicationView = Ember.View.extend
  classNames: 'ember-app'
  templateName: 'application'

App.ApplicationController = Ember.Controller.extend
  tableController : Ember.computed ->
    App.SimpleTableController.create()
  .property()
